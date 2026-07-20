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

if [ -f mame.tar.gz ]; then
	rm mame.tar.gz
fi

if [ -f xroar.tar.gz ]; then
	rm xroar.tar.gz
fi

if [ -f ovcc.tar.gz ]; then
	rm ovcc.tar.gz
fi

if [ -f trs80gp.tar.gz ]; then
	rm trs80gp.tar.gz
fi

if [ -f pyDriveWire-files.tar.gz ]; then
	rm pyDriveWire-files.tar.gz
fi

if [ -f DriveWire-files.tar.gz ]; then
	rm DriveWire-files.tar.gz
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

{
	find "Desktop/Emulators (Online)" -maxdepth 1 -type f \
		\( -name 'cocobot*' -o -name 'Flex*' -o -name 'Get*' -o -name '*Color*' \
		-o -name '*Dragon*' -o -name 'MC-10*' -o -name '*Motorola*' \
		-o -name 'ugBASIC*' -o -name 'XRoar*' \)
	find "Desktop/Retro Computer Forums & News" -maxdepth 1 -type f \
		\( -name '*worldofdragon*' -o -name 'ColorComputer*' -o -name 'MAME*' \
		-o -name 'MC-10*' -o -name '*CoCo*' -o -name '*CoCo-Pi*' \
		-o -name '*Trash*' -o -name 'Vintage*' \)
	find Desktop -maxdepth 1 -type f -name 'CoCo*'
} | sort -u | tar -czvf "$stagingfolder/Desktop.tar.gz" \
	--verbatim-files-from --no-recursion -T -

tar czvf $stagingfolder/Pictures.tar.gz Pictures/*CoCo* Pictures/*coco* Pictures/*Coco* Pictures/*rduino* Pictures/BASIC* \
Pictures/CM* Pictures/DOS* Pictures/dos* Pictures/Dragon* Pictures/dw4* Pictures/flexemu* \
Pictures/Fuji* Pictures/fuji* Pictures/HxC* Pictures/irata* Pictures/MAME* Pictures/MC-10* \
Pictures/mc-10* Pictures/Monitor* Pictures/MPI* Pictures/NoICE* Pictures/online6809* Pictures/OVCC* \
Pictures/PuTTY* Pictures/pyD* Pictures/Realistic* Pictures/Tandy* Pictures/trs80gp* Pictures/VCC* Pictures/XRoar* \
Pictures/seergdb* Pictures/F256Jr* Pictures/RunCPM*

#tar czvf $stagingfolder/scripts.tar.gz scripts
find scripts \( -type f -o -type d \) \
    ! -iname '*.ps1' \
    ! -iname '*.pyc' \
    ! -iname '*.bak' \
    ! -iname '*.backup' \
    ! -iname '*altirra*' \
    ! -iname '*apple*' \
    ! -iname '*atari*' \
    ! -iname '*msx*' \
    ! -iname '*99*' \
    ! -iname '*trs80[^g]*' \
    ! -path '*/.claude' \
    ! -path '*/.claude/*' \
    ! -path '*/.agents' \
    ! -path '*/.agents/*' \
    ! -path '*/.codex' \
    ! -path '*/.codex/*' \
    ! -path '*/.git' \
    ! -path '*/.git/*' \
    ! -path '*/__pycache__' \
    ! -path '*/__pycache__/*' \
    ! -path '*/.pytest_cache' \
    ! -path '*/.pytest_cache/*' \
    | tar -czvf "$stagingfolder/scripts.tar.gz" --no-recursion -T -

tar czvf $stagingfolder/source.tar.gz \
    --exclude='source/pdd.sh' \
    source/new_windows.zip \
    source/*.sh \
    source/useroptions.mak \
    source/ovcc-patch-package-cc936b2.tar.gz \
    source/coco3-jaggies-patches.zip

tar czvf $stagingfolder/fonts.tar.gz .fonts/HotCoCo*.* .fonts/AnotherMansTreasure*.* .fonts/PixelTandysoft*.* .fonts/*Tandy1K*.*

tar czvf $stagingfolder/misc-home-files.tar.gz .vim .wgetrc .irssi .config/Code/User/tasks.json

find .mame \( -type f -o -type d \) \
    ! -path '.mame/Nvram' \
    ! -path '.mame/Nvram/*' \
    ! -path '.mame/snap' \
    ! -path '.mame/snap/*' \
    ! -path '.mame/history/*' \
    ! -path '.mame/ui/*' \
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
    ! -iname 'plugin.ini' \
    ! -iname 'ui.ini' \
    ! -iname '*.backup' \
    -o -path '.mame/cfg/coco*' \
    -o -path '.mame/cfg/dragon*' \
    -o -path '.mame/cfg/mc10*' \
    -o -path '.mame/cfg/cp400*' \
    -o -path '.mame/cfg/agvision*' \
    -o -path '.mame/cfg/trsvidtx*' \
    -o -path '.mame/cfg/d64*' \
    -o -path '.mame/cfg/mcx*' \
    | sort -u \
    | tar -czvf "$stagingfolder/mame.tar.gz" --no-recursion -T -


tar czvf $stagingfolder/xroar.tar.gz .xroar
tar czvf $stagingfolder/ovcc.tar.gz .ovcc/*.rom .ovcc/*.sh .ovcc/*.ini .ovcc/ini/*
tar czvf $stagingfolder/trs80gp.tar.gz .trs80gp

tar czvf $stagingfolder/pyDriveWire-files.tar.gz pyDriveWire/config/pydrivewirerc-daemon pyDriveWire/*.sh pyDriveWire/pyDwCli*.* pyDriveWire/pyDwCli
tar czvf $stagingfolder/DriveWire-files.tar.gz DriveWire4/*.sh DriveWire4/config.xml
tar czvf $stagingfolder/tcpser-files.tar.gz tcpser/start_tcpser.sh tcpser/stop_tcpser.sh


cd $stagingfolder

userid=$(whoami)
if [ ! -d /media/share1 ]; then
	sudo mkdir -p /media/share1
	sudo chown $userid:$userid
fi

tar czvf $stagingfolder/media-share1.tar.gz \
    --exclude='/media/share1/source/*/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9].[0-9][0-9].[0-9][0-9]' \
    --exclude='*/.claude' \
    --exclude='*/.claude/*' \
    --exclude='*/CCGOTCHI/*' \
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
