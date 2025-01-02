#!/bin/bash

clear

cd $HOME/.xroar

XROARPARMSFILE=`cat $HOME/.xroar/.optional_xroar_parameters.txt`
export XROARPARMS=$XROARPARMSFILE

clear

cd $HOME/pyDriveWire

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw server hdbdos 0

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk insert 0 /media/share1/DW4/GORDON/FUZIX/fuzix.dsk

cd $HOME/.xroar

rm /media/share1/EMU/GORDON/FUZIX/fuzixfs.img

# create link for headerless hard drive image (.img extension)
ln -s /media/share1/EMU/GORDON/FUZIX/fuzixfs.dsk /media/share1/EMU/GORDON/FUZIX/fuzixfs.img

# IDE method (still requires loading boot disk from pyDriveWire)
# type in HDA at the bootdev prompt to boot from hard drive image
xroar -c $HOME/.xroar/xroar.conf -default-machine coco3h -ram 2048K -machine-cpu 6309 -cart ide -load /media/share1/EMU/GORDON/FUZIX/fuzix.dsk -load-hd0 /media/share1/EMU/GORDON/FUZIX/fuzixfs.img -type 'LOADM "BOOT.BIN"\r\r\rEXEC\r' $XROARPARM


# capture XRoar ERRORLEVEL

if [ $? -eq 0 ]
then
        echo
else
        echo
        echo "Please make note of message above when requesting help."
        echo
        read -p  "Press any key to continue." -n1 -s
fi

cd $HOME/pyDriveWire
$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw server hdbdos 1

cd $HOME/.mame
CoCoPi-menu-Coco3-XRoar.sh
