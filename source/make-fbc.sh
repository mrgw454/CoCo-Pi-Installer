#!/bin/bash
set -e

# FreeBASIC Compiler Build Script
# https://www.freebasic.net/
# https://github.com/freebasic/fbc

cd $HOME/source

# Detect architecture
systemtype=$(dpkg --print-architecture)
echo "Architecture = $systemtype"

# Check for existing fbc
if command -v fbc &> /dev/null; then
    echo "fbc binary found."
    echo
else
    echo "fbc binary not found. Getting precompiled binary package..."
    echo

    if [[ $systemtype =~ arm64 ]]; then
        curl -o FreeBASIC-binary.tar.gz -L -C - https://sourceforge.net/projects/fbc/files/FreeBASIC-1.10.1/Binaries-RaspberryPi/FreeBASIC-1.10.1-rpios11-aarch64.tar.gz/download
    elif [[ $systemtype =~ amd64 ]]; then
        curl -o FreeBASIC-binary.tar.gz -L -C - https://sourceforge.net/projects/fbc/files/FreeBASIC-1.10.1/Binaries-Linux/FreeBASIC-1.10.1-linux-x86_64.tar.gz/download
    fi

    if [ -f FreeBASIC-binary.tar.gz ]; then
        echo "FreeBASIC-binary package archive found."

        if [ ! -d "FreeBASIC-binary" ]; then
            echo "Creating FreeBASIC-binary folder..."
            mkdir FreeBASIC-binary
        fi

        echo "Extracting FreeBASIC-binary package archive..."
        tar zxvf FreeBASIC-binary.tar.gz --strip-components 1 -C $HOME/source/FreeBASIC-binary

        echo "Installing FreeBASIC-binary..."
        cd FreeBASIC-binary
        sudo ./install.sh -i
        cd ..
    else
        echo "FreeBASIC-binary package archive not found! Aborting installation."
        exit 1
    fi
fi

# Shim legacy libtinfo.so.5 if needed
shimroot="$HOME/source/libtinfo-legacy"
if [[ $systemtype =~ amd64 ]]; then
    shimpath="$shimroot/lib/x86_64-linux-gnu"
    if ! command -v ldconfig &> /dev/null || ! ldconfig -p | grep libtinfo.so.5 > /dev/null; then
        echo "Shim: libtinfo.so.5 missing or ldconfig unavailable. Installing from Debian 12..."
        mkdir -p "$shimroot"
        cd "$shimroot"
        wget -O libtinfo5.deb https://ftp.debian.org/debian/pool/main/n/ncurses/libtinfo5_6.4-4_amd64.deb
        ar x libtinfo5.deb
        tar -xf data.tar.xz || { echo "Failed to extract data.tar.xz"; exit 1; }
        cd "$HOME/source"
    fi
elif [[ $systemtype =~ arm64 ]]; then
    shimpath="$shimroot/lib/aarch64-linux-gnu"
    if ! command -v ldconfig &> /dev/null || ! ldconfig -p | grep libtinfo.so.5 > /dev/null; then
        echo "Shim: libtinfo.so.5 missing or ldconfig unavailable. Installing from Debian 12..."
        mkdir -p "$shimroot"
        cd "$shimroot"
        wget -O libtinfo5.deb https://ftp.debian.org/debian/pool/main/n/ncurses/libtinfo5_6.4-4_arm64.deb
        ar x libtinfo5.deb
        tar -xf data.tar.xz || { echo "Failed to extract data.tar.xz"; exit 1; }
        cd "$HOME/source"
    fi
fi

# Validate shim presence
if [ -f "$shimpath/libtinfo.so.5" ]; then
    echo "Found shimmed libtinfo.so.5 at $shimpath"
else
    echo "Error: libtinfo.so.5 not found after extraction. Listing contents for debug:"
    find "$shimroot" -name 'libtinfo.so*'
    exit 1
fi

# Archive previous fbc folder
if [ -d "fbc" ]; then
    foldername=$(date +%Y-%m-%d_%H.%M.%S)
    mv "fbc" "fbc-$foldername"
    echo "Archived existing fbc folder to fbc-$foldername"
fi

# Clone and build fbc
git clone https://github.com/freebasic/fbc.git
cd fbc

echo "Testing bootstrap fbc binary with LD_LIBRARY_PATH override..."
LD_LIBRARY_PATH="$shimpath:$LD_LIBRARY_PATH" fbc -version

echo "Building fbc with LD_LIBRARY_PATH override..."
LD_LIBRARY_PATH="$shimpath:$LD_LIBRARY_PATH" make

if [ -f bin/fbc ]; then
    echo "fbc binary created successfully. Installing..."
    sudo make install
else
    echo "fbc binary not found! Installation aborted."
    exit 1
fi

cd ..
echo "Done!"
