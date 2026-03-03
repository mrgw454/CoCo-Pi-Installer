#!/bin/bash
set -e

echo "=== Multi‑Python pyenv Environment Builder (Hardened) ==="
echo

# ------------------------------------------------------------
# 0. Force a clean pyenv environment inside this script
# ------------------------------------------------------------
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

# Ignore any local .python-version files
unset PYENV_VERSION

# Initialize pyenv shims and hooks (no .bashrc needed)
if [ -f "$PYENV_ROOT/bin/pyenv" ]; then
    eval "$($PYENV_ROOT/bin/pyenv init -)"
fi

PYENV="$PYENV_ROOT/bin/pyenv"

echo "pyenv initialized inside script."
echo

# ------------------------------------------------------------
# 1. Install system dependencies
# ------------------------------------------------------------
echo "Installing system build dependencies..."
sudo apt install -y \
    make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    llvm libncursesw5-dev xz-utils tk-dev libxml2-dev \
    libxmlsec1-dev libffi-dev liblzma-dev git
echo

# ------------------------------------------------------------
# 2. Install pyenv if missing
# ------------------------------------------------------------
if [ ! -d "$PYENV_ROOT" ]; then
    echo "Cloning pyenv..."
    git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
else
    echo "pyenv already installed."
fi
echo

# ------------------------------------------------------------
# 3. Ensure Python versions exist
# ------------------------------------------------------------
for VER in 2.7.18 3.11.2 3.12.1; do
    if ! $PYENV versions --bare | grep -q "^$VER$"; then
        echo "Python $VER not found. Installing..."
        $PYENV install "$VER"
    else
        echo "Python $VER already installed."
    fi
done
echo

# ------------------------------------------------------------
# 4. Set global versions (critical!)
# ------------------------------------------------------------
echo "Setting global Python versions..."
$PYENV global 3.11.2 3.12.1
$PYENV rehash
echo "Global versions set to: 3.11.2 (default), 3.12.1 (tools)"
echo

# ------------------------------------------------------------
# 5. Define interpreters explicitly
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
# 6. Upgrade pip in Python 3.x
# ------------------------------------------------------------
echo "Upgrading pip in 3.11.2..."
$PIP311 install --upgrade pip
echo

echo "Upgrading pip in 3.12.1..."
$PIP312 install --upgrade pip
echo

# Python 2 pip bootstrap
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
# 7. Install general modules into Python 3.11.2
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
# 8. Install playsound manually (3.11.2)
# ------------------------------------------------------------
echo "Checking playsound installation in 3.11.2..."

if $PY311 - <<EOF 2>/dev/null
import playsound
EOF
then
    echo "playsound already installed."
else
    echo "Installing playsound using legacy setup.py..."

    TMPDIR=$(mktemp -d)
    cd "$TMPDIR"

    wget -q https://files.pythonhosted.org/packages/source/p/playsound/playsound-1.3.0.tar.gz
    tar xf playsound-1.3.0.tar.gz
    cd playsound-1.3.0

    $PY311 setup.py install

    echo "Verifying playsound import..."
    $PY311 - <<EOF
import playsound
EOF

    cd /
    rm -rf "$TMPDIR"
fi
echo

# ------------------------------------------------------------
# 9. Install PlatformIO into Python 3.12.1
# ------------------------------------------------------------
echo "=== Installing PlatformIO into Python 3.12.1 ==="

PENV="$HOME/.platformio/penv"

if [ -d "$PENV" ]; then
    if ! "$PENV/bin/python3" -c "import platformio" 2>/dev/null; then
        echo "WARNING: PlatformIO venv corrupted. Rebuilding..."
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
# 10. Final verification
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
