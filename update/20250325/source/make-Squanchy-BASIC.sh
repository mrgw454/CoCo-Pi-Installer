#!/bin/bash
# tag: language BASIC

cd $HOME/source

# if a previous Squanchy-BASIC folder exists, move into a date-time named folder

if [ -d "Squanchy-BASIC" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "Squanchy-BASIC" "Squanchy-BASIC-$foldername"

        echo -e Archiving existing Squanchy-BASIC folder ["Squanchy-BASIC"] into backup folder ["Squanchy-BASIC-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/tlindner/Squanchy-BASIC
git clone https://github.com/tlindner/Squanchy-BASIC.git

cd Squanchy-BASIC

GITREV=`git rev-parse --short HEAD`

make

if [ -f SQUANCHY.DSK ]; then
	if [ ! -d /media/share1/SDC/LINDNER ]; then
		mkdir /media/share1/SDC/LINDNER
	fi

	cp SQUANCHY.DSK /media/share1/SDC/LINDNER
else
	echo SQUANCHY.DSK image not found!
	echo
fi

cd ..

echo
echo Done!

