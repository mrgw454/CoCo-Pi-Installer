#!/bin/bash

cd $HOME/source

# if a previous dragon-refresh-test folder exists, move into a date-time named folder

if [ -d "dragon-refresh-test" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "dragon-refresh-test" "dragon-refresh-test-$foldername"

        echo -e Archiving existing dragon-refresh-test folder ["dragon-refresh-test"] into backup folder ["dragon-refresh-test-$foldername"]
        echo -e
        echo -e
fi

# https://gitlab.com/sorchard001/dragon-refresh-test
git clone https://gitlab.com/sorchard001/dragon-refresh-test.git

cd dragon-refresh-test

GITREV=`git rev-parse --short HEAD`

rm REFTEST.BIN
rm reftest.rom

# Build a Tandy Color Computer (CoCo) binary
asm6809 -C -o reftest.bin reftest.s

if [ -f reftest.bin ]; then
	echo reftest.bin compiled successfully.
	echo
else
	echo reftest.bin compilation failed.  Aborting.
	echo
	exit 1
fi

decb dskini reftest.dsk
decb copy -2 -b -r reftest.bin reftest.dsk,REFTEST.BIN


if [ ! -d /media/share1/SDC/REFTEST ]; then
	mkdir -p /media/share1/SDC/REFTEST
fi

cp reftest.dsk /media/share1/SDC/REFTEST

cd ..


echo
echo Done!
