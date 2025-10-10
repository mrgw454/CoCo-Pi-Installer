#!/bin/bash

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


# https://github.com/qbancoffee/drivewire4/tree/main
git clone https://github.com/qbancoffee/drivewire4.git

GITREV=`git rev-parse --short HEAD`

cd drivewire4/drivewire4_from_source

# we need this version of the swt library jar file to get things working properly
wget --content-disposition "https://www.eclipse.org/downloads/download.php?file=/eclipse/downloads/drops4/R-4.33-202409030240/swt-4.33-gtk-linux-aarch64.zip"

if [ $? -eq 0 ]
then
        echo "Download of swt-4.33-gtk-linux-aarch64.zip archive was successful."
        echo
else
        echo "Download of swt-4.33-gtk-linux-aarch64.zip archive was NOT successful.  Aborting."
        echo
        exit 1
fi

unzip -o swt-4.33-gtk-linux-aarch64.zip swt.jar -d swt/linux
unzip -o swt-4.33-gtk-linux-aarch64.zip swt.jar -d swt/linux_arm

ant


if [ $systemtype = arm64 ]; then
        if [ -f drivewire4_linux_arm_64 ]; then
                echo DriveWire4 compilation successful.
                echo
        else
                echo DriveWire4 compilation was NOT successful.
                echo
        fi

elif [ $systemtype = amd64 ]; then
        if [ -f drivewire4_linux_x86_64 ]; then
                echo DriveWire4 compilation successful.
                echo
        else
                echo DriveWire4 compilation was NOT successful.
                echo
        fi
fi


#restore backed up config file
if [ -f $HOME/source/drivewire4-$foldername/drivewire4_from_source/config.xml ]; then
       	echo Found existing config file.  Restoring $HOME/source/drivewire4-$foldername/drivewire4_from_source/config.xml to ./config.xml
       	echo
       	cp $HOME/source/drivewire4-$foldername/drivewire4_from_source/config.xml ./config.xml
       	echo
       	echo
else
        echo No existing config file.  Copying from CoCo-Pi-Installer...
       	tar zxvf $HOME/CoCo-Pi-Installer/DriveWire-files.tar.gz --strip-components 1 DriveWire4/config.xml -C $HOME/source/drivewire4/drivewire4_from_source
        echo
        echo
fi


# restore script files
if [ -f $HOME/source/drivewire4-$foldername/drivewire4_from_source/DW4.sh ]; then
        echo Found existing config file.  Restoring $HOME/source/drivewire4-$foldername/drivewire4_from_source/DW4.sh ./DW4.sh
        echo
        cp $HOME/source/drivewire4-$foldername/drivewire4_from_source/DW4.sh ./DW4.sh
        echo
        echo
else
        echo No existing DW4.sh file.  Copying from CoCo-Pi-Installer...
        tar zxvf $HOME/CoCo-Pi-Installer/DriveWire-files.tar.gz --strip-components 1 DriveWire4/DW4.sh -C $HOME/source/drivewire4/drivewire4_from_source
        echo
        echo
fi

if [ -f $HOME/source/drivewire4-$foldername/drivewire4_from_source/restartDW4.sh ]; then
        echo Found existing config file.  Restoring $HOME/source/drivewire4-$foldername/drivewire4_from_source/restartDW4.sh ./restartDW4.sh
        echo
        cp $HOME/source/drivewire4-$foldername/drivewire4_from_source/restartDW4.sh ./restartDW4.sh
        echo
        echo
else
        echo No existing restartDW4.sh file.  Copying from CoCo-Pi-Installer...
        tar zxvf $HOME/CoCo-Pi-Installer/DriveWire-files.tar.gz --strip-components 1 DriveWire4/restartDW4.sh -C $HOME/source/drivewire4/drivewire4_from_source
        echo
        echo
fi

if [ -f $HOME/source/drivewire4-$foldername/drivewire4_from_source/stopDW4.sh ]; then
        echo Found existing config file.  Restoring $HOME/source/drivewire4-$foldername/drivewire4_from_source/stopDW4.sh ./stopDW4.sh
        echo
        cp $HOME/source/drivewire4-$foldername/drivewire4_from_source/stopDW4.sh ./stopDW4.sh
        echo
        echo
else
        echo No existing stopDW4.sh file.  Copying from CoCo-Pi-Installer...
        tar zxvf $HOME/CoCo-Pi-Installer/DriveWire-files.tar.gz --strip-components 1 DriveWire4/stopDW4.sh -C $HOME/source/drivewire4/drivewire4_from_source
        echo
        echo
fi




# create new symbolic link to backup folder
if [ ! -L $HOME/DriveWire4 ]; then
	ln -s $HOME/source/drivewire4-$foldername/drivewire4_from_source $HOME/DriveWire4
fi

cd $HOME/source


echo
echo Done!
