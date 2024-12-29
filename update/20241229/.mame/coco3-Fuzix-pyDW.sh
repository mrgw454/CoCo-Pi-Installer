clear

MAMEPARMSFILE=`cat $HOME/.mame/.optional_mame_parameters.txt`
export MAMEPARMS=$MAMEPARMSFILE

cd $HOME/pyDriveWire

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw server hdbdos 0

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0
$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 1

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk insert 0 /media/share1/DW4/GORDON/FUZIX/fuzix.dsk
$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk insert 1 /media/share1/DW4/GORDON/FUZIX/fuzixfs.dsk

cd $HOME/.mame

if [ -e $HOME/.mame/.override_ini_files ]
then

    echo Using existing ini file.
    echo

else

    # enable Becker port
    cp $HOME/.mame/cfg/coco3.cfg.beckerport-enabled $HOME/.mame/cfg/coco3.cfg

fi

# hdbdos method
mame coco3 -ramsize 2048k -ext multi -ext:multi:slot4 fdc -cart5 /media/share1/roms/hdbdw3bc3.rom -autoboot_delay 2 -autoboot_command '2' $MAMEPARMS

# yados method
#mame coco3 -ramsize 2048k -cart /media/share1/roms/yados.rom -ext fdc -autoboot_delay 2 -autoboot_command '2' $MAMEPARMS


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

cd $HOME/pyDriveWire
$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0
$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 1

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw server hdbdos 1

cd $HOME/.mame
CoCoPi-menu-Coco3.sh
