#!/bin/bash

cd $HOME/source

# if a previous cocostress folder exists, move into a date-time named folder

if [ -d "cocostress" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "cocostress" "cocostress-$foldername"

        echo -e Archiving existing cocostress folder ["cocostress"] into backup folder ["cocostress-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/richard42/cocostress
git clone https://github.com/richard42/cocostress.git

cd cocostress

GITREV=`git rev-parse --short HEAD`

pyenv local 2.7.18

ln -s /usr/local/bin/lwasm tools/lwasm

make all

if [ -f STRESS12.DSK ]; then
	if [ ! -d /media/share1/SDC/RICHARD4 ]; then
                mkdir /media/share1/SDC/RICHARD4
	fi

	echo "cp STRESS12.DSK /media/share1/SDC/RICHARD4"
	echo
	echo
	cp STRESS12.DSK /media/share1/SDC/RICHARD4
else
	echo STRESS12.DSK image not found!
	echo
	echo
fi

cd ..

echo
echo Done!
