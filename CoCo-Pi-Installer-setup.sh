#!/bin/bash

clear

echo "This script will perform initial staging and installation of components needed for the CoCo-Pi distribution."
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
	sudo mkdir /media/share1
	sudo chown -R pi.pi /media/share1
	sudo chmod -R u+rw,g+rw /media/share1
	echo Adding /media/share1 folder
	echo
else
	echo /media/share1 folder exists
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



if [ -e "$HOME/update/.fix-cocopi-skip-config-clobber" ]; then
	echo "Skipping update of /boot/config.txt - If you want this update then go to the Utilities->Administration menu and select Toggle Raspberry PI config.txt updates"
	echo
	read -p "Press any key to continue... " -n1 -s
	echo
else

	# detect model of Raspberry Pi
	RPI=`cat /proc/device-tree/model | cut -c14-16`

	if [[ "$RPI" == "5 M" ]]; then
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


echo

# set hotfixes file
file="$HOME/update/cocopi-fixes.txt"
# create the file if it doesn't exist
touch $file



# example placeholder
# check for fix
#fix="fix-20231023-01"
#if grep -q "$fix" $file; then
#    echo fix $fix already complete.
#    echo
#else
#    echo Applying fix $fix...
#    echo
#    tar xzf /home/pi/update/sdboot-git-20231022-CoCoPi.tar.gz -C /

#    cd $HOME

#    echo "$fix" >>$file
#    echo
#fi


# perform initial pull for CoCo-Pi-Installer
# check for fix
fix="fix-20231226-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo
    cd /home/pi/CoCo-Pi-Installer

    git init
    git remote add origin https://github.com/mrgw454/CoCo-Pi-Installer.git
    git fetch
    git reset --hard origin/master
    git pull origin master
    git config --global pull.ff only

    git fetch --all
    git reset --hard origin/master
    git pull origin master

    tar xzvf /home/pi/CoCo-Pi-Installer/select-project-build-scripts.tar.gz -C /
    tar xzvf /home/pi/CoCo-Pi-Installer/mame-menus.tar.gz -C /
    tar xzvf /home/pi/CoCo-Pi-Installer/xroar-menus.tar.gz -C /
    tar xzvf /home/pi/CoCo-Pi-Installer/trs80gp-menus.tar.gz -C /
    tar xzvf /home/pi/CoCo-Pi-Installer/scripts.tar.gz -C /

    tar xzvf /home/pi/CoCo-Pi-Installer/Pictures.tar.gz -C /
    pcmanfm --wallpaper-mode=color
    pcmanfm --wallpaper-mode=center
    pcmanfm --set-wallpaper /home/pi/Pictures/CoCo-Pi\ 4x3\ black.png

    tar xzvf /home/pi/CoCo-Pi-Installer/Desktop.tar.gz -C /

    tar xzvf /home/pi/CoCo-Pi-Installer/fonts.tar.gz -C /
    fc-cache -f -v

    cp /home/pi/CoCo-Pi-Installer/cocopi-release.txt $HOME
    cat /home/pi/CoCo-Pi-Installer/bashrc-cocopi.txt >> $HOME/.bashrc
    source $HOME/.bashrc

    cd $HOME

    echo "$fix" >>$file
    echo
fi



echo
echo
echo Please reboot as soon as possible so all updates can be applied.  Thank you.
echo
read -p "Press any key to continue... " -n1 -s

echo
echo Done!
echo
