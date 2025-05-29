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
sudo cp /etc/dphys-swapfile.default /etc/dphys-swapfile

sudo /etc/init.d/dphys-swapfile start
sudo /etc/init.d/dphys-swapfile status

swapon -s

