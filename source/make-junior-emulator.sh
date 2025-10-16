#!/bin/bash

# install prerequisites
echo NOTE!  You need to make sure the following projects are already built and installed:
echo
echo 64tass
echo
echo
read -p "Press any key to continue... " -n1 -s
echo

cd $HOME/source

# if a previous junior-emulator folder exists, move into a date-time named folder

if [ -d "junior-emulator" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "junior-emulator" "junior-emulator-$foldername"

        echo -e Archiving existing junior-emulator folder ["junior-emulator"] into backup folder ["junior-emulator-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/FoenixRetro/junior-emulator
# https://github.com/FoenixRetro/Documentation
git clone https://github.com/FoenixRetro/junior-emulator.git

cd junior-emulator

GITREV=`git rev-parse --short HEAD`

if [ ! -d $HOME/source/junior-emulator/kernel/output ]; then
	mkdir -p $HOME/source/junior-emulator/kernel/output
fi

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)
make -j$cores

if [ $? -eq 0 ]
then
        echo "Compilation was successful."
        echo
else
        echo "Compilation was NOT successful.  Aborting installation."
        echo
        exit 1
fi


cd $HOME/source


echo
echo Done!
