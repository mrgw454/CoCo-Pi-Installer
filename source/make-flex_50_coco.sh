#!/bin/bash

# install prerequisites
echo NOTE!  Optional projects you may want built and installed:
echo
echo dmk2sdf
echo hxcfloppyemulator
echo
echo
read -p "Press any key to continue... " -n1 -s
echo
echo

cd $HOME/source

# if a previous flex_50_coco folder exists, move into a date-time named folder

if [ -d "flex_50_coco" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "flex_50_coco" "flex_50_coco-$foldername"

        echo -e Archiving existing flex_50_coco folder ["flex_50_coco"] into backup folder ["flex_50_coco-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/n6il/flex_50_coco
git clone https://github.com/n6il/flex_50_coco.git

cd flex_50_coco

GITREV=`git rev-parse --short HEAD`

export PATH=$HOME/source/HxCFloppyEmulator/build:$PATH
export LD_LIBRARY_PATH=$HOME/source/HxCFloppyEmulator/build:$LD_LIBRARY_PATH


sed -i 's|../SDF|../sdf|' $HOME/source/flex_50_coco/OS/dmk/Makefile

make
if [ $? -eq 0 ]
then
        echo "Compilation was successful"
        echo
else
        echo "Compilation was NOT successful"
        echo
        exit 1
fi

if [ ! -d /media/share1/SDC/FLEX ]; then
	mkdir -p /media/share1/SDC/FLEX
fi

if [ ! -d /media/share1/EMU/FLEX ]; then
	mkdir -p /media/share1/EMU/FLEX
fi

find . -iname "*.sdf" -exec cp {} /media/share1/SDC/FLEX \;
find . -iname "*.dmk" -exec cp {} /media/share1/EMU/FLEX \;

cd ..


echo
echo Done!

