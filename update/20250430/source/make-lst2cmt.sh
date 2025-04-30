#!/bin/bash

cd $HOME/source

# if a previous lst2cmt folder exists, move into a date-time named folder

if [ -d "lst2cmt" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "lst2cmt" "lst2cmt-$foldername"

        echo -e Archiving existing lst2cmt folder ["lst2cmt"] into backup folder ["lst2cmt-$foldername"]
        echo -e
        echo -e
fi

# https://www.youtube.com/watch?v=2tu4t2bBjzo
# https://github.com/ericsperano/lst2cmt
git clone https://github.com/ericsperano/lst2cmt.git

cd lst2cmt

GITREV=`git rev-parse --short HEAD`

chmod a+x lst2cmt.py
sudo ln -s $HOME/source/lst2cmt/lst2cmt.py /usr/local/bin/lst2cmt.py


cd ..


echo
echo Done!
