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

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)

make threads=$cores target=coco clean compiler
sudo cp $HOME/source/ugbasic/ugbc/exe/ugbc.coco /usr/local/bin

make threads=$cores target=coco3 clean compiler
sudo cp $HOME/source/ugbasic/ugbc/exe/ugbc.coco3 /usr/local/bin

make threads=$cores target=atarixl clean compiler
sudo cp $HOME/source/ugbasic/ugbc/exe/ugbc.atarixl /usr/local/bin

make threads=$cores target=c128 clean compiler
sudo cp $HOME/source/ugbasic/ugbc/exe/ugbc.c128 /usr/local/bin

make threads=$cores target=c128z clean compiler
sudo cp $HOME/source/ugbasic/ugbc/exe/ugbc.c128z /usr/local/bin

make threads=$cores target=c64 clean compiler
sudo cp $HOME/source/ugbasic/ugbc/exe/ugbc.c64 /usr/local/bin

make threads=$cores target=coleco clean compiler
sudo cp $HOME/source/ugbasic/ugbc/exe/ugbc.coleco /usr/local/bin

make threads=$cores target=msx1 clean compiler
sudo cp $HOME/source/ugbasic/ugbc/exe/ugbc.msx1 /usr/local/bin

make threads=$cores target=d32 clean compiler
sudo cp $HOME/source/ugbasic/ugbc/exe/ugbc.d32 /usr/local/bin

make threads=$cores target=d64 clean compiler
sudo cp $HOME/source/ugbasic/ugbc/exe/ugbc.d64 /usr/local/bin

make threads=$cores target=zx clean compiler
sudo cp $HOME/source/ugbasic/ugbc/exe/ugbc.zx /usr/local/bin
