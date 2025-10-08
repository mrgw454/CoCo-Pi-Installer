#!/bin/bash

cd $HOME/source


# remove symbolic link if it exists
if [ -L $HOME/lwwire ]; then
	rm $HOME/lwwire
fi

# if a previous lwwire folder exists, move into a date-time named folder

if [ -d "lwwire" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "lwwire" "lwwire-$foldername"

	echo
	echo Archiving existing lwwire folder ["lwwire"] into backup folder ["lwwire-$foldername"]
        echo
        echo
fi

# http://lwwire.projects.l-w.ca/hg/
hg clone http://lwwire.projects.l-w.ca/hg/ lwwire

cd lwwire/src

make

# restore lwwire scripts
echo Restoring lwwire scripts
echo
cp $HOME/source/lwwire-$foldername/src/edit-tcpserv.sh ./
cp $HOME/source/lwwire-$foldername/src/serserv ./
cp $HOME/source/lwwire-$foldername/src/startlwwire.sh ./
cp $HOME/source/lwwire-$foldername/src/stoplwwire.sh ./
cp $HOME/source/lwwire-$foldername/src/tap-disable.sh ./
cp $HOME/source/lwwire-$foldername/src/tap-enable.sh ./
cp $HOME/source/lwwire-$foldername/src/tcpserv ./

cd $HOME/source

# create new symbolic link
ln -s $HOME/source/lwwire/src $HOME/lwwire


echo
echo Done!
echo
