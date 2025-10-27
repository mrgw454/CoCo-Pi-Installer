#!/bin/bash

# https://www.freebasic.net/
# https://sourceforge.net/projects/fbc/files/FreeBASIC-1.10.1/

# check to see if fbc is already installed
fbccheck=$(which fbc)

set -e

ARCH=$(dpkg --print-architecture)
echo "📦 Detected architecture: $ARCH"

# install prerequisites
echo "📥 Installing build dependencies..."
sudo apt install -y build-essential git wget libncurses-dev

# if a previous fbc folder exists, move into a date-time named folder
if [ -d "fbc" ]; then
    foldername=$(date +%Y-%m-%d_%H.%M.%S)
    mv "fbc" "fbc-$foldername"
    echo -e "📁 Archived existing fbc folder [fbc] into backup folder [fbc-$foldername]\n"
fi

# clone FreeBASIC source
git clone https://github.com/freebasic/fbc.git
cd fbc

echo "🚀 Downloading bootstrap compiler for $ARCH..."

if [[ "$ARCH" == "amd64" ]]; then
    BOOTSTRAP_URL="https://downloads.sourceforge.net/project/fbc/FreeBASIC-1.10.1/Binaries-Linux/FreeBASIC-1.10.1-linux-x86_64.tar.gz"
elif [[ "$ARCH" == "arm64" ]]; then
    BOOTSTRAP_URL="https://netix.dl.sourceforge.net/project/fbc/FreeBASIC-1.10.1/Binaries-RaspberryPi/FreeBASIC-1.10.1-rpios11-aarch64.tar.gz"
else
    echo "❌ Unsupported architecture: $ARCH"
    exit 1
fi

wget -O bootstrap.tar.gz "$BOOTSTRAP_URL"

mkdir bootstrap
tar -xzf bootstrap.tar.gz -C bootstrap --strip-components=1

export PATH="$PWD/bootstrap/bin:$PATH"

if [ ! -x bootstrap/bin/fbc ]; then
    echo "❌ Bootstrap compiler not found or not executable. Aborting."
    exit 1
fi

echo "🔨 Building FreeBASIC..."
make

echo "📦 Installing FreeBASIC system-wide..."
sudo make install

echo "✅ Verifying fbc installation..."
fbc --version

echo "🎉 Done! FreeBASIC is now built and installed using native libraries for $ARCH."

cd "$HOME/source"
echo
echo "✅ Done!"
