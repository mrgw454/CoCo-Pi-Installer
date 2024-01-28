#!/bin/bash


if [ ! -d $HOME/CoCo-Pi-Installer ]; then
	mkdir $HOME/CoCo-Pi-Installer
fi

cd $HOME/CoCo-Pi-Installer

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

if [ -f source.tar.gz ]; then
	rm source.tar.gz
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
cd $HOME

tar czvf $HOME/CoCo-Pi-Installer/Desktop.tar.gz Desktop
tar czvf $HOME/CoCo-Pi-Installer/Pictures.tar.gz Pictures
tar czvf $HOME/CoCo-Pi-Installer/scripts.tar.gz scripts
tar czvf $HOME/CoCo-Pi-Installer/source.tar.gz source/new_windows.zip source/*.sh
tar czvf $HOME/CoCo-Pi-Installer/fonts.tar.gz .fonts
tar czvf $HOME/CoCo-Pi-Installer/misc-home-files.tar.gz .vim .wgetrc .irssi .config/geany/geany.conf .config/geany/filedefs

tar czvf $HOME/CoCo-Pi-Installer/mame-menus.tar.gz .mame
tar czvf $HOME/CoCo-Pi-Installer/xroar-menus.tar.gz .xroar
tar czvf $HOME/CoCo-Pi-Installer/ovcc-menus.tar.gz .ovcc/*.rom .ovcc/*.sh .ovcc/*.ini .ovcc/ini/*
tar czvf $HOME/CoCo-Pi-Installer/trs80gp-menus.tar.gz .trs80gp

tar czvf $HOME/CoCo-Pi-Installer/pyDriveWire-files.tar.gz pyDriveWire/config/pydrivewirerc-daemon pyDriveWire/*.sh
tar czvf $HOME/CoCo-Pi-Installer/DriveWire-files.tar.gz DriveWire4/*.sh DriveWire4/config.xml
tar czvf $HOME/CoCo-Pi-Installer/lwwire-files.tar.gz lwwire/*.sh lwwire/serserv lwwire/tcpserv
tar czvf $HOME/CoCo-Pi-Installer/tcpser-files.tar.gz tcpser/*.sh


userid=$(whoami)
if [ ! -d /media/share1 ]; then
	sudo mkdir -p /media/share1
	sudo chown $userid:$userid
fi

tar czvf $HOME/CoCo-Pi-Installer/media-share1.tar.gz /media/share1/carts /media/share1/source /media/share1/software /media/share1/samples
tar czvf $HOME/CoCo-Pi-Installer/misc-system-files.tar.gz /etc/samba/smb.conf
#tar czvf $HOME/CoCo-Pi-Installer/misc-system-files.tar.gz /etc/samba/smb.conf /etc/network/interfaces

# capture .bashrc modifications for CoCo-Pi
grep -A500 -m1 -e 'modifications' $HOME/.bashrc > ./bashrc-cocopi.txt


if [ -f $HOME/cocopi-release.txt ]; then
	cp $HOME/cocopi-release.txt $HOME/CoCo-Pi-Installer
fi

echo
echo
echo Done!
echo

