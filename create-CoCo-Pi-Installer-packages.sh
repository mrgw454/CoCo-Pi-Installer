#!/bin/bash


if [ ! -d $HOME/CoCo-Pi-Installer ]; then
	mkdir $HOME/CoCo-Pi-Installer
fi

cd $HOME/CoCo-Pi-Installer

# remove previous files if they exist
if [ -f select-project-build-scripts.tar.gz ]; then
	rm select-project-build-scripts.tar.gz
fi


if [ -f scripts.tar.gz ]; then
	rm scripts.tar.gz
fi


if [ -f Pictures.tar.gz ]; then
	rm Pictures.tar.gz
fi


if [ -f Desktop.tar.gz ]; then
	rm Desktop.tar.gz
fi


if [ -f fonts.tar.gz ]; then
	rm fonts.tar.gz
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


if [ -f misc-files.tar.gz ]; then
	rm misc-files.tar.gz
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


if [ -f carts.tar.gz ]; then
	rm carts.tar.gz
fi


if [ -f source.tar.gz ]; then
	rm source.tar.gz
fi


# create new files
tar czvf select-project-build-scripts.tar.gz /home/pi/scripts/select-project-build.sh /home/pi/source/CoCo-Pi-apt-packages-to-install.sh /home/pi/source/make-*.sh
tar czvf scripts.tar.gz /home/pi/scripts
tar czvf Pictures.tar.gz /home/pi/Pictures
tar czvf Desktop.tar.gz /home/pi/Desktop
tar czvf fonts.tar.gz /home/pi/.fonts

tar czvf mame-menus.tar.gz /home/pi/.mame
tar czvf xroar-menus.tar.gz /home/pi/.xroar
tar czvf ovcc-menus.tar.gz /home/pi/.ovcc/*.rom /home/pi/.ovcc/*.sh /home/pi/.ovcc/*.ini /home/pi/.ovcc/ini/*
tar czvf trs80gp-menus.tar.gz /home/pi/.trs80gp

tar czvf misc-files.tar.gz /etc/samba/smb.conf /home/pi/.vim /home/pi/.wgetrc /home/pi/.irssi /home/pi/.config/geany/geany.conf /home/pi/.config/geany/filedefs
tar czvf pyDriveWire-files.tar.gz /home/pi/pyDriveWire/config/pydrivewirerc-daemon /home/pi/pyDriveWire/*.sh
tar czvf DriveWire-files.tar.gz /home/pi/DriveWire4/*.sh /home/pi/DriveWire4/config.xml
tar czvf lwwire-files.tar.gz /home/pi/lwwire/*.sh
tar czvf tcpser-files.tar.gz /home/pi/tcpser/*.sh

tar czvf carts.tar.gz /media/share1/carts
tar czvf source.tar.gz /home/pi/source/new_windows.zip /media/share1/source

# capture .bashrc modifications for CoCo-Pi
grep -A500 -m1 -e 'modifications' $HOME/.bashrc > ./bashrc-cocopi.txt


if [ -f $HOME/cocopi-release.txt ]; then
	cp $HOME/cocopi-release.txt ./
fi

echo
echo
echo Done!
echo

