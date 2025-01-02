clear

MAMEPARMSFILE=`cat $HOME/.mame/.optional_mame_parameters.txt`
export MAMEPARMS=$MAMEPARMSFILE

cd $HOME/.mame

# IDE HDD method
# type in HDA at the bootdev prompt to boot from hard drive image
mame coco3h -ramsize 2048k -ext ide -ext:ide:slot fdc -flop1 /media/share1/EMU/GORDON/FUZIX/fuzix.dsk -hard3 /media/share1/EMU/GORDON/FUZIX/fuzixfs.dsk -ext:ide:ata:1 hdd -autoboot_delay 2 -autoboot_command 'LOADM"BOOT.BIN":EXEC\n' $MAMEPARMS

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
