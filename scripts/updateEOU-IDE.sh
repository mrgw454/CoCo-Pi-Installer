#!/bin/bash

# script to update Michael Furman's EOU for IDE project from github repo
cd $HOME/source

# if a previous xroar-git folder exists, move into a date-time named folder

if [ -d "eou_ide" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "eou_ide" "eou_ide-$foldername"

        echo -e Archiving existing eou_ide folder ["eou_ide"] into backup folder ["eou_ide-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/n6il/eou_ide
git clone https://github.com/n6il/eou_ide.git

pyenv local 2.7.18

# check for existing of NitrOS9 EOU HDD files
if [ -f /media/share1/EMU/EOU/63SDC.VHD ]
then
    echo EOU HDD files exist.
    echo

else
    echo EOU HDD files do not exist.  Please select
    echo Download Latest NitrOS9 EOU Image from Download Utilities Menu
    echo prior to using this script.
    echo

    echo -e
    read -p "Press any key to continue... " -n1 -s
    exit

fi


echo Creating EOU IDE based HDD image file...
cd $HOME/source/eou_ide

cp /media/share1/EMU/EOU/63SDC.VHD ./

# build disk images for MAME
python ./makebootfileide.py --cpu 6309 --vhd $HOME/source/eou_ide/63SDC.VHD --emulator mame
python ./makebootfileide.py --cpu 6309 --vhd $HOME/source/eou_ide/63SDC.VHD --emulator mame --dw becker


# build disk images for XRoar
python ./makebootfileide.py --cpu 6309 --vhd $HOME/source/eou_ide/63SDC.VHD --emulator xroar
python ./makebootfileide.py --cpu 6309 --vhd $HOME/source/eou_ide/63SDC.VHD --emulator xroar --dw becker

# verify disk images were created for MAME
if [ -f $HOME/source/eou_ide/build/6309_ide_mame/63IDE.dsk ]
then
	echo
	echo EOU IDE HDD image created successfully for use with MAME.
	echo
	echo
else
	echo
	echo EOU IDE HDD image NOT created for use with MAME.  Aborting.
	echo
	echo
fi


if [ -f $HOME/source/eou_ide/build/6309_ide_xroar/63IDE.dsk ]
then
	echo
	echo EOU IDE HDD image created successfully for use with XRoar.
	echo
	echo
else
	echo
	echo EOU IDE HDD image NOT created for use with XRoar.  Aborting.
	echo
	echo
fi


cd $HOME/.mame

echo -e
echo -e
read -p "Press any key to continue... " -n1 -s
echo -e
