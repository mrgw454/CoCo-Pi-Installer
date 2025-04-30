#!/bin/bash

sudo apt install cargo libsdl2-dev libsdl2-ttf-dev

cd $HOME/source

# if a previous 6809-gorsat folder exists, move into a date-time named folder

if [ -d "6809-gorsat" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "6809-gorsat" "6809-gorsat-$foldername"

        echo -e Archiving existing 6809-gorsat folder ["6809-gorsat"] into backup folder ["6809-gorsat-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/gorsat/6809
git clone https://github.com/gorsat/6809.git 6809-gorsat

cd 6809-gorsat

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

# example to assemble
# cargo run -r -- Basic.asm -r

cd $HOME/source


echo
echo Done!
