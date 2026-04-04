#!/bin/bash

clear

echo "This script will resolve any minor issues that need to be addressed for the CoCo-Pi distribution."
echo
read -p "Press any key to continue or [CTRL-C] to abort..." -n1 -s
echo
echo

backupdate=$(date +"%Y%m%d_%H%M%S")

if [ -e "$HOME/update/.fix-cocopi-skip-config-clobber" ]; then
        echo "Skipping update of /boot/config.txt - If you want this update then go to the Utilities->Administration menu and select Toggle Raspberry PI config.txt updates"
        echo
        read -p "Press any key to continue... " -n1 -s
        echo
else

        # detect model of Raspberry Pi
        RPI=`cat /proc/device-tree/model | cut -c14-16`

        if [ "$RPI" == "500" ]; then
        #sudo cp /home/pi/update/config.txt.RPi500 /boot/config.txt
        echo

        fi

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
#    cp $HOME/CoCo-Pi-Installer/update/20231022/.mame/* $HOME/.mame
#    cp $HOME/CoCo-Pi-Installer/update/20231022/source/* $HOME/source

#    cd $HOME

#    echo "$fix" >>$file
#    echo
#fi


# check for fix
fix="fix-20260404-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo
    cp $HOME/CoCo-Pi-Installer/update/20260404/.optional_mame_parameters.txt $HOME/.mame
    cp $HOME/CoCo-Pi-Installer/update/20260404/.optional_xroar_parameters.txt $HOME/.xroar
    cp $HOME/CoCo-Pi-Installer/update/20260404/.optional_trs80gp_parameters.txt $HOME/.trs80gp

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20260404-02"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo
    bashrc="$HOME/.bashrc"
    marker='[ "$(uname -m)" = "aarch64" ] && export GDK_BACKEND=x11'
    if grep -qF "$marker" "$bashrc"; then
        echo "GDK_BACKEND fix already present in $bashrc, skipping."
    else
        echo "" >> "$bashrc"
        echo "# fix needed to get XRoar working properly when Wayland is the default" >> "$bashrc"
        echo '[ "$(uname -m)" = "aarch64" ] && export GDK_BACKEND=x11' >> "$bashrc"
        echo "Added GDK_BACKEND fix to $bashrc"
    fi
    echo

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20260404-03"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo
    cp $HOME/CoCo-Pi-Installer/update/20260404/launcher.py $HOME/scripts/launcher/launcher.py
    cp $HOME/CoCo-Pi-Installer/update/20260404/81-maintenance-updates.json $HOME/scripts/launcher/config/81-maintenance-updates.json

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
