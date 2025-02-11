#!/bin/bash

# install prerequisites
sudo apt install git gcc-arm-none-eabi python3-pip srecord stm32flash zip unzip wget python3-intelhex python3-crcmod

cd $HOME/source

# if a previous greaseweazle folder exists, move into a date-time named folder

if [ -d "greaseweazle" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "greaseweazle" "greaseweazle-$foldername"

        echo -e Archiving existing greaseweazle folder ["greaseweazle"] into backup folder ["greaseweazle-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/keirf/greaseweazle
# https://github.com/keirf/greaseweazle/wiki/Firmware-Update
git clone https://github.com/keirf/greaseweazle.git

cd greaseweazle

if [ ! -f /etc/udev/rules.d/49-greaseweazle.rules ]; then

	echo udev rules not found.  Installing...
	sudo cp scripts/49-greaseweazle.rules /etc/udev/rules.d
	sudo udevadm control --reload-rules
	sudo udevadm trigger
	echo
else
	echo existing udev rules found.  skipping.
	echo
fi

python3 -m venv $HOME/source/greaseweazle/python3
$HOME/source/greaseweazle/python3/bin/python -m pip install git+https://github.com/keirf/greaseweazle@latest

echo
$HOME/source/greaseweazle/python3/bin/gw info
echo

echo
echo Done!

