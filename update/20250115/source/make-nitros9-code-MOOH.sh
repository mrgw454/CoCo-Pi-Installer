#!/bin/bash

# install prerequisites
echo NOTE!  You need to make sure the following projects are already built and installed:
echo
echo  nitros9-code
echo  sdboot
echo
read -p "Press any key to continue... " -n1 -s
echo


if [ ! -d $HOME/source/nitros9-code ]; then
	echo
	echo nitros9-code project source folder does not exist.  Aborting.
	echo
	exit 1
fi

if [ -d $HOME/source/nitros9-code/level2/mooh ]; then
	echo
	echo mooh project folder exists.  Delete it or save it somewhere else and try again.
	echo Aborting.
	echo
	exit 1
fi

cd $HOME/source/nitros9-code

export NITROS9DIR=$PWD

cd $HOME/source/nitros9-code/level2

# git latest MOOH source:
# https://nitros9.sourceforge.io/mooh/
# https://gitlab.com/tormod/level2mooh/-/wikis/build
# https://gitlab.com/tormod/level2mooh/-/wikis/xroar
# http://tormod.me/mooh-sdcard.html
git clone https://gitlab.com/tormod/level2mooh.git mooh

cd mooh

# checkout correct branch:
git checkout vtio1
GITREV=`git rev-parse --short HEAD`

cd ../../..


echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)

# replace makefile with one adds DW support to CoCoVGA DSK image
# and add DW support to CO42 DSK image for emulator use
if [ ! -f $HOME/source/bootfiles-makefile.zip ]; then
	echo
	echo bootfiles-makefile.zip archive missing.  Aborting.
	echo
	exit 1
fi

unzip -o $HOME/source/bootfiles-makefile.zip -d $HOME/source/nitros9-code/level2/mooh/bootfiles

cd nitros9-code
export NITROS9DIR=$PWD
cd level2/mooh


#make -j$cores
make
if [ $? -eq 0 ]
then
	echo
	echo Compilation was successful
	echo
else
	echo
	echo Compilation was unsuccessful.  Aborting.
	echo
	exit 1
fi


#make -j$cores dsk
make dsk
if [ $? -eq 0 ]
then
	echo
	echo Creation of disk images was successful
	echo
else
	echo
	echo Creation of disk images was unsuccessful.  Aborting.
	echo
	exit 1
fi


#make -j$cores dskcopy
make dskcopy
if [ $? -eq 0 ]
then
	echo
	echo Copying of disk images was successful
	echo
else
	echo
	echo Copying of disk images was unsuccessful.  Aborting.
	echo
	exit 1
fi


make sdcard.img
if [ ! -f $HOME/source/nitros9-code/level2/mooh/sdcard.img ]; then
	echo
	echo sdcard.img file does not exist.  Aborting.
	echo
	exit 1
else
	echo
	mv $HOME/source/nitros9-code/level2/mooh/sdcard.img $HOME/source/nitros9-code/level2/mooh/sdcard-default.img
	echo
fi


make sdcard.img MOOHVTIO=_42
if [ ! -f $HOME/source/nitros9-code/level2/mooh/sdcard.img ]; then
        echo
        echo sdcard.img file does not exist.  Aborting.
        echo
        exit 1
else
        echo
        mv $HOME/source/nitros9-code/level2/mooh/sdcard.img $HOME/source/nitros9-code/level2/mooh/sdcard-vtio42.img
        echo
fi


make sdcard.img MOOHVTIO=_hr
if [ ! -f $HOME/source/nitros9-code/level2/mooh/sdcard.img ]; then
        echo
        echo sdcard.img file does not exist.  Aborting.
        echo
        exit 1
else
        echo
        mv $HOME/source/nitros9-code/level2/mooh/sdcard.img $HOME/source/nitros9-code/level2/mooh/sdcard-vtiohr.img
        echo
fi


make sdcard.img MOOHVTIO=_vga
if [ ! -f $HOME/source/nitros9-code/level2/mooh/sdcard.img ]; then
        echo
        echo sdcard.img file does not exist.  Aborting.
        echo
        exit 1
else
        echo
        mv $HOME/source/nitros9-code/level2/mooh/sdcard.img $HOME/source/nitros9-code/level2/mooh/sdcard-vtiovga.img
        echo
fi


make kernel_65spi.bin
if [ $? -eq 0 ]
then
        echo
        echo Compilation of SD card boot loader successful
        echo
else
        echo
        echo Compilation of SD boot loader unsuccessful.  Aborting.
        echo
        exit 1
fi


make kernel_becker.bin
if [ $? -eq 0 ]
then
        echo
        echo Compilation of Becker boot loader successful
        echo
else
        echo
        echo Compilation of Becker boot loader unsuccessful.  Aborting.
        echo
        exit 1
fi


# for MOOH emulation
dd if=/dev/zero of=sdcard-dualboot-DW-emulation.img count=65536 bs=1024
dd if=kernel_65spi.bin of=sdcard-dualboot-DW-emulation.img seek=64 conv=notrunc
dd if=NOS9_6809_L2_v030300_MOOH_sd65spi_42.dsk of=sdcard-dualboot-DW-emulation.img seek=512 conv=notrunc


# for real hardware
dd if=/dev/zero of=sdcard-dualboot-DW-realhardware.img count=65536 bs=1024
dd if=kernel_65spi.bin of=sdcard-dualboot-DW-realhardware.img seek=64 conv=notrunc
dd if=NOS9_6809_L2_v030300_MOOH_sd65spi_vga.dsk of=sdcard-dualboot-DW-realhardware.img seek=512 conv=notrunc


echo
echo Done!
