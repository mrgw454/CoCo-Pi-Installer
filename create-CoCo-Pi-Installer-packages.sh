#!/bin/bash

# if a previous CoCo-Pi-Installer-staging folder exists, move into a date-time named folder

if [ -d "CoCo-Pi-Installer-staging" ]; then

	foldername=$(date +%Y-%m-%d_%H.%M.%S)

	mv "CoCo-Pi-Installer-staging" "CoCo-Pi-Installer-staging-$foldername"

	echo -e Archiving existing CoCo-Pi-Installer-staging folder ["CoCo-Pi-Installer-staging"] into backup folder ["CoCo-Pi-Installer-staging-$foldername"]
	echo
	echo
fi


if [ ! -d CoCo-Pi-Installer-staging ]; then
	mkdir CoCo-Pi-Installer-staging
fi

cd CoCo-Pi-Installer-staging

# remove previous files if they exist
if [ -f Desktop.tar.gz ]; then
	rm Desktop.tar.gz
fi

if [ -f Pictures.tar.gz ]; then
	rm Pictures.tar.gz
fi

if [ -f scripts.tar.gz ]; then
	rm scripts.tar.gz
fi

if [ -f scripts2.tar.gz ]; then
        rm scripts2.tar.gz
fi

if [ -f source.tar.gz ]; then
	rm source.tar.gz
fi

if [ -f source-other.tar.gz ]; then
	rm source-other.tar.gz
fi

if [ -f fonts.tar.gz ]; then
	rm fonts.tar.gz
fi

if [ -f misc-home-files.tar.gz ]; then
	rm misc-home-files.tar.gz
fi

if [ -f mame-menus.tar.gz ]; then
	rm mame-menus.tar.gz
fi

if [ -f xroar-menus.tar.gz ]; then
	rm xroar-menus.tar.gz
fi

if [ -f ovcc-menus.tar.gz ]; then
	rm ovcc-menus.tar.gz
fi

if [ -f trs80gp-menus.tar.gz ]; then
	rm trs80gp-menus.tar.gz
fi

if [ -f pyDriveWire-files.tar.gz ]; then
	rm pyDriveWire-files.tar.gz
fi

if [ -f DriveWire-files.tar.gz ]; then
	rm DriveWire-files.tar.gz
fi

if [ -f lwwire-files.tar.gz ]; then
	rm lwwire-files.tar.gz
fi

if [ -f tcpser-files.tar.gz ]; then
	rm tcpser-files.tar.gz
fi

if [ -f media-share1.tar.gz ]; then
	rm media-share1.tar.gz
fi

if [ -f misc-system-files.tar.gz ]; then
	rm misc-system-files.tar.gz
fi


# create new files
tar czvf Desktop.tar.gz $HOME/Desktop

tar czvf Pictures.tar.gz $HOME/Pictures/*CoCo* $HOME/Pictures/*coco* $HOME/Pictures/*Coco* $HOME/Pictures/*rduino* $HOME/Pictures/BASIC* \
$HOME/Pictures/CM* $HOME/Pictures/DOS* $HOME/Pictures/dos* $HOME/Pictures/Dragon* $HOME/Pictures/dw4* $HOME/Pictures/flexemu* \
$HOME/Pictures/Fuji* $HOME/Pictures/fuji* $HOME/Pictures/HxC* $HOME/Pictures/irata* $HOME/Pictures/MAME* $HOME/Pictures/MC-10* \
$HOME/Pictures/mc-10* $HOME/Pictures/Monitor* $HOME/Pictures/MPI* $HOME/Pictures/NoICE* $HOME/Pictures/online6809* $HOME/Pictures/OVCC* \
$HOME/Pictures/PuTTY* $HOME/Pictures/pyD* $HOME/Pictures/Realistic* $HOME/Pictures/Tandy* $HOME/Pictures/trs80gp* $HOME/Pictures/VCC* $HOME/Pictures/XRoar* 

tar czvf scripts.tar.gz $HOME/scripts
tar czvf scripts2.tar.gz $HOME/scripts2
tar czvf source.tar.gz $HOME/source/new_windows.zip $HOME/source/*.sh $HOME/source/useroptions.mak
tar czvf source-other.tar.gz $HOME/source-other/*.sh
tar czvf fonts.tar.gz $HOME/.fonts
tar czvf misc-home-files.tar.gz $HOME/.vim $HOME/.wgetrc .$HOME/irssi $HOME/.config/geany/geany.conf $HOME/.config/geany/filedefs

tar czvf mame-menus.tar.gz $HOME/.mame
tar czvf xroar-menus.tar.gz $HOME/.xroar
tar czvf ovcc-menus.tar.gz $HOME/.ovcc/*.rom $HOME/.ovcc/*.sh $HOME/.ovcc/*.ini $HOME/.ovcc/ini/*
tar czvf trs80gp-menus.tar.gz $HOME/.trs80gp

tar czvf pyDriveWire-files.tar.gz $HOME/pyDriveWire/config/pydrivewirerc-daemon $HOME/pyDriveWire/*.sh
tar czvf DriveWire-files.tar.gz $HOME/DriveWire4/*.sh $HOME/DriveWire4/config.xml
tar czvf lwwire-files.tar.gz $HOME/lwwire/*.sh $HOME/lwwire/serserv $HOME/lwwire/tcpserv
tar czvf tcpser-files.tar.gz $HOME/tcpser/*.sh


userid=$(whoami)
if [ ! -d /media/share1 ]; then
	sudo mkdir -p /media/share1
	sudo chown $userid:$userid
fi

tar czvf media-share1.tar.gz /media/share1/carts /media/share1/source /media/share1/software/coco* /media/share1/software/dragon* /media/share1/software/mc10* /media/share1/samples
tar czvf misc-system-files.tar.gz /etc/samba/smb.conf

# capture .bashrc modifications for CoCo-Pi
grep -A500 -m1 -e 'modifications' $HOME/.bashrc > ./bashrc-cocopi.txt


if [ -f $HOME/cocopi-release.txt ]; then
	cp $HOME/cocopi-release.txt ./
fi

echo
echo
echo Done!
echo

