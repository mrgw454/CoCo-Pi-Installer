#!/bin/bash

cd $HOME/source

# if a previous dragondos folder exists, move into a date-time named folder

if [ -d "dragondos" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "dragondos" "dragondos-$foldername"

        echo -e Archiving existing dragondos folder ["dragondos"] into backup folder ["dragondos-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/robcfg/retrotools/tree/master/dragondos
git clone https://github.com/robcfg/retrotools.git dragondos

cd $HOME/source/dragondos

GITREV=`git rev-parse --short HEAD`

cd dragondos/build

cmake -DCMAKE_BUILD_TYPE=Release ..

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)

make -j$cores

if [ ! -f dragondos ]; then
	echo
	echo dragondos binary does not exist.  Aborting.
	echo
	exit 1
fi

sudo ln -s $HOME/source/dragondos/dragondos/build/dragondos /usr/local/bin/dragondos


echo
echo
echo Done!
