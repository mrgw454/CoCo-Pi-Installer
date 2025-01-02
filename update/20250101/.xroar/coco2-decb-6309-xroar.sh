#!/bin/bash

cd $HOME/.xroar

XROARPARMSFILE=`cat $HOME/.xroar/.optional_xroar_parameters.txt`
export XROARPARMS=$XROARPARMSFILE

clear

if [ -e $HOME/.xroar/.xroar_floppy ]
then
    floppy=`cat $HOME/.xroar/.xroar_floppy`

    if [ -e "$floppy" ]
    then

      echo "FLOPPY save file found - automounting [$floppy]"
      echo
      read -p  "Press any key to continue." -n1 -s
      echo

      #xroar -c $HOME/.xroar/xroar.conf -default-machine coco2bus -ao-fragments 1 -load "$floppy"
      xroar -c $HOME/.xroar/xroar.conf -default-machine coco2bus -machine-cpu 6309 -load "$floppy" $XROARPARMS

    else

      echo "FLOPPY image [$floppy] not found in FLOPPY save file.  Aborting."
      echo
      echo "Please run \"Clear all saved mount files\" on Utilities Menu."
      echo
      read -p  "Press any key to continue." -n1 -s
      echo

    fi

else

    xroar -c $HOME/.xroar/xroar.conf -default-machine coco2bus $XROARPARMS

fi

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
