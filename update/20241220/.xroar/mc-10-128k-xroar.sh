#!/bin/bash

cd $HOME/.xroar

XROARPARMSFILE=`cat $HOME/.xroar/.optional_xroar_parameters.txt`
export XROARPARMS=$XROARPARMSFILE

clear

    xroar -c $HOME/.xroar/xroar.conf -default-machine mc10 -cart mcx128 -no-tape-fast -no-tape-pad-auto $XROARPARMS

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
CoCoPi-menu-MC10-XRoar.sh
