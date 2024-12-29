#!/bin/bash

# set some variables
SYSTEM=coco3

cd $HOME/source

# if a previous FUZIX-$SYSTEM folder exists, move into a date-time named folder

if [ -d "FUZIX-$SYSTEM" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "FUZIX-$SYSTEM" "FUZIX-$SYSTEM-$foldername"

        echo -e Archiving existing FUZIX-$SYSTEM folder ["FUZIX-$SYSTEM"] into backup folder ["FUZIX-$SYSTEM-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/EtchedPixels/FUZIX
git clone https://github.com/EtchedPixels/FUZIX.git FUZIX-$SYSTEM

cd $HOME/source/FUZIX-$SYSTEM

GITREV=`git rev-parse --short HEAD`

# add this line - this allows bogomips.c to be built
sed -i '/blkdiscard.c/a \\tbogomips.c \\' $HOME/source/FUZIX-coco3/Applications/util/Makefile.common

# add this line - this allows bogomips to be added to filesystem
sed -i '/\/bin\/banner/a f 0755 \/bin\/bogomips    bogomips' /home/ron/source/FUZIX-coco3/Applications/util/fuzix-util.pkg


echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)

# for real CoCo 3's
make -j$cores TARGET=coco3 SUBTARGET=real V=1

if [ $? -eq 0 ]
then
        echo "compilation was successful.  Installing."
        echo
	if [ ! -d /media/share1/SDC/GORDON/FUZIX ]; then
		mkdir -p /media/share1/SDC/GORDON/FUZIX
	fi

	# copy boot disk
	cp Kernel/platform/platform-coco3/fuzix.dsk /media/share1/SDC/GORDON/FUZIX

	# build filesystem image
	cd Standalone/filesystem-src
	export TARGET=coco3
	./build-filesystem -X fuzixfs.dsk 256 65535

	if [ ! -f fuzixfs.dsk ]; then
		echo "fuzix filesystem image does not exist.  Aborting."
		echo
		exit 1
	else
		echo "fuzix filesystem image exists."
		echo
		cp fuzixfs.dsk /media/share1/SDC/GORDON/FUZIX
	fi

else
        echo "compilation was NOT successful.  Aborting."
        echo
        exit 1
fi


cd $HOME/source/FUZIX-$SYSTEM
make clean

# for emulated CoCo 3's
make -j$cores TARGET=coco3 SUBTARGET=emu V=1

if [ $? -eq 0 ]
then
        echo "compilation was successful.  Installing."
        echo
        if [ ! -d /media/share1/EMU/GORDON/FUZIX ]; then
                mkdir -p /media/share1/EMU/GORDON/FUZIX
        fi

        if [ ! -d /media/share1/DW4/GORDON/FUZIX ]; then
                mkdir -p /media/share1/DW4/GORDON/FUZIX
        fi

        # copy boot disk
        cp Kernel/platform/platform-coco3/fuzix.dsk /media/share1/EMU/GORDON/FUZIX
        cp Kernel/platform/platform-coco3/fuzix.dsk /media/share1/DW4/GORDON/FUZIX

        # build filesystem image
        cd Standalone/filesystem-src
        export TARGET=coco3
        ./build-filesystem -X fuzixfs.dsk 256 65535

        if [ ! -f fuzixfs.dsk ]; then
                echo "fuzix filesystem image does not exist.  Aborting."
                echo
                exit 1
        else
                echo "fuzix filesystem image exists."
                echo
                cp fuzixfs.dsk /media/share1/EMU/GORDON/FUZIX
                cp fuzixfs.dsk /media/share1/DW4/GORDON/FUZIX
        fi

else
        echo "compilation was NOT successful.  Aborting."
        echo
        exit 1
fi


cd $HOME/source/FUZIX-$SYSTEM


echo
echo Done!
