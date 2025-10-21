#!/bin/bash

cd $HOME/source

# if a previous dmk2sdk-n6il folder exists, move into a date-time named folder

if [ -d "dmk2sdk-n6il" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "dmk2sdk-n6il" "dmk2sdk-n6il-$foldername"

        echo -e Archiving existing dmk2sdk-n6il folder ["dmk2sdk-n6il"] into backup folder ["dmk2sdk-n6il-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/n6il/dmk2sdf
git clone https://github.com/n6il/dmk2sdf.git dmk2sdf-n6il

cd dmk2sdf-n6il

GITREV=`git rev-parse --short HEAD`

cd src

gcc -o dmk2sdf dmk2sdf.c

if [ $? -eq 0 ]
then
        echo "Compilation was successful.  Installing..."
        echo
	sudo ln -s $HOME/source/dmk2sdf-n6il/src/dmk2sdf /usr/local/bin/dmk2sdf-n6il
else
        echo "Compilation was NOT successful.  Aborting installation."
        echo
        exit 1
fi

cd ..


echo
echo Done!
