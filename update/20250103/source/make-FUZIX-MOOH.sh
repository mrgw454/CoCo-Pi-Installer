#!/bin/bash

# install prerequisites
echo NOTE!  You need to make sure the following projects are already built and installed:
echo
echo sdboot
echo
echo
read -p "Press any key to continue... " -n1 -s
echo


cd $HOME/source

# if a previous FUZIX-MOOH folder exists, move into a date-time named folder

if [ -d "FUZIX-MOOH" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "FUZIX-MOOH" "FUZIX-MOOH-$foldername"

        echo -e Archiving existing FUZIX-MOOH folder ["FUZIX-MOOH"] into backup folder ["FUZIX-MOOH-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/EtchedPixels/FUZIX
git clone https://github.com/EtchedPixels/FUZIX.git FUZIX-MOOH

cd $HOME/source/FUZIX-MOOH

GITREV=`git rev-parse --short HEAD`

# add this line - this allows bogomips.c to be built
sed -i '/blkdiscard.c/a \\tbogomips.c \\' $HOME/source/FUZIX-MOOH/Applications/util/Makefile.common

echo
echo enabling bogomips utility to be built and added to filesystem...
echo

# add this line - this allows bogomips to be added to filesystem
sed -i '/\/bin\/banner/a f 0755 \/bin\/bogomips    bogomips' $HOME/source/FUZIX-MOOH/Applications/util/fuzix-util.pkg

# update inittab to add extra terminal tty
sed -i 's|02:3:off:getty /dev/tty2|02:3:respawn:getty /dev/tty2|' $HOME/source/FUZIX-MOOH/Standalone/filesystem-src/etc-files/inittab

# update motd with additional information
sed -i "/Welcome to FUZIX./a git rev $GITREV\n" $HOME/source/FUZIX-MOOH/Standalone/filesystem-src/etc-files/motd

echo -e "Use [CTRL]-1 and [CTRL]-2 to toggle between consoles" >> $HOME/source/FUZIX-MOOH/Standalone/filesystem-src/etc-files/motd
echo >> $HOME/source/FUZIX-MOOH/Standalone/filesystem-src/etc-files/motd

echo -e "Use 'shutdown' (and wait for 'halted' message) to stop Fuzix" >> $HOME/source/FUZIX-MOOH/Standalone/filesystem-src/etc-files/motd
echo >> $HOME/source/FUZIX-MOOH/Standalone/filesystem-src/etc-files/motd


# i did modify Kernel/platform/platform-dragon-mooh/config.h to set #define CMDLINE "HDA1" but that was just to save typing it at the prompt
#sed -i 's/NULL/"HDA1"/' $HOME/source/FUZIX-MOOH/Kernel/platform/platform-dragon-mooh/config.h
sed -i '/CMDLINE/s/NULL/"HDA1"/' $HOME/source/FUZIX-MOOH/Kernel/platform/platform-dragon-mooh/config.h

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)

# for real CoCo 2's
#make -j$cores TARGET=dragon-mooh SUBTARGET=real V=1

# for emulated CoCo 2's
make -j$cores TARGET=dragon-mooh SUBTARGET=emu V=1

if [ $? -eq 0 ]
then
        echo "compilation was successful."
        echo
else
        echo "compilation was NOT successful.  Aborting."
        echo
        exit 1
fi


make -j$cores TARGET=dragon-mooh SUBTARGET=emu diskimage V=1

if [ $? -eq 0 ]
then
        echo "building of SD card image was successful."
        echo
else
        echo "building of SD card image was NOT successful.  Aborting."
        echo
        exit 1
fi


cd $HOME/source/FUZIX-MOOH


echo
echo Done!
