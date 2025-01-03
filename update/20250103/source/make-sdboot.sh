#!/bin/bash

# if a previous sdboot folder exists, move into a date-time named folder

if [ -d "sdboot" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "sdboot" "sdboot-$foldername"

        echo -e Archiving existing sdboot folder ["sdboot"] into backup folder ["sdboot-$foldername"]
        echo -e
        echo -e
fi

# https://gitlab.com/tormod/sdboot
# this is required for the boot loader since there is no floppy disk based boot loader with this build of Fuzix
git clone https://gitlab.com/tormod/sdboot.git

cd sdboot

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)
make -j$cores

if [ $? -eq 0 ]
then
        echo
        echo SDBOOT boot loader compilation successful
        echo
else
        echo
        echo SDBOOT boot loader compilation unsuccessful.  Aborting.
        echo
        exit 1
fi

cd bootrom
make -j$cores eprom8.rom

if [ $? -eq 0 ]
then
	echo
	echo BOOT ROM compilation successful
	echo
else
	echo
	echo BOOT ROM compilation unsuccessful.  Aborting.
	echo
	exit 1
fi

cd $HOME/source/sdboot


echo
echo Done!
