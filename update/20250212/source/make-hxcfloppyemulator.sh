#!/bin/bash

# install prerequisites
sudo apt -y install wayland-protocols

cd $HOME/source

# if a previous HxCFloppyEmulator folder exists, move into a date-time named folder

if [ -d "HxCFloppyEmulator" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "HxCFloppyEmulator" "HxCFloppyEmulator-$foldername"

        echo -e Archiving existing HxCFloppyEmulator folder ["HxCFloppyEmulator"] into backup folder ["HxCFloppyEmulator-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/jfdelnero/HxCFloppyEmulator
# https://hxc2001.com/floppy_drive_emulator/
git clone https://github.com/jfdelnero/HxCFloppyEmulator.git

cd HxCFloppyEmulator

GITREV=`git rev-parse --short HEAD`

git checkout 09ddbb58

# Set your github username and repo name
repo="jfdelnero/HxCFloppyEmulator"

# Get latest release info
release=$(curl --silent -m 10 --connect-timeout 5 \
    "https://api.github.com/repos/$repo/releases/latest")

# Release version
vtag=$(echo "$release" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
tag=${vtag:1}

echo
echo current version = $tag
echo

version="${tag:0:4}"
version=$(echo "$tag" | cut -d"V" -f2)
echo $version
echo

cd build

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)
make -j$cores

if [ -f hxcfloppyemulator ]; then
	echo hxcfloppyemulator binary found
	echo
else
	echo hxcfloppyemulator binary NOT found!
	echo
fi

cd ..

wget https://hxc2001.com/download/floppy_drive_emulator/HxC_Floppy_Emulator_Software_User_Manual_ENG.pdf

# get official binary release
wget https://github.com/jfdelnero/HxCFloppyEmulator/releases/download/HxCFloppyEmulator_V${version}/HxCFloppyEmulator_soft.zip


echo
echo Done!
