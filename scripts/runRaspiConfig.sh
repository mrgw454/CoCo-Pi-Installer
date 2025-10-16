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
echo -e "This utility can damage your installation if you make incorrect selections." >> msg.txt
echo -e >> msg.txt
echo -e "More information about 'raspi-config' can be found at:" >> msg.txt
echo -e >> msg.txt
echo -e "http://linux.org/RPi_raspi-config" >> msg.txt
echo -e >> msg.txt
echo -e >> msg.txt


whiptail --title "raspi-config" --textbox msg.txt 0 0
rm msg.txt

sudo raspi-config

cd $HOME/.mame

