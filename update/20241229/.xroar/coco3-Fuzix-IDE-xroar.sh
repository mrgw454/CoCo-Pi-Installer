#!/bin/bash

clear

cd $HOME/.xroar

XROARPARMSFILE=`cat $HOME/.xroar/.optional_xroar_parameters.txt`
export XROARPARMS=$XROARPARMSFILE

clear

cd $HOME/.xroar

# IDE method
xroar -c $HOME/.xroar/xroar.conf -default-machine coco3h -ram 2048K -machine-cpu 6309 -cart ide -load /media/share1/EMU/GORDON/FUZIX/fuzix.dsk -load-hd0 /media/share1/EMU/GORDON/FUZIX/fuzixfs.dsk $XROARPARM


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
CoCoPi-menu-Coco3-XRoar.sh
