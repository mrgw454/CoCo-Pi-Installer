#!/bin/bash

cd $HOME/source

# if a previous bin2c folder exists, move into a date-time named folder

if [ -d "bin2c" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "bin2c" "bin2c-$foldername"

        echo -e Archiving existing bin2c folder ["bin2c"] into backup folder ["bin2c-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/gwilymk/bin2c
git clone https://github.com/gwilymk/bin2c.git

cd bin2c

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)
make -j$cores CPU=6809 SYNTAX=mot

if [ $? -eq 0 ]
then
        echo "Compilation was successful."
        echo
else
        echo "Compilation was NOT successful.  Aborting installation."
        echo
        exit 1
fi

sudo ln -s $HOME/source/bin2c/bin2c /usr/local/bin/bin2c

cd ..


echo
echo Done!
