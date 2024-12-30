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

echo
echo enabling bogomips utility to be built and added to filesystem...
echo

# add this line - this allows bogomips to be added to filesystem
sed -i '/\/bin\/banner/a f 0755 \/bin\/bogomips    bogomips' /home/ron/source/FUZIX-coco3/Applications/util/fuzix-util.pkg

# add Brett Gordon's decb user space application
if [ -d $HOME/source/fip-FUZIX/decb ]; then
	decb="true"
        echo
        echo found fip-FUZIX installer.
        echo decb folder exists.  Copying over to Applications...
        echo
        cp -r $HOME/source/fip-FUZIX/decb $HOME/source/FUZIX-coco3/Applications
	cp $HOME/source/fip-FUZIX/config.mk $HOME/source/FUZIX-coco3/Applications
        echo

        # add entry for decb so it gets built
        sed -i '/all:/a \\ndecb:\n\t+(cd decb; $(MAKE) -f Makefile.$(USERCPU)' /home/ron/source/FUZIX-coco3/Applications/Makefile
fi

# add Brett Gordon's cbe user space application
if [ -d $HOME/source/fip-FUZIX/cbe ]; then
	cbe="true"
	echo
        echo found fip-FUZIX installer.
	echo cbe folder exists.  Copying over to Applications...
	echo
	cp -r $HOME/source/fip-FUZIX/cbe $HOME/source/FUZIX-coco3/Applications
	cp $HOME/source/fip-FUZIX/config.mk $HOME/source/FUZIX-coco3/Applications
	echo

	# add entry for cbe so it gets built
	sed -i '/all:/a \\ncbe:\n\t+(cd cbe; $(MAKE) -f Makefile.$(USERCPU)' /home/ron/source/FUZIX-coco3/Applications/Makefile
fi


# update inittab to add extra terminal tty
sed -i 's|02:3:off:getty /dev/tty2|02:3:respawn:getty /dev/tty2|' $HOME/source/FUZIX-coco3/Standalone/filesystem-src/etc-files/inittab

# update motd with additional information
sed -i "/Welcome to FUZIX./a git rev $GITREV\n" $HOME/source/FUZIX-coco3/Standalone/filesystem-src/etc-files/motd

echo -e "Use [CTRL]-1 and [CTRL]-2 to toggle between consoles" >> $HOME/source/FUZIX-coco3/Standalone/filesystem-src/etc-files/motd
echo >> $HOME/source/FUZIX-coco3/Standalone/filesystem-src/etc-files/motd

echo -e "Use 'mode -s 0' to enable 80 column mode" >> $HOME/source/FUZIX-coco3/Standalone/filesystem-src/etc-files/motd
echo >> $HOME/source/FUZIX-coco3/Standalone/filesystem-src/etc-files/motd

if [ $cbe == "true" ]; then
	echo -e "Run 'cbe' to launch DECB as a user-space application" >> $HOME/source/FUZIX-coco3/Standalone/filesystem-src/etc-files/motd
	echo >> $HOME/source/FUZIX-coco3/Standalone/filesystem-src/etc-files/motd
fi

echo -e "Use 'shutdown' (and wait for 'halted' message) to stop Fuzix" >> $HOME/source/FUZIX-coco3/Standalone/filesystem-src/etc-files/motd
echo >> $HOME/source/FUZIX-coco3/Standalone/filesystem-src/etc-files/motd


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

		if [ $cbe == "true" ]; then
			# add cbe to filesystem image
			cd $HOME/source/FUZIX-coco3/Applications
			make -C cbe -f Makefile.6809 cbe install
			cd $HOME/source/FUZIX-coco3/Standalone/filesystem-src

	               # add decb to filesystem image
        	        cd $HOME/source/FUZIX-coco3/Applications
                	make -C decb -f Makefile.6809 decb detoken install
	                cd $HOME/source/FUZIX-coco3/Standalone/filesystem-src
		fi

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

		if [ $cbe == "true" ]; then
	               # add cbe to filesystem image
        	        cd $HOME/source/FUZIX-coco3/Applications
               		make -C cbe -f Makefile.6809 cbe install
	                cd $HOME/source/FUZIX-coco3/Standalone/filesystem-src

        	       # add decb to filesystem image
                	cd $HOME/source/FUZIX-coco3/Applications
	                make -C decb -f Makefile.6809 decb detoken install
        	        cd $HOME/source/FUZIX-coco3/Standalone/filesystem-src
		fi

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
