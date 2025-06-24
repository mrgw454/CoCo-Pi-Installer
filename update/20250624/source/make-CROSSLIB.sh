#!/bin/bash

cd $HOME/source

# if a previous CROSS-LIB folder exists, move into a date-time named folder

if [ -d "CROSS-LIB" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "CROSS-LIB" "CROSS-LIB-$foldername"

        echo -e Archiving existing CROSS-LIB folder ["CROSS-LIB"] into backup folder ["CROSS-LIB-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/Fabrizio-Caruso/CROSS-LIB

git clone https://github.com/Fabrizio-Caruso/CROSS-LIB.git

# create link to pre-installed c1541 binary
if [ -f $HOME/source/vice/vice/src/c1541 ]; then
	ln -s $HOME/source/vice/vice/src/c1541 $HOME/source/CROSS-LIB/tools/generic/c1541
else
	echo
	echo Warning!  Missing c1541 binary needed for C64 and C128.
	echo
fi

# fix issue with Makefile.common
sed -i "s/a40/A40/" $HOME/source/CROSS-LIB/src/Makefile_common
sed -i "s/a80/A80/" $HOME/source/CROSS-LIB/src/Makefile_common
sed -i "s/.ldr/.LDR/" $HOME/source/CROSS-LIB/src/Makefile_common

sed -i "s/a40/A40/" $HOME/source/CROSS-LIB/src/makefiles.common/debug/Makefile.z88dk_debug
sed -i "s/.ldr/.LDR/" $HOME/source/CROSS-LIB/src/makefiles.common/debug/Makefile.z88dk_debug

sed -i "s/a40/A40/" $HOME/source/CROSS-LIB/src/makefiles.common/targets/z88dk/extras/Makefile_c128
sed -i "s/.ldr/.LDR/" $HOME/source/CROSS-LIB/src/makefiles.common/targets/z88dk/extras/Makefile_c128


cd $HOME/source/CROSS-LIB/src
./xl build all coco

cd $HOME/source/CROSS-LIB/src
./xl build all coco3

cd $HOME/source/CROSS-LIB/src
./xl build all mc10

cd $HOME/source/CROSS-LIB/src
./xl build all trs80

cd $HOME/source/CROSS-LIB/src
./xl build all atari

cd $HOME/source/CROSS-LIB/src
./xl build all c64

cd $HOME/source/CROSS-LIB/src
./xl build all c128_z80_40col

cd $HOME/source/CROSS-LIB/src
./xl build all c128_z80_80col

cd $HOME/source/CROSS-LIB/src
./xl build all c128_40col_zsdcc

cd $HOME/source/CROSS-LIB/src
./xl build all c128_80col_zsdcc

cd $HOME/source/CROSS-LIB/src
./xl build all c128_8502

cd $HOME/source/CROSS-LIB/src
./xl build all c128_8502_80col

cd $HOME/source/CROSS-LIB/src
./xl build all msx

cd $HOME/source/CROSS-LIB/src
./xl build all spectrum

cd $HOME/source/CROSS-LIB/src
./xl build all apple2

cd $HOME/source/CROSS-LIB/src
./xl build all apple2enh

cd $HOME/source/CROSS-LIB/src
./xl build all coleco

cd $HOME/source/CROSS-LIB/src
./xl build all coleco_adam

cd $HOME/source/CROSS-LIB/src
./xl build all nabu

cd $HOME/source/CROSS-LIB/src
./xl build all ti99

cd $HOME/source/CROSS-LIB/src
./xl build all trs80

cd $HOME/source/CROSS-LIB/src
./xl build all m100



# purge CROSSLIB folders prior to copying new files

echo purge existing CROSSLIB project files prior to copying new files...
echo
#find /media/share1/ -type d -name CROSSLIB -exec bash -c "cd '{}' && pwd && echo rm -r *_*.*" \;
find /media/share1/ -type d -name CROSSLIB -exec bash -c "cd '{}' && pwd && rm -r *_*.*" \;
echo purge complete.
echo

# copy all binaries to appropriate locations

if [ ! -d /media/share1/atari/CROSSLIB ]; then
	mkdir -p /media/share1/atari/CROSSLIB
fi
cp $HOME/source/CROSS-LIB/build/*_atari.* /media/share1/atari/CROSSLIB


if [ ! -d /media/share1/apple/CROSSLIB ]; then
	mkdir -p /media/share1/apple/CROSSLIB
fi
cp $HOME/source/CROSS-LIB/build/*_apple2*.* /media/share1/apple/CROSSLIB


if [ ! -d /media/share1/C128/CROSSLIB ]; then
	mkdir -p /media/share1/C128/CROSSLIB
fi
cp $HOME/source/CROSS-LIB/build/*_c128*.* /media/share1/C128/CROSSLIB


if [ ! -d /media/share1/C64/CROSSLIB ]; then
	mkdir -p /media/share1/C64/CROSSLIB
fi
cp $HOME/source/CROSS-LIB/build/*_c64*.* /media/share1/C64/CROSSLIB


if [ ! -d /media/share1/SDC/CROSSLIB/COCO3 ]; then
	mkdir -p /media/share1/SDC/CROSSLIB/COCO3
fi

if [ ! -d /media/share1/SDC/CROSSLIB/COCO ]; then
	mkdir -p /media/share1/SDC/CROSSLIB/COCO
fi
cp $HOME/source/CROSS-LIB/build/*_coco3.dsk /media/share1/SDC/CROSSLIB/COCO3
cp $HOME/source/CROSS-LIB/build/*_coco.dsk /media/share1/SDC/CROSSLIB/COCO


if [ ! -d /media/share1/DW4/CROSSLIB/COCO3 ]; then
	mkdir -p /media/share1/DW4/CROSSLIB/COCO3
fi

if [ ! -d /media/share1/DW4/CROSSLIB/COCO ]; then
	mkdir -p /media/share1/DW4/CROSSLIB/COCO
fi
cp $HOME/source/CROSS-LIB/build/*_coco3.dsk /media/share1/DW4/CROSSLIB/COCO3
cp $HOME/source/CROSS-LIB/build/*_coco.dsk /media/share1/DW4/CROSSLIB/COCO


if [ ! -d /media/share1/cassette/CROSSLIB/COCO3 ]; then
	mkdir -p /media/share1/cassette/CROSSLIB/COCO3
fi

if [ ! -d /media/share1/cassette/CROSSLIB/COCO ]; then
	mkdir -p /media/share1/cassette/CROSSLIB/COCO
fi
cp $HOME/source/CROSS-LIB/build/*_coco3.cas /media/share1/cassette/CROSSLIB/COCO3
cp $HOME/source/CROSS-LIB/build/*_coco_dragon.cas /media/share1/cassette/CROSSLIB/COCO


if [ ! -d /media/share1/cassette-dragon/CROSSLIB ]; then
	mkdir -p /media/share1/cassette-dragon/CROSSLIB
fi
cp $HOME/source/CROSS-LIB/build/*_coco_dragon.cas /media/share1/cassette-dragon/CROSSLIB


if [ ! -d /media/share1/coleco/CROSSLIB ]; then
	mkdir -p /media/share1/coleco/CROSSLIB
fi
cp $HOME/source/CROSS-LIB/build/*_coleco.* /media/share1/coleco/CROSSLIB


if [ ! -d /media/share1/nabu/CROSSLIB ]; then
	mkdir -p /media/share1/nabu/CROSSLIB
fi
cp $HOME/source/CROSS-LIB/build/*_NABU* /media/share1/nabu/CROSSLIB


if [ ! -d /media/share1/MCX/CROSSLIB ]; then
	mkdir -p /media/share1/MCX/CROSSLIB
fi
cp $HOME/source/CROSS-LIB/build/*_mc10.* /media/share1/MCX/CROSSLIB


if [ ! -d /media/share1/MSX/software/CROSSLIB ]; then
	mkdir -p /media/share1/MSX/software/CROSSLIB
fi
cp $HOME/source/CROSS-LIB/build/*_msx*.* /media/share1/MSX/software/CROSSLIB


if [ ! -d /media/share1/spectrum/CROSSLIB ]; then
	mkdir -p /media/share1/spectrum/CROSSLIB
fi
cp $HOME/source/CROSS-LIB/build/*_spectrum*.* /media/share1/spectrum/CROSSLIB


if [ ! -d /media/share1/ti/CROSSLIB ]; then
	mkdir -p /media/share1/ti/CROSSLIB
fi
cp $HOME/source/CROSS-LIB/build/*_ti99*.* /media/share1/ti/CROSSLIB


if [ ! -d /media/share1/TRS80/CROSSLIB ]; then
	mkdir -p /media/share1/TRS80/CROSSLIB
fi
cp $HOME/source/CROSS-LIB/build/*_trs80*.* /media/share1/TRS80/CROSSLIB


if [ ! -d /media/share1/Model-100/CROSSLIB ]; then
	mkdir -p /media/share1/Model-100/CROSSLIB
fi
cp $HOME/source/CROSS-LIB/build/*_m100*.* /media/share1/Model-100/CROSSLIB



# list CROSSLIB project files
echo
find /media/share1/ -type d -name CROSSLIB -exec bash -c "cd '{}' && pwd && ls -Rl" \;
echo

# alt way
#find /media/share1/ -type d -name CROSSLIB -exec ls -Rl {} \;

echo
echo Done!

