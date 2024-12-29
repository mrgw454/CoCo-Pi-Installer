clear

MAMEPARMSFILE=`cat $HOME/.mame/.optional_mame_parameters.txt`
export MAMEPARMS=$MAMEPARMSFILE

cd $HOME/.mame

# IDE HDD method
mame coco3h -ramsize 2048k -ext fdc,bios=hdbk3 -flop1 /media/share1/EMU/GORDON/FUZIX/fuzix.dsk -hard1 /media/share1/EMU/GORDON/FUZIX/fuzixfs.dsk -autoboot_delay 2 -autoboot_command 'DRIVE OFF\nRUN"AUTOEXEC.BAS"\n' $MAMEPARMS

# capture MAME ERRORLEVEL

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
CoCoPi-menu-Coco3.sh
