#!/bin/bash

# install prerequsities
sudo apt -y install byacc

cd $HOME/source

if [ ! -d $HOME/source/FUZIX-coco3 ]; then
	echo
	echo "FUZIX source code repository/folder does not exist.  Aborting."
	echo
	exit 1
fi

# if a previous fip-FUZIX folder exists, move into a date-time named folder

if [ -d "fip-FUZIX" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "fip-FUZIX" "fip-FUZIX-$foldername"

        echo -e Archiving existing fip-FUZIX folder ["fip-FUZIX"] into backup folder ["fip-FUZIX-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/beretta42/fip
git clone https://github.com/beretta42/fip.git fip-FUZIX
cd fip-FUZIX

git pull

# perform some fixes

# search for string and replace
sed -i 's/REL = 0.3pre1/REL = 0.5/' $HOME/source/fip-FUZIX/Makefile
if [ $? -eq 0 ]
then
  echo "Successfully modified $HOME/source/fip-FUZIX/Makefile"
else
  echo "Failure to modifiy $HOME/source/fip-FUZIX/Makefile" >&2
  echo
  exit 1
fi


# search for string and add a new line below prefixed with a tab
sed -i '/\/Standalone\/filesystem-src/ a \\texport TARGET=coco3; \\' $HOME/source/fip-FUZIX/Makefile
if [ $? -eq 0 ]
then
  echo "Successfully modified $HOME/source/fip-FUZIX/Makefile"
else
  echo "Failure to modifiy $HOME/source/fip-FUZIX/Makefile" >&2
  echo
  exit 1
fi


# search for string and replace
#sed -i 's/FUZIX_DIR = \/home\/beretta\/C\/FUZIX/FUZIX_DIR = \/home\/ron\/source\/fip-FUZIX/' $HOME/source/fip-FUZIX/config.mk
sed -i 's|FUZIX_DIR = /home/beretta/C/FUZIX|FUZIX_DIR = $(HOME)/source/FUZIX-coco3|' $HOME/source/fip-FUZIX/config.mk
if [ $? -eq 0 ]
then
  echo "Successfully modified $HOME/source/fip-FUZIX/config.mk"
else
  echo "Failure to modifiy $HOME/source/fip-FUZIX/config.mk" >&2
  echo
  exit 1
fi


# search for string and replace in 2 occurances
sed -i 's|Kernel\/platform-coco3|Kernel\/platform\/platform-coco3|' $HOME/source/fip-FUZIX/boot/Makefile
if [ $? -eq 0 ]
then
  echo "Successfully modified $HOME/source/fip-FUZIX/boot/Makefile"
else
  echo "Failure to modifiy $HOME/source/fip-FUZIX/boot/Makefile" >&2
  echo
  exit 1
fi


# remove 2 lines
sed -i '/bget fuzix-real.bin/d' $HOME/source/fip-FUZIX/boot/install.ucp
sed -i '/bget fuzix-fpga.bin/d' $HOME/source/fip-FUZIX/boot/install.ucp
sed -i '/bget fuzix-nano.bin/d' $HOME/source/fip-FUZIX/boot/install.ucp


# delete multiple lines starting at a specific line
sed -i "13,+8d" $HOME/source/fip-FUZIX/boot/Makefile


# copy required ROM files over prior to building Fuzix
if [ ! -d "$HOME/source/fip-FUZIX/cbe/roms" ]; then
	echo "$HOME/source/fip-FUZIX/cbe/roms" folder does not exist.  Creating.
	mkdir -p "$HOME/source/fip-FUZIX/cbe/roms"
	echo
fi


if [ -f "$HOME/source/toolshed-code/cocoroms/bas13.rom" ]; then
	cp $HOME/source/toolshed-code/cocoroms/bas13.rom $HOME/source/fip-FUZIX/cbe/roms/basic.rom
else
	echo
	echo "$HOME/source/toolshed-code/cocoroms/bas13.rom" does not exist.  Aborting.
	echo
	exit 1
fi


if [ -f "$HOME/source/toolshed-code/cocoroms/disk11.rom" ]; then
	cp $HOME/source/toolshed-code/cocoroms/disk11.rom $HOME/source/fip-FUZIX/cbe/roms/disk.rom
else
	echo
	echo "$HOME/source/toolshed-code/cocoroms/disk11.rom" does not exist.  Aborting.
	echo
	exit 1
fi


if [ -f "$HOME/source/toolshed-code/cocoroms/extbas11.rom" ]; then
	cp $HOME/source/toolshed-code/cocoroms/extbas11.rom $HOME/source/fip-FUZIX/cbe/roms/ecb.rom
else
	echo
	echo "$HOME/source/toolshed-code/cocoroms/extbas11.rom" does not exist.  Aborting.
	echo
	exit 1
fi


echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)
#make -j$cores
make

# if disk images exist, copy them to appropriate folder
if [ -f "$HOME/source/FUZIX-coco3/Standalone/filesystem-src/fuzixfs.dsk" ]; then
	cp $HOME/source/FUZIX-coco3/Standalone/filesystem-src/fuzixfs.dsk  /media/share1/DW4/GORDON/FUZIX
	cp $HOME/source/FUZIX-coco3/Standalone/filesystem-src/fuzixfs.dsk  /media/share1/SDC/GORDON/FUZIX
else
	echo
	echo "$HOME/source/FUZIX-coco3/Standalone/filesystem-src/fuzixfs.dsk" does not exist.  Aborting.
	echo
	exit 1
fi


if [ -f "$HOME/source/fip-FUZIX/boot/boot.dsk" ]; then
	cp $HOME/source/fip-FUZIX/boot/boot.dsk  /media/share1/DW4/GORDON/FUZIX
	cp $HOME/source/fip-FUZIX/boot/boot.dsk  /media/share1/SDC/GORDON/FUZIX
else
        echo
        echo "$HOME/source/fip-FUZIX/boot/boot.dsk" does not exist.  Aborting.
        echo
        exit 1
fi


if [ -f "$HOME/source/fip-FUZIX/boot/boot2.dsk" ]; then
	cp $HOME/source/fip-FUZIX/boot/boot2.dsk  /media/share1/DW4/GORDON/FUZIX
	cp $HOME/source/fip-FUZIX/boot/boot2.dsk  /media/share1/SDC/GORDON/FUZIX
else
        echo
        echo "$HOME/source/fip-FUZIX/boot/boot2.dsk" does not exist.  Aborting.
        echo
        exit 1
fi


cp $HOME/source/fip-FUZIX/README.dist /media/share1/DW4/GORDON/FUZIX
cp $HOME/source/fip-FUZIX/README.dist /media/share1/SDC/GORDON/FUZIX


echo
echo Done!
