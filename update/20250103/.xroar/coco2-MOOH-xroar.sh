#!/bin/bash

cd $HOME/.xroar

XROARPARMSFILE=`cat $HOME/.xroar/.optional_xroar_parameters.txt`
export XROARPARMS=$XROARPARMSFILE

clear

xroar -default-machine coco2bus -cart mooh -cart-rom $HOME/source/sdboot/bootrom/eprom8.rom -load-hd0 $HOME/source/FUZIX-MOOH/Images/dragon-mooh/disk.img $XROARPARMS

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

cd $HOME/.mame
CoCoPi-menu-Coco2-XRoar.sh
