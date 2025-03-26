#!/bin/bash
# tag: language BASIC

cd $HOME/source

# if a previous CoCo_BASIC folder exists, move into a date-time named folder

if [ -d "CoCo_BASIC" ]; then

	foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "CoCo_BASIC" "CoCo_BASIC-$foldername"

        echo -e Archiving existing CoCo_BASIC folder ["CoCo_BASIC"] into backup folder ["CoCo_BASIC-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/allenhuffman/CoCo_BASIC
git clone https://github.com/allenhuffman/CoCo_BASIC.git

cd CoCo_BASIC

GITREV=`git rev-parse --short HEAD`


cd ..


echo
echo Done!
