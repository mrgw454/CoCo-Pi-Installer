clear

MAMEPARMSFILE=`cat $HOME/.mame/.optional_mame_parameters.txt`
export MAMEPARMS=$MAMEPARMSFILE

if [ -e $HOME/.mame/.override_ini_files ]
then

    echo Using existing ini file.
    echo

else

    # disable Becker port
    cp $HOME/.mame/cfg/coco3.cfg.beckerport-disabled $HOME/.mame/cfg/coco3.cfg

fi

if [ -e $HOME/.mame/.mame_floppy ]
then
    floppy=`cat $HOME/.mame/.mame_floppy`

    if [ -e "$floppy" ]
    then

        echo "Floppy save file found - automounting [$floppy]"
        echo
        read -p  "Press any key to continue." -n1 -s
        echo

	mame coco2b -ramsize 64k -ext multi -ext:multi:slot1 xsid -flop1 "$floppy" $MAMEPARMS

    else

	echo "Floppy disk image [$floppy] not found in floppy save file.  Aborting."
        echo
        echo "Please run \"Clear all saved mount files\" on Utilities Menu."
        echo
        read -p  "Press any key to continue." -n1 -s
        echo

    fi

else

mame coco2b -ramsize 64k -ext multi -ext:multi:slot1 xsid -flop1 "$1" $MAMEPARMS

fi

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
[ -n "$COCOPI_MENU_CALLER" ] && "$COCOPI_MENU_CALLER"
