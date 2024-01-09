#!/bin/bash

# using info from https://wine.htmlvalidator.com/install-wine-on-debian-12.html

cd $HOME

dpkg --print-architecture
dpkg --print-foreign-architectures
sudo dpkg --add-architecture i386
dpkg --print-foreign-architectures

sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources
sudo apt update

sudo apt install --install-recommends winehq-devel
wine --version
wine winecfg

cd $HOME/source

if [ -d winetricks ]; then
	mkdir winetricks
fi

cd winetricks

wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks

if [ -f winetricks ]; then
	chmod a+x winetricks
	sudo ln -s $HOME/source/winetricks/winetricks /usr/local/bin/winetricks
else
	echo
	echo winetricks not found!  Aborting installation.
	echo
fi

cd ..


echo
echo
echo Done!
echo
