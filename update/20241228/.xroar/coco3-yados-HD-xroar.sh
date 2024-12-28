clear

cd $HOME/.xroar

XROARPARMSFILE=`cat $HOME/.xroar/.optional_xroar_parameters.txt`
export XROARPARMS=$XROARPARMSFILE

clear

cd $HOME/.xroar

# link to proper sdcard.img
    rm hd0.img
    ln -s /media/share1/EMU/VHD/hd0-XRoar-256MB.img hd0.img

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw server hdbdos false

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0
$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk insert 0 /media/share1/DW4/AUTOEXEC/AUTOEXEC.DSK
$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk insert 1 /media/share1/DW4/YADOS/yados.dsk

xroar -c $HOME/.xroar/xroar.conf -default-machine coco3 -machine-cart ide -load-hd0 $HOME/.xroar/hd0.img -type 'N\r\0DRIVE I 1,4,3\r\0DRIVE U 0\r\0DRIVE M 0,1,0,0,0\r\0DRIVE M 1,0,0\r\0DRIVE M 2,0,1\r\0DRIVE I:DRIVE M\r\0\0\0\0LOAD"WIDTH80.BAS:1"\r\0RUN\r' -v 2 $XROARPARMS

$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0
$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 1

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











