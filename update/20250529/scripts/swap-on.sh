#!/bin/bash

systemtype=$(dpkg --print-architecture)
echo architecture = $systemtype

if [[ $systemtype =~ amd64 ]];then
        echo This script is not compatible with your device platform.  Aborting.
        echo
        echo
        exit 1
fi


sudo /etc/init.d/dphys-swapfile stop

if [ ! -f /etc/dphys-swapfile.default ]; then
	sudo cp /etc/dphys-swapfile /etc/dphys-swapfile.default
fi


if [ ! -f /etc/dphys-swapfile.external ]; then
	sudo cp /etc/dphys-swapfile /etc/dphys-swapfile.external
	sudo sed -i 's|#CONF_SWAPFILE=/var/swap|CONF_SWAPFILE=/media/pi/COCOPI-EXT/swap.external|' /etc/dphys-swapfile.external
	sudo sed -i 's|CONF_SWAPSIZE=200|CONF_SWAPSIZE=1000|' /etc/dphys-swapfile.external
fi

sudo cp /etc/dphys-swapfile.external /etc/dphys-swapfile

sudo dphys-swapfile setup
sudo /etc/init.d/dphys-swapfile start
sudo /etc/init.d/dphys-swapfile status

swapon -s

