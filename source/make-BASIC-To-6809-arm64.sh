#!/bin/bash

systemtype=$(dpkg --print-architecture)
echo architecture = $systemtype

if [[ $systemtype != arm64 ]];then
        echo This project is not compatible with your device platform.  Aborting.
        echo
        echo
        exit 1
fi

# tag: language BASIC

# install prerequisites
echo NOTE! You need to make sure the following projects are already built and installed:
echo
echo QB64pe
echo lwasm
echo
read -p "Press any key to continue... " -n1 -s
echo

sudo apt -y install libglew-dev freeglut3-dev libgl1-mesa-dev

cd $HOME/source

# Archive previous clone if it exists
if [ -d "BASIC-To-6809" ]; then
    foldername=$(date +%Y-%m-%d_%H.%M.%S)
    mv "BASIC-To-6809" "BASIC-To-6809-$foldername"
    echo -e "Archived existing BASIC-To-6809 folder into backup: BASIC-To-6809-$foldername"
    echo
fi

# Clone fresh copy
git clone https://github.com/nowhereman999/BASIC-To-6809.git
cd BASIC-To-6809
GITREV=$(git rev-parse --short HEAD)

cd Source_Code

# Check for QB64pe
QB64="$HOME/source/QB64pe/qb64pe"
if [ ! -f "$QB64" ]; then
    echo
    echo "QB64pe compiler missing. Aborting."
    echo
    exit 1
fi

# Set Clang and memory-friendly flags
export CXX=clang++
export CXXFLAGS="-O0 -fno-exceptions -std=gnu++17"
export LDFLAGS="-lGLEW -lGL -lglut -lm -lpthread"

echo
echo "Building all necessary tools. Please be patient..."
echo

# Compile Tokenizer
"$QB64" -c -x BasTo6809.1.Tokenizer.bas -o BasTo6809.1.Tokenizer
if [ ! -f BasTo6809.1.Tokenizer ]; then
    echo
    echo "Compiling Tokenizer failed. Aborting."
    echo
    exit 1
fi

# Compile Compiler with fallback to manual Clang++ if needed
echo
echo "Compiling BasTo6809.2.Compile.bas..."
"$QB64" -c -x BasTo6809.2.Compile.bas -o BasTo6809.2.Compile

if [ ! -f BasTo6809.2.Compile ]; then
    echo
    echo "QB64pe compilation failed. Attempting manual Clang++ fallback..."

    cd $HOME/source/QB64pe

    if [ ! -f internal/c/qbx.cpp ]; then
        echo
        echo "qbx.cpp not found. Aborting."
        echo
        exit 1
    fi

    clang++ -O0 -fno-exceptions -std=gnu++17 \
        -I./internal/c/libqb/include \
        -I./internal/c/parts/core/freeglut/include \
        -I./internal/c/parts/core/glew/include \
        internal/c/qbx.cpp internal/c/*.o \
        -lGLEW -lGL -lglut -lm -lpthread \
        -o $OLDPWD/BasTo6809.2.Compile

    cd $OLDPWD

    if [ ! -f BasTo6809.2.Compile ]; then
        echo
        echo "Manual Clang++ compilation failed. Aborting."
        echo
        exit 1
    fi
fi

# Compile main program
"$QB64" -c -x BasTo6809.bas -o BasTo6809
if [ ! -f BasTo6809 ]; then
    echo
    echo "Compiling BasTo6809 failed. Aborting."
    echo
    exit 1
fi

# Compile large program variant
"$QB64" -c -x cc1sl.bas -o cc1sl
if [ ! -f cc1sl ]; then
    echo
    echo "Compiling cc1sl failed. Aborting."
    echo
    exit 1
fi

# Compile IDE
cd IDE
"$QB64" -c -x -o SDECB SDECB.bas
if [ ! -f SDECB ]; then
    echo
    echo "Compiling SDECB IDE failed. Aborting."
    echo
    exit 1
fi
cd ..

# Compile PNG tools
"$QB64" -c -x -o PNGtoCC3Playfield PNGtoCC3Playfield.bas
if [ ! -f PNGtoCC3Playfield ]; then
    echo
    echo "Compiling PNGtoCC3Playfield failed. Aborting."
    echo
    exit 1
fi

"$QB64" -c -x -o PNGtoCCSB PNGtoCCSB.bas
if [ ! -f PNGtoCCSB ]; then
    echo
    echo "Compiling PNGtoCCSB failed. Aborting."
    echo
    exit 1
fi

# Download manual
wget -O basto6809.pdf https://github.com/pwillard/basto6809Manual/raw/main/basto6809.pdf

cd $HOME/source
echo
echo "✅ Done! BASIC-To-6809 build complete."
