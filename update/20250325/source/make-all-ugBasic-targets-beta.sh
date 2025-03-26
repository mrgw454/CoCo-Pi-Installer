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

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)

make threads=$cores target=coco clean compiler
sudo cp $HOME/source/ugbasic-beta/ugbc/exe/ugbc.coco.beta /usr/local/bin

make threads=$cores target=coco3 clean compiler
sudo cp $HOME/source/ugbasic-beta/ugbc/exe/ugbc.coco3.beta /usr/local/bin

make threads=$cores target=atarixl clean compiler
sudo cp $HOME/source/ugbasic-beta/ugbc/exe/ugbc.atarixl.beta /usr/local/bin

make threads=$cores target=c128 clean compiler
sudo cp $HOME/source/ugbasic-beta/ugbc/exe/ugbc.c128.beta /usr/local/bin

make threads=$cores target=c128z clean compiler
sudo cp $HOME/source/ugbasic-beta/ugbc/exe/ugbc.c128z.beta /usr/local/bin

make threads=$cores target=c64 clean compiler
sudo cp $HOME/source/ugbasic-beta/ugbc/exe/ugbc.c64.beta /usr/local/bin

make threads=$cores target=coleco clean compiler
sudo cp $HOME/source/ugbasic-beta/ugbc/exe/ugbc.coleco.beta /usr/local/bin

make threads=$cores target=msx1 clean compiler
sudo cp $HOME/source/ugbasic-beta/ugbc/exe/ugbc.msx1.beta /usr/local/bin

make threads=$cores target=d32 clean compiler
sudo cp $HOME/source/ugbasic-beta/ugbc/exe/ugbc.d32.beta /usr/local/bin

make threads=$cores target=d64 clean compiler
sudo cp $HOME/source/ugbasic-beta/ugbc/exe/ugbc.d64.beta /usr/local/bin

make threads=$cores target=zx clean compiler
sudo cp $HOME/source/ugbasic-beta/ugbc/exe/ugbc.zx.beta /usr/local/bin
