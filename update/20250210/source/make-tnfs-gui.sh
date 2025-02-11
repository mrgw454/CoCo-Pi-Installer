#!/bin/bash

# install prerequisites
echo NOTE!  You need to make sure the following projects are already built and installed:
echo
echo tnfsd
echo
echo
echo
read -p "Press any key to continue... " -n1 -s
echo

sudo apt install golang-go

cd $HOME/source

# if a previous tnfs-gui folder exists, move into a date-time named folder

if [ -d "tnfs-gui" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "tnfs-gui" "tnfs-gui-$foldername"

        echo -e Archiving existing tnfs-gui folder ["tnfs-gui"] into backup folder ["tnfs-gui-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/nwah/tnfs-gui
git clone https://github.com/nwah/tnfs-gui.git

cd tnfs-gui

GITREV=`git rev-parse --short HEAD`

sed -i 's|1.23.3|1.23|' go.mod

go build

if [ -f tnfs-gui ]; then
	echo
	echo tnfs-gui binary found.
	echo
else
	echo
	echo tnfs-gui binary not found!  Installation aborted.
	echo
	echo
	exit 1
fi

if [ -f $HOME/source/tnfsd/bin/tnfsd ]; then

	if [ -d tnfsd ]; then
		rmdir tnfsd
	fi
	ln -s $HOME/source/tnfsd/bin/tnfsd $HOME/source/tnfs-gui
else
	echo
	echo tnfsd binary not found.  Aborting installation.
	echo
	exit 1
fi

# get image that can be used for application icon
wget https://github.com/nwah/tnfs-gui/raw/main/doc/screenshot-dark.png

cd $HOME/source


echo
echo Done!
