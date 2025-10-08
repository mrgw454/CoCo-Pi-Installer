#!/bin/bash

# install prerequsities
sudo apt install openjdk-21-jdk


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

        # backup config file
        if [ -f drivewire4/drivewire4_from_source/config.xml ]; then
                echo Found existing config file.  Backing up to ./config.xml-$foldername
                echo
                cp drivewire4/drivewire4_from_source/config.xml ./config.xml-$foldername
                echo
        fi

	# backup scripts
	cp drivewire4/drivewire4_from_source/DW4.sh ./
	cp drivewire4/drivewire4_from_source/restartDW4.sh ./
	cp drivewire4/drivewire4_from_source/stopDW4.sh ./


	echo Archiving existing drivewire4 folder ["drivewire4"] into backup folder ["drivewire4-$foldername"]
	echo
	mv "drivewire4" "drivewrire4-$foldername"
	echo

fi


# https://github.com/qbancoffee/drivewire4/tree/main
git clone https://github.com/qbancoffee/drivewire4.git

GITREV=`git rev-parse --short HEAD`

cd drivewire4/drivewire4_from_source

ant

if [ -f drivewire4_linux_arm_64 ]; then
	echo DriveWire4 compilation successful.
	echo

	# restore backed up config file
	if [ -f ../../config.xml-$foldername ]; then
        	echo Found existing config file.  Restoring ../../config.xml-$foldername to ./config.xml
        	echo
        	cp ../../config.xml-$foldername ./config.xml
        	echo
        	echo
	else
	        echo No existing config file.  Copying from CoCo-Pi-Installer...
        	tar zxvf $HOME/CoCo-Pi-Installer/DriveWire-files.tar.gz --strip-components 1 DriveWire4/config.xml -C $HOME/source/drivewire4/drivewire4_from_source
	        echo
	        echo
	fi


	# restore script files

	if [ -f ../../DW4.sh ]; then
        	cp ../../DW4.sh ./
	else
        	tar zxvf $HOME/CoCo-Pi-Installer/DriveWire-files.tar.gz --strip-components 1 DriveWire4/DW4.sh -C $HOME/source/drivewire4/drivewire4_from_source
	fi


	if [ -f ../../restartDW4.sh ]; then
        	cp ../../restartDW4.sh ./
	else
        	tar zxvf $HOME/CoCo-Pi-Installer/DriveWire-files.tar.gz --strip-components 1 DriveWire4/restartDW4.sh -C $HOME/source/drivewire4/drivewire4_from_source
	fi


	if [ -f ../../stopDW4.sh ]; then
        	cp ../../stopDW4.sh ./
	else
        	tar zxvf $HOME/CoCo-Pi-Installer/DriveWire-files.tar.gz --strip-components 1 DriveWire4/stopDW4.sh -C $HOME/source/drivewire4/drivewire4_from_source
	fi


	# remove symbolic link if it exists
	if [ -L $HOME/DriveWire4 ]; then
        	rm $HOME/DriveWire4
	fi

	# create new symbolic link to backup folder
	ln -s $HOME/source/drivewire4/drivewire4_from_source $HOME/DriveWire4


else

	echo DriveWire4 compilation failed.  Installation aborted.
	echo
	echo

	# remove symbolic link if it exists
	if [ -L $HOME/DriveWire4 ]; then
        	rm $HOME/DriveWire4
	fi

	# create new symbolic link to backup folder
	ln -s $HOME/source/drivewire4-$foldername/drivewire4_from_source $HOME/DriveWire4
fi

cd ../..

echo
echo Done!
