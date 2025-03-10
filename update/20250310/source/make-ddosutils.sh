#!/bin/bash

cd $HOME/source

# if a previous ddosutils folder exists, move into a date-time named folder

if [ -d "ddosutils" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "ddosutils" "ddosutils-$foldername"

        echo -e Archiving existing ddosutils folder ["ddosutils"] into backup folder ["ddosutils-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/pulkomandy/ddosutils
git clone https://github.com/pulkomandy/ddosutils.git

cd $HOME/source/ddosutils

GITREV=`git rev-parse --short HEAD`

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)

make -j$cores -f makefile.gcc


echo
echo
echo Done!
