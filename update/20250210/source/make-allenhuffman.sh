#!/bin/bash

cd $HOME/source

# if a previous allenhuffman folder exists, move into a date-time named folder

if [ -d "allenhuffman" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "allenhuffman" "allenhuffman-$foldername"

        echo -e Archiving existing allenhuffman folder ["allenhuffman"] into backup folder ["allenhuffman-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/allenhuffman/BASIC
git clone https://github.com/allenhuffman/BASIC.git allenhuffman

cd allenhuffman

GITREV=`git rev-parse --short HEAD`

cd ..


echo
echo Done!
