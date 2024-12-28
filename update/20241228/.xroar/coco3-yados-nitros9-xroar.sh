clear

cd $HOME/.xroar

XROARPARMSFILE=`cat $HOME/.xroar/.optional_xroar_parameters.txt`
export XROARPARMS=$XROARPARMSFILE

clear

cd $HOME/.xroar

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw server hdbdos false

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0
$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk insert 0 $HOME/source/eou_ide/build/6309_ide_xroar/63IDE.dsk

xroar -c $HOME/.xroar/xroar.conf -default-machine coco3h -ram 2048K -machine-cpu 6309 -tv-input rgb -machine-cart ide -load-hd0 $HOME/source/eou_ide/build/6309_ide_xroar/63IDE.ide -load-hd1 /media/share1/EMU/EOU/EOU_USER.VHD -type '\r\DOS\r' -v 2 $XROARPARMS

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw server hdbdos true

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
exit
