#!/bin/bash

clear

# set current SDC image filename
#export SDCIMAGE=https://colorcomputerarchive.com/repo/Disks/Coco%20SDC/Image/Coco%20SDC%20Image%20%282022-02-11%29.zip
#export SDCIMAGE=https://colorcomputerarchive.com/repo/Disks/Coco%20SDC/Image/Coco%20SDC%20Image%20%282022-03-20%29.zip
#export SDCIMAGE="https://colorcomputerarchive.com/repo/Disks/Coco%20SDC/Image/Coco%20SDC%20Image%20(2023-12-17).zip"
export SDCIMAGE="https://colorcomputerarchive.com/repo/Disks/Coco%20SDC/Image/Coco%20SDC%20Image%20(2025-04-30).zip"

echo
echo
echo
echo
echo
echo
echo
echo

echo -e
echo -e "This script will download the 'Ultimate' CoCoSDC Image."
echo -e
echo -e "Please make a backup of all your files in /media/share1/SDC"
echo -e "as any existing file(s) will be overwritten."
echo -e
echo -e "Press [CTRL-C] to cancel script or ..."
echo -e
read -p "... Press any key to continue." -n1 -s
echo -e
echo -e
echo -e "Downloading SDC Image file..."
echo -e

if [ ! -d /media/share/SDC ]; then
	mkdir /media/share1/SDC
fi

wget --no-use-server-timestamps -c -P /media/share1/SDC $SDCIMAGE

cd /media/share1/SDC

    echo -e "Extracting files into /media/share1/SDC..."
    echo -e
    fn=$(ls -t | head -n1)

    unzip -o "$fn" -d /media/share1/SDC
    echo -e
    echo -e "Done!"
    echo -e
    read -p "Press any key to continue." -n1 -s

rm "$fn"

cd $HOME/.mame


