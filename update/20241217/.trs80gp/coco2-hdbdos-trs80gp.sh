#!/bin/bash

cd $HOME/.trs80gp

TRS80GPPARMSFILE=`cat $HOME/.trs80gp/.optional_trs80gp_parameters.txt`
export TRS80GPPARMS=$TRS80GPPARMSFILE

clear

/usr/local/bin/trs80gp $TRS80GPPARMS -mc -bck localhost:65504 -pakq /media/share1/roms/hdbdw3bc3.rom

# capture trs80gp ERRORLEVEL

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
CoCoPi-menu-Coco2-trs80gp.sh
