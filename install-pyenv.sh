#!/bin/bash
set -e

echo "=== Multi‑Python pyenv Environment Builder ==="
echo

# ------------------------------------------------------------
# 0. Install system dependencies for building Python
# ------------------------------------------------------------
echo "Installing system build dependencies..."
sudo apt install -y \
    make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    llvm libncursesw5-dev xz-utils tk-dev libxml2-dev \
    libxmlsec1-dev libffi-dev liblzma-dev git
echo

# ------------------------------------------------------------
# 1. Install pyenv if missing (no .bashrc modification)
# ------------------------------------------------------------
if [ ! -d "$HOME/.pyenv" ]; then
    echo "Cloning pyenv..."
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
else
    echo "pyenv already installed."
fi
echo

PYENV="$HOME/.pyenv/bin/pyenv"
PYENV_ROOT="$HOME/.pyenv"

# ------------------------------------------------------------
# 2. Ensure Python versions exist
# ------------------------------------------------------------
for VER in 2.7.18 3.11.2 3.12.1; do
    if ! $PYENV versions --bare | grep -q "^$VER$"; then
        echo "Python $VER not found in pyenv. Installing..."
        $PYENV install "$VER"
    else
        echo "Python $VER already installed."
    fi
done
echo

# ------------------------------------------------------------
# 3. Define interpreters explicitly
# ------------------------------------------------------------
PY27="$PYENV_ROOT/versions/2.7.18/bin/python"
PIP27="$PYENV_ROOT/versions/2.7.18/bin/pip"

PY311="$PYENV_ROOT/versions/3.11.2/bin/python3"
PIP311="$PYENV_ROOT/versions/3.11.2/bin/pip"

PY312="$PYENV_ROOT/versions/3.12.1/bin/python3"
PIP312="$PYENV_ROOT/versions/3.12.1/bin/pip"

echo "Python 2.7.18 interpreter: $PY27"
echo "Python 3.11.2 interpreter: $PY311"
echo "Python 3.12.1 interpreter: $PY312"
echo

# ------------------------------------------------------------
# 4. Upgrade pip in Python 3.x interpreters
# ------------------------------------------------------------
echo "Upgrading pip in 3.11.2..."
$PIP311 install --upgrade pip
echo

echo "Upgrading pip in 3.12.1..."
$PIP312 install --upgrade pip
echo

# Python 2 pip bootstrap (safe)
if [ ! -x "$PIP27" ]; then
    echo "Bootstrapping pip for Python 2.7.18..."
    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o /tmp/get-pip.py
    $PY27 /tmp/get-pip.py
    rm /tmp/get-pip.py
else
    echo "pip already available for Python 2.7.18."
fi
echo

# ------------------------------------------------------------
# 5. Install general modules into Python 3.11.2
# ------------------------------------------------------------
install_311() {
    PKG="$1"
    if $PY311 - <<EOF 2>/dev/null
import $PKG
EOF
    then
        echo "$PKG already installed in 3.11.2."
    else
        echo "Installing $PKG into 3.11.2..."
        $PIP311 install --upgrade "$PKG"
        echo "$PKG installed."
    fi
    echo
}

echo "=== Installing general modules into Python 3.11.2 ==="
install_311 pyserial
install_311 reportlab
install_311 setuptools
install_311 wheel

# ------------------------------------------------------------
# Install playsound using manual setup.py (idempotent)
# ------------------------------------------------------------
echo "Checking playsound installation in 3.11.2..."

if $PY311 - <<EOF 2>/dev/null
import playsound
EOF
then
    echo "playsound already installed in 3.11.2."
else
    echo "Installing playsound into 3.11.2 using legacy setup.py..."

    TMPDIR=$(mktemp -d)
    cd "$TMPDIR"

    wget -q https://files.pythonhosted.org/packages/source/p/playsound/playsound-1.3.0.tar.gz
    tar xf playsound-1.3.0.tar.gz
    cd playsound-1.3.0

    $PY311 setup.py install

    echo "Verifying playsound import under Python 3.11.2..."
    if $PY311 - <<EOF 2>/dev/null
import playsound
EOF
    then
        echo "playsound installed successfully in 3.11.2."
    else
        echo "ERROR: playsound failed to import under 3.11.2."
        exit 1
    fi

    cd /
    rm -rf "$TMPDIR"
fi

echo

# ------------------------------------------------------------
# 6. Install PlatformIO into Python 3.12.1
# ------------------------------------------------------------
echo "=== Installing PlatformIO into Python 3.12.1 ==="

PENV="$HOME/.platformio/penv"

if [ -d "$PENV" ]; then
    if ! "$PENV/bin/python3" -c "import platformio" 2>/dev/null; then
        echo "WARNING: PlatformIO venv is corrupted."
        echo "Rebuilding PlatformIO venv..."
        rm -rf "$PENV"
        $PIP312 install --upgrade platformio
        $PYENV exec pio system info >/dev/null
    else
        echo "PlatformIO venv OK."
    fi
else
    echo "PlatformIO venv missing — installing..."
    $PIP312 install --upgrade platformio
    $PYENV exec pio system info >/dev/null
fi
echo

# ------------------------------------------------------------
# 7. Final verification
# ------------------------------------------------------------
echo "Final verification:"
echo "python2.7:  $PY27"
echo "python3.11: $PY311"
echo "python3.12: $PY312"
echo "pip2.7:     $PIP27"
echo "pip3.11:    $PIP311"
echo "pip3.12:    $PIP312"
echo "PlatformIO: $($PYENV which pio)"
echo

echo "=== Module inventory for Python 2.7.18 ==="
$PIP27 list
echo

echo "=== Module inventory for Python 3.11.2 ==="
$PIP311 list
echo

echo "=== Module inventory for Python 3.12.1 ==="
$PIP312 list
echo

echo "=== Multi‑Python pyenv environment is healthy ==="
echo "Done!"
