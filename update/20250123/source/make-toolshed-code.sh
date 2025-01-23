#!/bin/bash

cd $HOME/source

# if a previous toolshed folder exists, move into a date-time named folder

if [ -d "toolshed-code" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "toolshed-code" "toolshed-code-$foldername"

        echo -e Archiving existing toolshed-code folder ["toolshed-code"] into backup folder ["toolshed-code-$foldername"]
        echo -e
        echo -e
fi

# https://sourceforge.net/p/toolshed/code/ci/default/tree/
hg clone http://hg.code.sf.net/p/toolshed/code toolshed-code
cd $HOME/source/toolshed-code

hg pull

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)

make -j$cores -C build/unix
sudo make -C build/unix install

make -j$cores -C cocoroms
make -j$cores -C dwdos
make -j$cores -C hdbdos
make -j$cores -C superdos

cd $HOME/source/toolshed-code/build/unix

sudo chmod a-x unittest/*
sudo find . -executable -type f -exec cp {} /usr/local/bin \;

cd $HOME/source/toolshed-code
sudo cp d2o /usr/local/bin
sudo cp d2u /usr/local/bin
sudo cp o2u /usr/local/bin
sudo cp u2o /usr/local/bin


echo
echo
echo Done!

