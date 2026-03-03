#!/bin/bash

# if a previous CoCo-Pi-Installer-staging folder exists, move into a date-time named folder

if [ -d "CoCo-Pi-Installer-staging" ]; then

	foldername=$(date +%Y-%m-%d_%H.%M.%S)

	mv "CoCo-Pi-Installer-staging" "CoCo-Pi-Installer-staging-$foldername"

	echo -e Archiving existing CoCo-Pi-Installer-staging folder ["CoCo-Pi-Installer-staging"] into backup folder ["CoCo-Pi-Installer-staging-$foldername"]
	echo
	echo
fi


if [ ! -d CoCo-Pi-Installer-staging ]; then
	mkdir CoCo-Pi-Installer-staging
fi

cd CoCo-Pi-Installer-staging

stagingfolder=$(pwd)
echo
echo stagingfolder: $stagingfolder
echo


read -p "Press any key to continue... " -n1 -s

# remove previous files if they exist
if [ -f Desktop.tar.gz ]; then
	rm Desktop.tar.gz
fi

if [ -f Pictures.tar.gz ]; then
	rm Pictures.tar.gz
fi

if [ -f scripts.tar.gz ]; then
	rm scripts.tar.gz
fi

if [ -f source.tar.gz ]; then
	rm source.tar.gz
fi

if [ -f fonts.tar.gz ]; then
	rm fonts.tar.gz
fi

if [ -f misc-home-files.tar.gz ]; then
	rm misc-home-files.tar.gz
fi

if [ -f mame-menus.tar.gz ]; then
	rm mame-menus.tar.gz
fi

if [ -f xroar-menus.tar.gz ]; then
	rm xroar-menus.tar.gz
fi

if [ -f ovcc-menus.tar.gz ]; then
	rm ovcc-menus.tar.gz
fi

if [ -f trs80gp-menus.tar.gz ]; then
	rm trs80gp-menus.tar.gz
fi

if [ -f pyDriveWire-files.tar.gz ]; then
	rm pyDriveWire-files.tar.gz
fi

if [ -f DriveWire-files.tar.gz ]; then
	rm DriveWire-files.tar.gz
fi

if [ -f lwwire-files.tar.gz ]; then
	rm lwwire-files.tar.gz
fi

if [ -f tcpser-files.tar.gz ]; then
	rm tcpser-files.tar.gz
fi

if [ -f media-share1.tar.gz ]; then
	rm media-share1.tar.gz
fi

if [ -f misc-system-files.tar.gz ]; then
	rm misc-system-files.tar.gz
fi


# create new files
cd $HOME

tar czvf $stagingfolder/Desktop.tar.gz Desktop/Emulators\ \(Online\)/cocobot* Desktop/Emulators\ \(Online\)/Flex* Desktop/Emulators\ \(Online\)/Get* \
Desktop/Emulators\ \(Online\)/*Color* Desktop/Emulators\ \(Online\)/*Dragon* Desktop/Emulators\ \(Online\)/MC-10* \
Desktop/Emulators\ \(Online\)/*Motorola* Desktop/Emulators\ \(Online\)/ugBASIC* Desktop/Emulators\ \(Online\)/XRoar* \
Desktop/Retro\ Computer\ Forums\ \&\ News/*worldofdragon* Desktop/Retro\ Computer\ Forums\ \&\ News/ColorComputer* \
Desktop/Retro\ Computer\ Forums\ \&\ News/MAME* Desktop/Retro\ Computer\ Forums\ \&\ News/MC-10* \
Desktop/Retro\ Computer\ Forums\ \&\ News/*CoCo* Desktop/Retro\ Computer\ Forums\ \&\ News/*CoCo-Pi* \
Desktop/Retro\ Computer\ Forums\ \&\ News/*Trash* Desktop/Retro\ Computer\ Forums\ \&\ News/Vintage* \
Desktop/CoCo*

tar czvf $stagingfolder/Pictures.tar.gz Pictures/*CoCo* Pictures/*coco* Pictures/*Coco* Pictures/*rduino* Pictures/BASIC* \
Pictures/CM* Pictures/DOS* Pictures/dos* Pictures/Dragon* Pictures/dw4* Pictures/flexemu* \
Pictures/Fuji* Pictures/fuji* Pictures/HxC* Pictures/irata* Pictures/MAME* Pictures/MC-10* \
Pictures/mc-10* Pictures/Monitor* Pictures/MPI* Pictures/NoICE* Pictures/online6809* Pictures/OVCC* \
Pictures/PuTTY* Pictures/pyD* Pictures/Realistic* Pictures/Tandy* Pictures/trs80gp* Pictures/VCC* Pictures/XRoar* \
Pictures/seergdb* Pictures/F256Jr* Pictures/RunCPM*

#tar czvf $stagingfolder/scripts.tar.gz scripts
find scripts \( -type f -o -type d \) \
    ! -iname '*adam*' \
    ! -iname '*alice*' \
    ! -iname '*altirra*' \
    ! -iname '*apple*' \
    ! -iname '*aquarius*' \
    ! -iname '*atari*' \
    ! -iname '*msx*' \
    ! -iname '*nabu*' \
    ! -iname '*99*' \
    ! -iname '*trs80*' \
    ! -iname '*68000*' \
    ! -iname '*c64*' \
    ! -iname '*c128*' \
    ! -iname '*commodore*' \
    ! -iname '*coleco*' \
    ! -name 'recursive-convert-2mg-to-PO.sh' \
    ! -name 'recursive-convert-DSK-to-PO.sh' \
    ! -name 'recursive-convert-WOZ-to-PO.sh' \
    ! -name 'recursive-copy-PO-and-HDV-and-DSK.sh' \
    ! -name 'recursive-copy-PO-and-HDV.sh' \
    ! -name 'recursive-verify-appleii-diskimages.sh' \
    | tar -czvf "$stagingfolder/scripts.tar.gz" --no-recursion -T -

tar czvf $stagingfolder/source.tar.gz \
    --exclude='source/pdd.sh' \
    source/new_windows.zip \
    source/*.sh \
    source/useroptions.mak \
    source/ovcc-patch-package-cc936b2.tar.gz \
    source/coco3-jaggies-patches.zip

tar czvf $stagingfolder/fonts.tar.gz .fonts
tar czvf $stagingfolder/misc-home-files.tar.gz .vim .wgetrc .irssi .config/Code/User/tasks.json


find .mame \( -type f -o -type d \) \
    ! -path '.mame/Nvram' \
    ! -path '.mame/Nvram/*' \
    ! -path '.mame/snap' \
    ! -path '.mame/snap/*' \
    ! -name '.optional_mame_parameters_*.txt' \
    ! -iname '*adam*' \
    ! -iname '*alice*' \
    ! -iname '*apple*' \
    ! -iname '*aquarius*' \
    ! -iname '*atari*' \
    ! -iname '*msx*' \
    ! -iname '*nabu*' \
    ! -iname '*99*' \
    ! -iname '*68000*' \
    ! -iname '*c64*' \
    ! -iname '*c128*' \
    ! -iname '*commodore*' \
    ! -iname '*coleco*' \
    -o -name 'CoCoPi-menu-*.sh' \
    -o -name 'CoCoPi-menu-Coco2-trs80gp.sh' \
    -o -name 'CoCoPi-menu-MC10-trs80gp.sh' \
    -o -path '.mame/cfg/coco*' \
    -o -path '.mame/cfg/dragon*' \
    -o -path '.mame/cfg/mc10*' \
    -o -path '.mame/cfg/cp400*' \
    -o -path '.mame/cfg/agvision*' \
    -o -path '.mame/cfg/trsvidtx*' \
    -o -path '.mame/cfg/d64*' \
    -o -path '.mame/cfg/mcx*' \
    | sort -u \
    | tar -czvf "$stagingfolder/mame-menus.tar.gz" --no-recursion -T -


tar czvf $stagingfolder/xroar-menus.tar.gz .xroar
tar czvf $stagingfolder/ovcc-menus.tar.gz .ovcc/*.rom .ovcc/*.sh .ovcc/*.ini .ovcc/ini/*
tar czvf $stagingfolder/trs80gp-menus.tar.gz .trs80gp

tar czvf $stagingfolder/pyDriveWire-files.tar.gz pyDriveWire/config/pydrivewirerc-daemon pyDriveWire/*.sh pyDriveWire/pyDwCli*.* pyDriveWire/pyDwCli
tar czvf $stagingfolder/DriveWire-files.tar.gz DriveWire4/*.sh DriveWire4/config.xml
tar czvf $stagingfolder/lwwire-files.tar.gz lwwire/*.sh lwwire/serserv lwwire/tcpserv
tar czvf $stagingfolder/tcpser-files.tar.gz tcpser/start_tcpser.sh tcpser/stop_tcpser.sh


cd $stagingfolder

userid=$(whoami)
if [ ! -d /media/share1 ]; then
	sudo mkdir -p /media/share1
	sudo chown $userid:$userid
fi


tar czvf $stagingfolder/media-share1.tar.gz \
    --exclude='/media/share1/source/*/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9].[0-9][0-9].[0-9][0-9]' \
    /media/share1/carts \
    /media/share1/software/coco* \
    /media/share1/software/dragon* \
    /media/share1/software/mc10* \
    /media/share1/samples/floppy \
    /media/share1/source/ASM \
    /media/share1/source/BASIC \
    /media/share1/source/BASIC09 \
    /media/share1/source/C \
    /media/share1/source/ugBasic \
    /media/share1/source/MC-10 \
    /media/share1/HDBDOS


tar czvf $stagingfolder/misc-system-files.tar.gz /etc/samba/smb.conf

# capture .bashrc modifications for CoCo-Pi
awk '
  /# START of CoCo-Pi modifications/ { in_coco=1; next }
  /# END of CoCo-Pi modifications/   { in_coco=0 }

  /# START of non-CoCo related environment variables/ { in_skip=1; next }
  /# END of non-CoCo related environment variables/   { in_skip=0; next }

  in_coco && !in_skip
' ~/.bashrc > ./bashrc-cocopi.txt


if [ -f $HOME/cocopi-release.txt ]; then
	cp $HOME/cocopi-release.txt ./
fi

echo
echo
echo Done!
echo
