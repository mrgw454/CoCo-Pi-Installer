#!/bin/bash

sudo apt install cargo libsdl2-dev libsdl2-ttf-dev

cd $HOME/source

# if a previous coco-gorsat folder exists, move into a date-time named folder

if [ -d "coco-gorsat" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "coco-gorsat" "coco-gorsat-$foldername"

        echo -e Archiving existing coco-gorsat folder ["coco-gorsat"] into backup folder ["coco-gorsat-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/gorsat/coco
git clone https://github.com/gorsat/coco.git coco-gorsat

cd coco-gorsat

GITREV=`git rev-parse --short HEAD`


cargo update

if [ $? -eq 0 ]
then
        echo "Compilation was successful."
        echo
else
        echo "Compilation was NOT successful.  Aborting installation."
        echo
        exit 1
fi

cargo run


cd $HOME/source


echo
echo Done!
