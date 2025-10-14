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
if [ -f ../lwwire-$foldername/src/edit-tcpserv.sh ]; then
        echo "Found existing edit-tcpserv.sh file.  Restoring from ../lwwire-$foldername/src/edit-tcpserv.sh to $HOME/source/lwwire/src/edit-tcpserv.sh"
        echo
        cp ../lwwire-$foldername/src/edit-tcpserv.sh $HOME/source/lwwire/src/edit-tcpserv.sh
        echo
        echo
else
        echo No existing edit-tcpserv.sh file.  Copying from CoCo-Pi-Installer...
        tar zxvf $HOME/CoCo-Pi-Installer/lwwire-files.tar.gz --strip-components 1 -C $HOME/source/lwwire/src lwwire/edit-tcpserv.sh
        echo
        echo
fi


if [ -f ../lwwire-$foldername/src/serserv ]; then
        echo "Found existing serserv file.  Restoring from ../lwwire-$foldername/src/serserv to $HOME/source/lwwire/src/serserv"
        echo
        cp ../lwwire-$foldername/src/serserv $HOME/source/lwwire/src/serserv
        echo
        echo
else
        echo No existing serserv file.  Copying from CoCo-Pi-Installer...
        tar zxvf $HOME/CoCo-Pi-Installer/lwwire-files.tar.gz --strip-components 1 -C $HOME/source/lwwire/src lwwire/serserv
        echo
        echo
fi


if [ -f ../lwwire-$foldername/src/startlwwire.sh ]; then
        echo "Found existing startlwwire.sh file.  Restoring from ../lwwire-$foldername/src/startlwwire.sh to $HOME/source/lwwire/src/startlwwire.sh"
        echo
        cp ../lwwire-$foldername/src/startlwwire.sh $HOME/source/lwwire/src/startlwwire.sh
        echo
        echo
else
        echo No existing startlwwire.sh file.  Copying from CoCo-Pi-Installer...
        tar zxvf $HOME/CoCo-Pi-Installer/lwwire-files.tar.gz --strip-components 1 -C $HOME/source/lwwire/src lwwire/startlwwire.sh
        echo
        echo
fi


if [ -f ../lwwire-$foldername/src/stoplwwire.sh ]; then
        echo "Found existing stoplwwire.sh file.  Restoring from ../lwwire-$foldername/src/stoplwwire.sh to $HOME/source/lwwire/src/stoplwwire.sh"
        echo
        cp ../lwwire-$foldername/src/stoplwwire.sh $HOME/source/lwwire/src/stoplwwire.sh
        echo
        echo
else
        echo No existing stoplwwire.sh file.  Copying from CoCo-Pi-Installer...
        tar zxvf $HOME/CoCo-Pi-Installer/lwwire-files.tar.gz --strip-components 1 -C $HOME/source/lwwire/src lwwire/stoplwwire.sh
        echo
        echo
fi


if [ -f ../lwwire-$foldername/src/tap-disable.sh ]; then
        echo "Found existing tap-disable.sh file.  Restoring from ../lwwire-$foldername/src/tap-disable.sh to $HOME/source/lwwire/src/tap-disable.sh"
        echo
        cp ../lwwire-$foldername/src/tap-disable.sh $HOME/source/lwwire/src/tap-disable.sh
        echo
        echo
else
        echo No existing tap-disable.sh file.  Copying from CoCo-Pi-Installer...
        tar zxvf $HOME/CoCo-Pi-Installer/lwwire-files.tar.gz --strip-components 1 -C $HOME/source/lwwire/src lwwire/tap-disable.sh
        echo
        echo
fi


if [ -f ../lwwire-$foldername/src/tap-enable.sh ]; then
        echo "Found existing tap-enable.sh file.  Restoring from ../lwwire-$foldername/src/tap-enable.sh to $HOME/source/lwwire/src/tap-enable.sh"
        echo
        cp ../lwwire-$foldername/src/tap-enable.sh $HOME/source/lwwire/src/tap-enable.sh
        echo
        echo
else
        echo No existing tap-enable.sh file.  Copying from CoCo-Pi-Installer...
        tar zxvf $HOME/CoCo-Pi-Installer/lwwire-files.tar.gz --strip-components 1 -C $HOME/source/lwwire/src lwwire/tap-enable.sh
        echo
        echo
fi


if [ -f ../lwwire-$foldername/src/tcpserv ]; then
        echo "Found existing tcpserv file.  Restoring from ../lwwire-$foldername/src/tcpserv to $HOME/source/lwwire/src/tcpserv"
        echo
        cp ../lwwire-$foldername/src/tcpserv $HOME/source/lwwire/src/tcpserv
        echo
        echo
else
        echo No existing tcpserv file.  Copying from CoCo-Pi-Installer...
        tar zxvf $HOME/CoCo-Pi-Installer/lwwire-files.tar.gz --strip-components 1 -C $HOME/source/lwwire/src lwwire/tcpserv
        echo
        echo
fi


cd $HOME/source

# create new symbolic link
ln -s $HOME/source/lwwire/src $HOME/lwwire


echo
echo Done!
echo
