#!/bin/bash

cd $HOME/source

# if a previous ramchk64 folder exists, move into a date-time named folder

if [ -d "ramchk64" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "ramchk64" "ramchk64-$foldername"

        echo -e Archiving existing ramchk64 folder ["ramchk64"] into backup folder ["ramchk64-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/stixpjr/ramchk64
git clone https://github.com/stixpjr/ramchk64.git

cd ramchk64

GITREV=`git rev-parse --short HEAD`

make

if [ -f ramchk64.dsk ]; then
	echo ramchk64.bin compiled successfully.
	echo
else
	echo ramchk64.bin compilation failed.  Aborting.
	echo
	exit 1
fi

if [ ! -d /media/share1/SDC/RAMCHK64 ]; then
	mkdir -p /media/share1/SDC/RAMCHK64
fi

cp ramchk64.dsk /media/share1/SDC/RAMCHK64

cd ..


echo
echo Done!
