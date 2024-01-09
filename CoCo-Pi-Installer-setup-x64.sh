#!/bin/bash

clear

echo "This script will perform initial staging and installation of components needed for the CoCo-Pi distribution."
echo
read -p "Press any key to continue or [CTRL-C] to abort..." -n1 -s
echo
echo

# validate Debian OS and architecture is compatible before proceeding
version_check=$(cat /etc/os-release | grep VERSION= | cut -d'"' -f 2)
#echo $version_check

if [ "$version_check" != "12 (bookworm)" ]; then
	echo The version of Debian OS is not compatible with this installer.
	echo
	echo Aborting.
	echo
	echo
	exit 1
else
	systemtype=$(dpkg --print-architecture)

	if [ $systemtype != amd64 ]; then
		echo The version of Debian OS is not compatible with this installer.
		echo
		echo "You must use the amd64 (64 bit) and not 32 bit version (architecture type)."
		echo
		echo Aborting.
		echo
		echo
		exit 1
	else
		echo The version of Debian OS you have is compatible with this installer.  Proceeding.
		echo
		echo
	fi

fi


backupdate=$(date +"%Y%m%d_%H%M%S")

# create base folders
if [ ! -d /media/share1 ]; then
	echo "Please make sure /media/share1 path exists (and is writable) for current user before continuing!"
	echo
	read -p "Press any key to continue... " -n1 -s
	echo
else
	echo /media/share1 folder exists
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

    # install core CoCo-Pi scripts and menus
    tar xzvf $HOME/CoCo-Pi-Installer/select-project-build-scripts.tar.gz -C /
    tar xzvf $HOME/CoCo-Pi-Installer/mame-menus.tar.gz -C /
    tar xzvf $HOME/CoCo-Pi-Installer/xroar-menus.tar.gz -C /
    tar xzvf $HOME/CoCo-Pi-Installer/ovcc-menus.tar.gz -C /
    tar xzvf $HOME/CoCo-Pi-Installer/trs80gp-menus.tar.gz -C /
    tar xzvf $HOME/CoCo-Pi-Installer/scripts.tar.gz -C /
    tar xzvf $HOME/CoCo-Pi-Installer/misc-files.tar.gz -C /
    tar xzvf $HOME/CoCo-Pi-Installer/lwwire-files.tar.gz -C /
    tar xzvf $HOME/CoCo-Pi-Installer/tcpser-files.tar.gz -C /
    tar xzvf $HOME/CoCo-Pi-Installer/carts.tar.gz -C /
    tar xzvf $HOME/CoCo-Pi-Installer/source.tar.gz -C /


    tar xzvf $HOME/CoCo-Pi-Installer/Desktop.tar.gz -C /

    # install additional fonts related to CoCo-Pi
    tar xzvf $HOME/CoCo-Pi-Installer/fonts.tar.gz -C /
    fc-cache -f -v

    # add user to dialout group
    userid=$(whoami)
    sudo usermod -a -G dialout $userid

    cp $HOME/CoCo-Pi-Installer/cocopi-release.txt $HOME

    # add CoCo-Pi related environment settings to .bashrc for user pi
    echo >> $HOME/.bashrc
    echo >> $HOME/.bashrc
    cat $HOME/CoCo-Pi-Installer/bashrc-cocopi.txt >> $HOME/.bashrc
    source $HOME/.bashrc

    cd $HOME


# install pyenv to add python2
cd $HOME/CoCo-Pi-Installer

./install-pyenv.sh

cd $HOME

echo
echo
echo Please reboot as soon as possible so all updates can be applied.  Thank you.
echo
read -p "Press any key to continue... " -n1 -s

echo
echo Done!
echo
