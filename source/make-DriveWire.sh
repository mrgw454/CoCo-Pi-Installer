#!/bin/bash

# install prerequisites
sudo apt -y install libswt-webkit-gtk-4-jni

# set up some variables
# determine architecture type
systemtype=$(dpkg --print-architecture)

# verify java version
JAVA_MAJOR_VERSION=$(java -version 2>&1 | sed -E -n 's/.* version "([^.-]*).*"/\1/p' | cut -d' ' -f1)


if [ $JAVA_MAJOR_VERSION -ge 17 ]; then
	echo JAVA major version is $JAVA_MAJOR_VERSION.  Good!
	echo
else
	echo JAVA major version is $JAVA_MAJOR_VERSION.  Installation aborted.
	echo
	echo
	exit 1
fi

cd $HOME/source

# if a previous drivewire4 folder exists, move into a date-time named folder

if [ -d "drivewire4" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

	echo Archiving existing drivewire4 folder ["drivewire4"] into backup folder ["drivewire4-$foldername"]
	echo
	mv "drivewire4" "drivewire4-$foldername"
	echo

fi


# https://github.com/qbancoffee/drivewire4
git clone https://github.com/qbancoffee/drivewire4.git

cd drivewire4

GITREV=`git rev-parse --short HEAD`

mkdir release
cd release

if [ $systemtype = arm64 ]; then
	wget https://github.com/qbancoffee/drivewire4/releases/download/4.3.4p_linux_aarch64/drivewire4_java21_linux_arm_64.zip



        if [ -f drivewire4_java21_linux_arm_64.zip ]; then
                echo DriveWire4 archive found.  Unzipping.
                echo
		unzip drivewire4_java21_linux_arm_64.zip
		echo
        else
                echo DriveWire4 archive not found.  Aborting.
                echo
		exit 1
        fi

elif [ $systemtype = amd64 ]; then
	wget https://github.com/qbancoffee/drivewire4/releases/download/4.3.4p_linux_x86_64/drivewire4_java21_linux_x86_64.zip

        if [ -f drivewire4_java21_linux_x86_64.zip ]; then
                echo DriveWire4 archive found.  Unzipping.
                echo
		unzip drivewire4_java21_linux_x86_64.zip
		echo
        else
                echo DriveWire4 archive not found.  Aborting.
                echo
		exit 1
        fi
fi


sed -i 's|INSTALLDIR="$HOME/drive_wire_4_java"|INSTALLDIR="$HOME/DriveWire4"|' install_linux
chmod a+x install_linux
./install_linux

sed -i 's|/home/pi|$HOME|g' $HOME/DriveWire4/start
chmod a+x $HOME/DriveWire4/start

#restore backed up config file
if [ -f $HOME/DriveWire4/config.xml ]; then
       	echo Found existing config file.  Skipping.
       	echo
       	echo
else
        echo No existing config file.  Copying from CoCo-Pi-Installer...
       	tar zxvf $HOME/CoCo-Pi-Installer/DriveWire-files.tar.gz --strip-components 1 -C $HOME/DriveWire4 DriveWire4/config.xml
        echo
        echo
fi


# restore script files
if [ -f $HOME/DriveWire4/DW4.sh ]; then
	echo Found existing config file.  Skipping.
        echo
	echo
else
        echo No existing DW4.sh file.  Copying from CoCo-Pi-Installer...
        tar zxvf $HOME/CoCo-Pi-Installer/DriveWire-files.tar.gz --strip-components 1 -C $HOME/DriveWire4 DriveWire4/DW4.sh
        echo
        echo
fi

if [ -f $HOME/DriveWire4/restartDW4.sh ]; then
	echo Found existing config file.  Skipping.
        echo
        echo
else
        echo No existing restartDW4.sh file.  Copying from CoCo-Pi-Installer...
        tar zxvf $HOME/CoCo-Pi-Installer/DriveWire-files.tar.gz --strip-components 1 -C $HOME/DriveWire4 DriveWire4/restartDW4.sh
        echo
        echo
fi

if [ -f $HOME/DriveWire4/stopDW4.sh ]; then
	echo Found existing config file.  Skipping.
        echo
        echo
else
        echo No existing stopDW4.sh file.  Copying from CoCo-Pi-Installer...
        tar zxvf $HOME/CoCo-Pi-Installer/DriveWire-files.tar.gz --strip-components 1 -C $HOME/DriveWire4 DriveWire4/stopDW4.sh
        echo
        echo
fi


cp $HOME/DriveWire4/drivewire4.desktop $HOME/Desktop

cd $HOME/source


echo
echo Done!
