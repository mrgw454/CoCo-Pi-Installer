#!/bin/bash
set -e

REPAIR_MODE=false

# ------------------------------------------------------------
# Parse optional flags
# ------------------------------------------------------------
for arg in "$@"; do
    case "$arg" in
        --repair)
            REPAIR_MODE=true
            ;;
    esac
done

echo "=== Python 3.12.1 pyenv Environment Builder ==="
echo "Repair mode: $REPAIR_MODE"
echo

# ------------------------------------------------------------
# 0. Verify pyenv exists
# ------------------------------------------------------------
if ! command -v pyenv >/dev/null 2>&1; then
    echo "ERROR: pyenv is not installed or not in PATH."
    exit 1
fi

# ------------------------------------------------------------
# 1. Ensure Python 3.12.1 is installed in pyenv
# ------------------------------------------------------------
if ! pyenv versions --bare | grep -q "^3.12.1$"; then
    echo "Python 3.12.1 not found in pyenv. Installing..."
    pyenv install 3.12.1
else
    echo "Python 3.12.1 already installed."
fi

# ------------------------------------------------------------
# 2. Activate Python 3.12.1 for this directory
# ------------------------------------------------------------
echo "Setting pyenv local version to 3.12.1..."
pyenv local 3.12.1

PY312=$(pyenv which python3)
PIP312=$(pyenv which pip)

echo "Using Python interpreter: $PY312"
$PY312 -V
echo

# ------------------------------------------------------------
# 3. Upgrade pip (safe, idempotent)
# ------------------------------------------------------------
echo "Upgrading pip..."
$PIP312 install --upgrade pip

# ------------------------------------------------------------
# 4. Install required Python modules (idempotent)
# ------------------------------------------------------------
install_pkg() {
    PKG="$1"
    if $PY312 - <<EOF 2>/dev/null
import $PKG
EOF
    then
        echo "$PKG already installed."
    else
        echo "Installing $PKG..."
        $PIP312 install --upgrade "$PKG"
        echo "$PKG installed."
    fi
    echo
}

install_pkg pyserial
install_pkg reportlab
install_pkg setuptools
install_pkg wheel
install_pkg playsound

# abimap is special — verify import AND CLI
echo "Installing/upgrading abimap..."
$PIP312 install --upgrade abimap
echo

# ------------------------------------------------------------
# 5. Verify abimap import
# ------------------------------------------------------------
echo "Verifying abimap import..."
if ! $PY312 -c "import abimap" 2>/dev/null; then
    echo "ERROR: abimap failed to import under Python 3.12.1"
    exit 1
fi
echo "abimap import OK."

# ------------------------------------------------------------
# 6. Verify abimap CLI resolves to pyenv version
# ------------------------------------------------------------
ABIMAP_BIN=$(pyenv which abimap)
echo "abimap resolves to: $ABIMAP_BIN"

if [[ "$ABIMAP_BIN" != *"/.pyenv/versions/3.12.1/"* ]]; then
    echo "WARNING: abimap CLI is NOT coming from pyenv Python 3.12.1"
    echo "Likely stale system abimap in ~/.local/bin"
    if [ "$REPAIR_MODE" = true ]; then
        echo "Repair mode active — removing stale system abimap..."
        rm -f "$HOME/.local/bin/abimap"
    else
        echo "Run with --repair to fix this."
        exit 1
    fi
fi

echo "abimap CLI OK."
echo

# ------------------------------------------------------------
# 7. PlatformIO venv health check
# ------------------------------------------------------------
echo "Checking PlatformIO environment..."

PENV="$HOME/.platformio/penv"

if [ -d "$PENV" ]; then
    if ! "$PENV/bin/python3" -c "import platformio" 2>/dev/null; then
        echo "WARNING: PlatformIO venv is corrupted."
        if [ "$REPAIR_MODE" = true ]; then
            echo "Repair mode active — rebuilding PlatformIO venv..."
            rm -rf "$PENV"
            $PIP312 install --upgrade platformio
            pyenv exec pio system info >/dev/null
        else
            echo "Run with --repair to rebuild PlatformIO venv."
            exit 1
        fi
    else
        echo "PlatformIO venv OK."
    fi
else
    echo "PlatformIO venv missing — installing..."
    $PIP312 install --upgrade platformio
    pyenv exec pio system info >/dev/null
fi

echo
echo "Final verification:"
echo "python3: $(pyenv which python3)"
echo "pip:      $(pyenv which pip)"
echo "abimap:   $(pyenv which abimap)"
echo "PlatformIO: $(pyenv which pio)"
echo

echo "=== Python 3.12.1 pyenv environment is healthy ==="
echo "Done!"
