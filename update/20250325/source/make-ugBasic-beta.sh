#!/bin/bash
# tag: language BASIC

cd $HOME/source

# if a previous ugbasic folder exists, move into a date-time named folder

if [ -d "ugbasic-beta" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "ugbasic-beta" "ugbasic-beta-$foldername"

        echo -e Archiving existing ugbasic folder ["ugbasic-beta"] into backup folder ["ugbasic-beta-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/spotlessmind1975/ugbasic
git clone https://github.com/spotlessmind1975/ugbasic.git ugbasic-beta
cd ugbasic-beta

git checkout beta

git pull
git submodule update --force --recursive --init --remote

export ACLOCAL_PATH=/usr/share/aclocal

make target=coco clean compiler
sudo cp $HOME/source/ugbasic-beta/ugbc/exe/ugbc.coco.beta /usr/local/bin

make target=coco3 clean compiler
sudo cp $HOME/source/ugbasic-beta/ugbc/exe/ugbc.coco3.beta /usr/local/bin

make target=d32 clean compiler
sudo cp $HOME/source/ugbasic-beta/ugbc/exe/ugbc.d32.beta /usr/local/bin
