#!/bin/bash

# set some variables
SYSTEM=coco3

cd $HOME/source

# if a previous FUZIX-$SYSTEM folder exists, move into a date-time named folder

if [ -d "FUZIX-$SYSTEM" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "FUZIX-$SYSTEM" "FUZIX-$SYSTEM-$foldername"

        echo -e Archiving existing FUZIX-$SYSTEM folder ["FUZIX-$SYSTEM"] into backup folder ["FUZIX-$SYSTEM-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/EtchedPixels/FUZIX
git clone https://github.com/EtchedPixels/FUZIX.git FUZIX-$SYSTEM

cd $HOME/source/FUZIX-$SYSTEM

GITREV=`git rev-parse --short HEAD`


echo
echo Done!

