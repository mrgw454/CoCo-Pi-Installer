#!/bin/bash

clear

echo "This script will perform initial staging and installation of components needed for the CoCo-Pi distribution."
echo
read -p "Press any key to continue or [CTRL-C] to abort..." -n1 -s
echo
echo

# validate Debian OS and architecture is compatible before proceeding
version_check=$(cat /etc/os-release | grep VERSION= | cut -d'"' -f 2)
systemtype=$(dpkg --print-architecture)

echo "Detected OS          : $version_check"
echo "Detected Architecture: $systemtype"
echo
echo

if [ "$version_check" != "12 (bookworm)" ]; then

	if [ "$systemtype" != "amd64" ]; then
		echo The version of Debian OS is not compatible with this installer.
		echo
		echo You must use one of the following versions:
		echo
		echo Linux native:
		echo "https://cdimage.debian.org/debian-cd/current/amd64/bt-dvd/debian-12.4.0-amd64-DVD-1.iso.torrent"
		echo
		echo Linux Subsystem for Windows:
		echo "https://apps.microsoft.com/detail/9MSVKQC78PK6?hl=en-US&gl=US"
		echo Aborting.
		echo
		echo
		exit 1
	fi

	if [ "$systemtype" != "arm64" ]; then
		echo The version of Raspberry Pi OS is not compatible with this installer.
		echo
		echo You must use this version:
		echo "https://downloads.raspberrypi.com/raspios_full_armhf/images/raspios_full_armhf-2023-12-06/2023-12-05-raspios-bookworm-armhf-full.img.xz"
		echo
		echo Aborting.
		echo
		exit 1
	fi

fi


if [ "$systemtype" = "amd64" ] || [ "$systemtype" = "arm64" ]; then
	echo
	echo OK
else
	echo This architecture type is not compatible with this installer.
	echo
	echo "You must use an amd64 (64 bit) or arm64 (64b bit) platform.  32 bit is not supported."
	echo
	echo Aborting.
	echo
	echo
	exit 1
fi

echo
echo Compatible operating system and system architecture detected.  Proceeding with installation.
echo
echo

read -p "Press any key to continue or [CTRL-C] to abort..." -n1 -s
echo
echo

backupdate=$(date +"%Y%m%d_%H%M%S")

# create base folders
if [ ! -d $HOME/update ]; then
	mkdir $HOME/update
	echo Adding $HOME/update folder
	echo
else
	echo $HOME/update folder exists
	echo
fi


if [ ! -d $HOME/packages ]; then
	mkdir $HOME/packages
	echo Adding $HOME/packages folder
	echo
else
	echo $HOME/packages folder exists
	echo
fi


if [ ! -d /media/share1 ]; then
	userid=$(whoami)
	sudo mkdir -p /media/share1
	sudo chown $userid:$userid /media/share1
	echo Adding /media/share1 folder
	echo
else
	echo /media/share1 folder exists
	echo
fi


if [ ! -d /media/share1/source ]; then
	mkdir /media/share1/source
	echo Adding /media/share1/source folder
	echo
else
	echo /media/share1/source folder exists
	echo
fi


if [ ! -d /media/share1/carts ]; then
	mkdir /media/share1/carts
	echo Adding /media/share1/carts folder
	echo
else
	echo /media/share1/carts folder exists
	echo
fi


if [ ! -d /media/share1/SDC ]; then
	mkdir /media/share1/SDC
	echo Adding /media/share1/SDC folder
	echo
else
	echo /media/share1/SDC folder exists
	echo
fi


if [ ! -d /media/share1/SDC-dragon ]; then
	mkdir /media/share1/SDC-dragon
	echo Adding /media/share1/SDC-dragon folder
	echo
else
	echo /media/share1/SDC-dragon folder exists
	echo
fi


if [ ! -d /media/share1/cassette ]; then
	mkdir /media/share1/cassette
	echo Adding /media/share1/cassette folder
	echo
else
	echo /media/share1/cassette folder exists
	echo
fi


if [ ! -d /media/share1/cassette-dragon ]; then
	mkdir /media/share1/cassette-dragon
	echo Adding /media/share1/cassette-dragon folder
	echo
else
	echo /media/share1/cassette-dragon folder exists
	echo
fi


if [ ! -d /media/share1/MCX ]; then
	mkdir /media/share1/MCX
	echo Adding /media/share1/MCX folder
	echo
else
	echo /media/share1/MCX folder exists
	echo
fi


if [ ! -d $HOME/CoCo-Pi-Installer ]; then
	mkdir $HOME/CoCo-Pi-Installer
	echo Adding $HOME/CoCo-Pi-Installer folder
	echo
else
	echo $HOME/CoCo-Pi-Installer exists
	echo
fi


echo


# set up CoCo-Pi-Installer github repo
cd $HOME/CoCo-Pi-Installer
git init
git remote add origin https://github.com/mrgw454/CoCo-Pi-Installer.git
git fetch
git reset --hard origin/master
git pull origin master
git config --global pull.ff only

git fetch --all
git reset --hard origin/master
git pull origin master


# for Raspberry Pi only
if [ "$systemtype" = "arm64" ]; then

	if [ -f "$HOME/update/.fix-cocopi-skip-config-clobber" ]; then
		echo "Skipping update of /boot/config.txt for Raspberry Pi (arm64) platforms."
		echo "If you want to override this, go to the Utilities -> Administration menu and select Toggle Raspberry PI config.txt updates."
		echo
		read -p "Press any key to continue... " -n1 -s
		echo
	else
		# detect model of Raspberry Pi
		RPI=`cat /proc/device-tree/model | cut -c14-16`

		if [ "$RPI" == "5 M" ]; then
        		#sudo cp /home/pi/update/config.txt.RPi5 /boot/config.txt
        		echo
 		fi

		if [ "$RPI" == "400" ]; then
        		#sudo cp /home/pi/update/config.txt.RPi400 /boot/config.txt
        		echo
		fi

		if [ "$RPI" == "4 M" ]; then
		        #sudo cp /home/pi/update/config.txt.RPi4 /boot/config.txt
		        echo
		fi

		if [ "$RPI" == "3 M" ]; then
		        #sudo cp /home/pi/update/config.txt.RPi3 /boot/config.txt
        		echo
		fi

	fi


	# set backgroup wallpaper for CoCo-Pi
	tar xzvf /home/pi/CoCo-Pi-Installer/Pictures.tar.gz -C /
	pcmanfm --wallpaper-mode=color
	pcmanfm --wallpaper-mode=stretch
	pcmanfm --set-wallpaper /home/pi/Pictures/CoCo-Pi\ 16x9\ black.png

fi


# extract core CoCo-Pi scripts and menus
tar xzvf $HOME/CoCo-Pi-Installer/Desktop.tar.gz -C $HOME
tar xzvf $HOME/CoCo-Pi-Installer/Pictures.tar.gz -C $HOME
tar xzvf $HOME/CoCo-Pi-Installer/scripts.tar.gz -C $HOME
tar xzvf $HOME/CoCo-Pi-Installer/source.tar.gz -C $HOME
tar xzvf $HOME/CoCo-Pi-Installer/misc-home-files.tar.gz -C $HOME

tar xzvf $HOME/CoCo-Pi-Installer/mame-menus.tar.gz -C $HOME
tar xzvf $HOME/CoCo-Pi-Installer/xroar-menus.tar.gz -C $HOME
tar xzvf $HOME/CoCo-Pi-Installer/ovcc-menus.tar.gz -C $HOME
tar xzvf $HOME/CoCo-Pi-Installer/trs80gp-menus.tar.gz -C $HOME

tar xzvf $HOME/CoCo-Pi-Installer/lwwire-files.tar.gz -C $HOME
tar xzvf $HOME/CoCo-Pi-Installer/tcpser-files.tar.gz -C $HOME

# install additional fonts related to CoCo-Pi
tar xzvf $HOME/CoCo-Pi-Installer/fonts.tar.gz -C $HOME
fc-cache -f -v

tar xzvf $HOME/CoCo-Pi-Installer/media-share1.tar.gz -C /
sudo tar xzvf $HOME/CoCo-Pi-Installer/misc-system-files.tar.gz -C /

cp $HOME/CoCo-Pi-Installer/cocopi-release.txt $HOME

# add CoCo-Pi related environment settings to .bashrc
echo >> $HOME/.bashrc
echo >> $HOME/.bashrc
cat $HOME/CoCo-Pi-Installer/bashrc-cocopi.txt >> $HOME/.bashrc
source $HOME/.bashrc

tar xzvf /home/pi/CoCo-Pi-Installer/Desktop.tar.gz -C /

# enable ssh server
sudo systemctl enable ssh
sudo systemctl start ssh

# add user to dialout and plugdev groups
userid=$(whoami)
sudo usermod -a -G dialout $userid
sudo usermod -a -G plugdev $userid

# install pyenv to add python2
cd $HOME/CoCo-Pi-Installer

./install-pyenv.sh

# required to allow some pip3 packages to be installed
if [ -f /usr/lib/python3.11/EXTERNALLY-MANAGED ]; then
	sudo mv /usr/lib/python3.11/EXTERNALLY-MANAGED /usr/lib/python3.11/EXTERNALLY-MANAGED.disabled
fi

cd $HOME

echo
echo
echo Please reboot as soon as possible so all updates can be applied.  Thank you.
echo
read -p "Press any key to continue... " -n1 -s

echo
echo Done!
echo
