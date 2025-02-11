#!/bin/bash

# add these to your .bashrc file
# add path for CC6303 compiler
#export PATH=/opt/cc68/bin:$PATH

cd $HOME/source

# if a previous CC6303 folder exists, move into a date-time named folder

if [ -d "CC6303" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "CC6303" "CC6303-$foldername"

        echo -e Archiving existing CC6303 folder ["CC6303"] into backup folder ["CC6303-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/EtchedPixels/CC6303
# https://github.com/zu2/CC6303

git clone https://github.com/EtchedPixels/CC6303.git
#git clone https://github.com/zu2/CC6303.git

cd CC6303

make
sudo make install

cd ..

echo
echo Done!

