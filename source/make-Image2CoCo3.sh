#!/bin/bash

cd $HOME/source

# if a previous Image2CoCo3 folder exists, move into a date-time named folder

if [ -d "Image2CoCo3" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "Image2CoCo3" "Image2CoCo3-$foldername"

        echo -e Archiving existing Image2CoCo3 folder ["Image2CoCo3"] into backup folder ["Image2CoCo3-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/marcsulf/Image2CoCo3
git clone https://github.com/marcsulf/Image2CoCo3.git

cd Image2CoCo3

GITREV=`git rev-parse --short HEAD`

echo
echo Done!

