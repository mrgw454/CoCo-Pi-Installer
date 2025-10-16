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

if [ -f scripts2.tar.gz ]; then
        rm scripts2.tar.gz
fi

if [ -f source.tar.gz ]; then
	rm source.tar.gz
fi

if [ -f source-other.tar.gz ]; then
	rm source-other.tar.gz
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

tar czvf $stagingfolder/Desktop.tar.gz Desktop/Emulators/CoCoSC* Desktop/Emulators/ddd* Desktop/Emulators/DOSBox* Desktop/Emulators/DragonPy* \
Desktop/Emulators/DriveWire4* Desktop/Emulators/F256Jr* Desktop/Emulators/Flexemu* Desktop/Emulators/HxC* Desktop/Emulators/MAME* \
Desktop/Emulators/MC-10* Desktop/Emulators/NoICE* Desktop/Emulators/Online* Desktop/Emulators/OVCC* Desktop/Emulators/pyDriveWire* \
Desktop/Emulators/RunCPM* Desktop/Emulators/Rusty* Desktop/Emulators/seergdb* Desktop/Emulators/trs80gp* Desktop/Emulators/VCC* \
Desktop/Emulators/VMC* Desktop/Emulators/XRoar* \
Desktop/Emulators\ \(Online\)/cocobot* Desktop/Emulators\ \(Online\)/Flex* Desktop/Emulators\ \(Online\)/Get* \
Desktop/Emulators\ \(Online\)/*Color* Desktop/Emulators\ \(Online\)/*Dragon* Desktop/Emulators\ \(Online\)/MC-10* \
Desktop/Emulators\ \(Online\)/*Motorola* Desktop/Emulators\ \(Online\)/ugBASIC* Desktop/Emulators\ \(Online\)/XRoar* \
Desktop/Retro\ Computer\ Forums\ \&\ News/*worldofdragon* Desktop/Retro\ Computer\ Forums\ \&\ News/ColorComputer* \
Desktop/Retro\ Computer\ Forums\ \&\ News/MAME* Desktop/Retro\ Computer\ Forums\ \&\ News/MC-10* \
Desktop/Retro\ Computer\ Forums\ \&\ News/*CoCo* Desktop/Retro\ Computer\ Forums\ \&\ News/*CoCo-Pi* \
Desktop/Retro\ Computer\ Forums\ \&\ News/*Trash* Desktop/Retro\ Computer\ Forums\ \&\ News/Vintage*

tar czvf $stagingfolder/Pictures.tar.gz Pictures/*CoCo* Pictures/*coco* Pictures/*Coco* Pictures/*rduino* Pictures/BASIC* \
Pictures/CM* Pictures/DOS* Pictures/dos* Pictures/Dragon* Pictures/dw4* Pictures/flexemu* \
Pictures/Fuji* Pictures/fuji* Pictures/HxC* Pictures/irata* Pictures/MAME* Pictures/MC-10* \
Pictures/mc-10* Pictures/Monitor* Pictures/MPI* Pictures/NoICE* Pictures/online6809* Pictures/OVCC* \
Pictures/PuTTY* Pictures/pyD* Pictures/Realistic* Pictures/Tandy* Pictures/trs80gp* Pictures/VCC* Pictures/XRoar* \
Pictures/seergdb* Pictures/F256Jr* Pictures/RunCPM*

tar czvf $stagingfolder/scripts.tar.gz scripts
tar czvf $stagingfolder/scripts2.tar.gz scripts2
tar czvf $stagingfolder/source.tar.gz source/new_windows.zip source/*.sh source/useroptions.mak ovcc-patch-package-cc936b2.tar.gz
tar czvf $stagingfolder/source-other.tar.gz source-other/*.sh
tar czvf $stagingfolder/fonts.tar.gz .fonts
tar czvf $stagingfolder/misc-home-files.tar.gz .vim .wgetrc .irssi .config/geany/geany.conf .config/geany/filedefs


find .mame \( -type f -o -type d \) \
    ! -name '*adam*' \
    ! -name '*Adam*' \
    ! -name '*alice*' \
    ! -name '*apple*' \
    ! -name '*Apple*' \
    ! -name '*aquarius*' \
    ! -name '*AQUARIUS*' \
    ! -name '*tari*' \
    ! -name '*msx*' \
    ! -name '*nabu*' \
    ! -name '*NABU*' \
    ! -name '*99*' \
    ! -name '*trs80*' \
    ! -name '*68000*' \
    ! -name '*c64*' \
    ! -name '*c128*' \
    ! -name '*Commodore*' \
    | tar -czvf "$stagingfolder/mame-menus.tar.gz" --no-recursion -T -


tar czvf $stagingfolder/xroar-menus.tar.gz .xroar
tar czvf $stagingfolder/ovcc-menus.tar.gz .ovcc/*.rom .ovcc/*.sh .ovcc/*.ini .ovcc/ini/*
tar czvf $stagingfolder/trs80gp-menus.tar.gz .trs80gp

tar czvf $stagingfolder/pyDriveWire-files.tar.gz pyDriveWire/config/pydrivewirerc-daemon pyDriveWire/*.sh
tar czvf $stagingfolder/DriveWire-files.tar.gz DriveWire4/*.sh DriveWire4/config.xml
tar czvf $stagingfolder/lwwire-files.tar.gz lwwire/*.sh lwwire/serserv lwwire/tcpserv
tar czvf $stagingfolder/tcpser-files.tar.gz tcpser/start_tcpser.sh tcpser/stop_tcpser.sh


cd $stagingfolder

userid=$(whoami)
if [ ! -d /media/share1 ]; then
	sudo mkdir -p /media/share1
	sudo chown $userid:$userid
fi

tar czvf $stagingfolder/media-share1.tar.gz /media/share1/carts /media/share1/software/coco* \
/media/share1/software/dragon* /media/share1/software/mc10* /media/share1/samples/floppy /media/share1/source/ASM \
/media/share1/source/BASIC /media/share1/source/BASIC09  /media/share1/source/C /media/share1/source/ugBasic \
/media/share1/source/MC-10 /media/share1/HDBDOS

tar czvf $stagingfolder/misc-system-files.tar.gz /etc/samba/smb.conf

# capture .bashrc modifications for CoCo-Pi
grep -A500 -m1 -e 'modifications' $HOME/.bashrc > ./bashrc-cocopi.txt


if [ -f $HOME/cocopi-release.txt ]; then
	cp $HOME/cocopi-release.txt ./
fi

echo
echo
echo Done!
echo

