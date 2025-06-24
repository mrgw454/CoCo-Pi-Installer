#!/bin/bash

sudo apt install libfltk1.3-dev

# to help find system installed fltk libraries first
export PATH=/usr/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib
sudo ldconfig

echo
fltk-config --version
echo
echo

cd $HOME/source

# if a previous retrotools folder exists, move into a date-time named folder

if [ -d "retrotools" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "retrotools" "retrotools-$foldername"

        echo -e Archiving existing retrotools folder ["retrotools"] into backup folder ["retrotools-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/robcfg/retrotools
git clone https://github.com/robcfg/retrotools.git

cd retrotools

GITREV=`git rev-parse --short HEAD`

cd dragondos/build
cmake -DCMAKE_BUILD_TYPE=Release ..

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)
make -j$cores

if [ $? -eq 0 ]
then
        echo "Compilation was successful."
        echo
else
        echo "Compilation was NOT successful.  Aborting installation of GUI."
        echo
fi


if [ -f dragondos ]; then
	echo dragondos binary exists.  Installing.
	echo
	sudo ln -s $HOME/source/retrotools/dragondos/build/dragondos /usr/local/bin/dragondos
fi

cd $HOME/source


echo
echo Done!
