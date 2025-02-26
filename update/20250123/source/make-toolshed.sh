#!/bin/bash

cd $HOME/source

# if a previous toolshed folder exists, move into a date-time named folder

if [ -d "toolshed" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "toolshed" "toolshed-$foldername"

        echo -e Archiving existing toolshed folder ["toolshed"] into backup folder ["toolshed-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/nitros9project/toolshed
git clone https://github.com/nitros9project/toolshed.git

cd $HOME/source/toolshed

GITREV=`git rev-parse --short HEAD`

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)

make -j$cores -C build/unix
sudo make -C build/unix install

make -j$cores -C cocoroms
make -j$cores -C dwdos
make -j$cores -C hdbdos
make -j$cores -C superdos

cd $HOME/source/toolshed/build/unix

sudo chmod a-x unittest/*
sudo find . -executable -type f -exec cp {} /usr/local/bin \;

cd $HOME/source/toolshed
sudo cp d2o /usr/local/bin
sudo cp d2u /usr/local/bin
sudo cp o2u /usr/local/bin
sudo cp u2o /usr/local/bin


echo
echo
echo Done!
