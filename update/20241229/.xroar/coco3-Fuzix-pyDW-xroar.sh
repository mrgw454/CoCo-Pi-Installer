clear

cd $HOME/.xroar

XROARPARMSFILE=`cat $HOME/.xroar/.optional_xroar_parameters.txt`
export XROARPARMS=$XROARPARMSFILE

clear

cd $HOME/pyDriveWire

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw server hdbdos 0

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0
$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 1

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk insert 0 /media/share1/DW4/GORDON/FUZIX/fuzix.dsk
$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk insert 1 /media/share1/DW4/GORDON/FUZIX/fuzixfs.dsk

cd $HOME/.xroar

# hdbdos method
xroar -c $HOME/.xroar/xroar.conf -default-machine coco3h -ram 2048K -machine-cpu 6309 -machine-cart becker -type '2' $XROARPARM


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

cd $HOME/pyDriveWire
$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0
$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 1

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw server hdbdos 1

cd $HOME/.mame
CoCoPi-menu-Coco3-XRoar.sh
