#!/bin/bash

cd $HOME/source

# if a previous dasmfw folder exists, move into a date-time named folder

if [ -d "dasmfw" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "dasmfw" "dasmfw-$foldername"

        echo -e Archiving existing dasmfw folder ["dasmfw"] into backup folder ["dasmfw-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/Arakula/dasmfw
git clone https://github.com/Arakula/dasmfw.git

cd dasmfw

GITREV=`git rev-parse --short HEAD`

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)
make -j$cores

if [ $? -eq 0 ]
then
        echo "compilation was successful."
        echo
else
        echo "compilation was NOT successful.  Aborting."
        echo
        exit 1
fi

sudo cp dasmfw /usr/local/bin

cd ..


echo
echo Done!
echo
