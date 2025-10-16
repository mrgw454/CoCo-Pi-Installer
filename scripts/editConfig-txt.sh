#!/bin/bash

systemtype=$(dpkg --print-architecture)
echo architecture = $systemtype

if [[ $systemtype != arm64 ]];then
        echo This method of editing WiFi is not compatible with your platform.  Aborting.
        echo
        echo
        read -p "Press any key to continue... " -n1 -s
        exit 1
fi

clear

echo
echo
echo
echo
echo
echo
echo
echo

echo -e "*** CAUTION!!! ****" > msg.txt
echo -e >> msg.txt
echo -e "Editing this file can damage your installation and prevent successful booting." >> msg.txt
echo -e >> msg.txt
echo -e "More information about '/boot/config.txt' can be found at:" >> msg.txt
echo -e >> msg.txt
echo -e "http://elinux.org/RPi_configuration_file#A_quick_overview" >> msg.txt
echo -e >> msg.txt
echo -e >> msg.txt


whiptail --title "Edit /boot/config.txt" --textbox msg.txt 0 0
rm msg.txt

sudo nano /boot/firmware/config.txt

cd $HOME/.mame

