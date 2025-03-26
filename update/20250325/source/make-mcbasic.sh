#!/bin/bash
# tag: language BASIC

cd $HOME/source

# if a previous mcbasic folder exists, move into a date-time named folder

if [ -d "mcbasic" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "mcbasic" "mcbasic-$foldername"

        echo -e Archiving existing mcbasic folder ["mcbasic"] into backup folder ["mcbasic-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/gregdionne/mcbasic
git clone https://github.com/gregdionne/mcbasic.git

cd mcbasic

GITREV=`git rev-parse --short HEAD`

make

if [ -f mcbasic ]; then
	sudo cp mcbasic /usr/local/bin
else
	echo mcbasic binary not found!
	echo
fi
cd ..

echo
echo Done!

