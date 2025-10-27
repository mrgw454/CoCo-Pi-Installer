#!/bin/bash

cd $HOME/source

# if a previous CROSS-LIB-coco folder exists, move into a date-time named folder

if [ -d "CROSS-LIB-coco" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "CROSS-LIB-coco" "CROSS-LIB-coco-$foldername"

        echo -e Archiving existing CROSS-LIB-coco folder ["CROSS-LIB-coco"] into backup folder ["CROSS-LIB-coco-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/Fabrizio-Caruso/CROSS-LIB
git clone https://github.com/Fabrizio-Caruso/CROSS-LIB.git CROSS-LIB-coco

cd CROSS-LIB-coco

# create link to pre-installed c1541 binary
#if [ -f $HOME/source/vice/trunk/vice/src/c1541 ]; then
#	ln -s $HOME/source/vice/trunk/vice/src/c1541 $HOME/source/CROSS-LIB-coco/tools/generic/c1541
#else
#	echo
#	echo Warning!  Missing c1541 binary needed for C64 and C128.
#	echo
#fi

# fix issue with Makefile.common
#sed -i "s/A40.ldr/A40.LDR/" $HOME/source/CROSS-LIB-coco/src/Makefile_common
#sed -i "s/A80.ldr/A80.LDR/" $HOME/source/CROSS-LIB-coco/src/Makefile_common


cd $HOME/source/CROSS-LIB-coco/src
./xl build all coco

cd $HOME/source/CROSS-LIB-coco/src
./xl build all coco3

cd $HOME/source/CROSS-LIB-coco/src
./xl build all mc10

if [ ! -d /media/share1/SDC/CROSSLIB/COCO3 ]; then
	mkdir -p /media/share1/SDC/CROSSLIB/COCO3
fi

if [ ! -d /media/share1/SDC/CROSSLIB/COCO ]; then
	mkdir -p /media/share1/SDC/CROSSLIB/COCO
fi
cp $HOME/source/CROSS-LIB-coco/build/*_coco3.dsk /media/share1/SDC/CROSSLIB/COCO3
cp $HOME/source/CROSS-LIB-coco/build/*_coco.dsk /media/share1/SDC/CROSSLIB/COCO


if [ ! -d /media/share1/DW4/CROSSLIB/COCO3 ]; then
	mkdir -p /media/share1/DW4/CROSSLIB/COCO3
fi

if [ ! -d /media/share1/DW4/CROSSLIB/COCO ]; then
	mkdir -p /media/share1/DW4/CROSSLIB/COCO
fi
cp $HOME/source/CROSS-LIB-coco/build/*_coco3.dsk /media/share1/DW4/CROSSLIB/COCO3
cp $HOME/source/CROSS-LIB-coco/build/*_coco.dsk /media/share1/DW4/CROSSLIB/COCO


if [ ! -d /media/share1/cassette/CROSSLIB/COCO3 ]; then
	mkdir -p /media/share1/cassette/CROSSLIB/COCO3
fi

if [ ! -d /media/share1/cassette/CROSSLIB/COCO ]; then
	mkdir -p /media/share1/cassette/CROSSLIB/COCO
fi
cp $HOME/source/CROSS-LIB-coco/build/*_coco3.cas /media/share1/cassette/CROSSLIB/COCO3
cp $HOME/source/CROSS-LIB-coco/build/*_coco_dragon.cas /media/share1/cassette/CROSSLIB/COCO


if [ ! -d /media/share1/cassette-dragon/CROSSLIB ]; then
	mkdir -p /media/share1/cassette-dragon/CROSSLIB
fi
cp $HOME/source/CROSS-LIB-coco/build/*_coco_dragon.cas /media/share1/cassette-dragon/CROSSLIB

if [ ! -d /media/share1/MCX/CROSSLIB ]; then
	mkdir -p /media/share1/MCX/CROSSLIB
fi
cp $HOME/source/CROSS-LIB-coco/build/*_mc10.* /media/share1/MCX/CROSSLIB


echo
echo Done!
