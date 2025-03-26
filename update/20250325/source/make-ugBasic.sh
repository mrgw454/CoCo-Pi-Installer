#!/bin/bash
# tag: language BASIC

cd $HOME/source

# if a previous ugbasic folder exists, move into a date-time named folder

if [ -d "ugbasic" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "ugbasic" "ugbasic-$foldername"

        echo -e Archiving existing ugbasic folder ["ugbasic"] into backup folder ["ugbasic-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/spotlessmind1975/ugbasic
git clone https://github.com/spotlessmind1975/ugbasic.git
cd ugbasic

git pull
git submodule update --force --recursive --init --remote

export ACLOCAL_PATH=/usr/share/aclocal

make target=coco clean compiler
sudo cp $HOME/source/ugbasic/ugbc/exe/ugbc.coco /usr/local/bin

make target=coco3 clean compiler
sudo cp $HOME/source/ugbasic/ugbc/exe/ugbc.coco3 /usr/local/bin

make target=d32 clean compiler
sudo cp $HOME/source/ugbasic/ugbc/exe/ugbc.d32 /usr/local/bin

make target=d64 clean compiler
sudo cp $HOME/source/ugbasic/ugbc/exe/ugbc.d64 /usr/local/bin
