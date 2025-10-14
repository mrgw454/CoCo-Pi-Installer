#!/bin/bash

# install prerequisites
sudo apt -y install clang

cd $HOME/source

# if a previous lzsa folder exists, move into a date-time named folder

if [ -d "lzsa" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "lzsa" "lzsa-$foldername"

        echo -e Archiving existing lzsa folder ["lzsa"] into backup folder ["lzsa-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/emmanuel-marty/lzsa
git clone https://github.com/emmanuel-marty/lzsa.git

cd lzsa

GITREV=`git rev-parse --short HEAD`

make

if [ -f lzsa ]; then
	sudo cp lzsa /usr/local/bin
else
	echo lzsa binary not found!
	echo
fi
cd ..

echo
echo Done!
