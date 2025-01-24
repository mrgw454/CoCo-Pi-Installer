#!/bin/bash

cd $HOME/source

if [ -z "$1" ]; then

	echo "No arguments provided.  Defaulting to build from git repository."
	echo

	# if a previous xroar-git folder exists, move into a date-time named folder

	if [ -d "xroar-git" ]; then

        	foldername=$(date +%Y-%m-%d_%H.%M.%S)

        	mv "xroar-git" "xroar-git-$foldername"

        	echo -e Archiving existing xroar-git folder ["xroar-git"] into backup folder ["xroar-git-$foldername"]
        	echo -e
        	echo -e
	fi

	# https://www.6809.org.uk/xroar/
	git clone https://www.6809.org.uk/git/xroar.git xroar-git

	cd xroar-git

	git checkout dev

	GITREV=`git rev-parse --short HEAD`

	echo
	git log -1
	echo

	./autogen.sh
	./configure --enable-experimental

	echo $(nproc) / 2 | bc
	cores=$(echo $(nproc) / 2 | bc)
	make -j$cores

	if [ -f src/xroar ]; then
        	echo sudo cp src/xroar /usr/local/bin/xroar-git-$GITREV
		echo
        	sudo cp src/xroar /usr/local/bin/xroar-git-$GITREV

		if [ -f /media/share1/roms/deluxecoco.zip ]; then
			unzip -o /media/share1/roms/deluxecoco.zip -d /media/share1/roms
			cat /media/share1/roms/adv070_u24.rom /media/share1/roms/adv071_u24.rom > /media/share1/roms/deluxe_extbas.rom
			cat /media/share1/roms/adv072_u24.rom /media/share1/roms/adv073-2_u24.rom > /media/share1/roms/deluxe_altbas.rom
			echo deluxecoco.zip archive found.  Creating Deluxe CoCo rom files for XRoar.
			echo
		else
			echo deluxecoco.zip archive not found.  Unable to create Deluxe CoCo rom files for XRoar.  Skipping.
			echo
		fi
	else
        	echo xroar binary not found!
        	echo
	fi

else

	echo $1 argument passed.  Looking for XRoar-$1...
	echo

	if [ ! -f xroar-$1.tar.gz ]; then
		wget https://www.6809.org.uk/xroar/dl/xroar-$1.tar.gz
	fi

	if [ ! -f xroar-$1.tar.gz ]; then
		echo xroar-$1.tar.gz archive file NOT found.  Aborting installation.
		echo
		exit
	fi

	tar zxvf xroar-$1.tar.gz
	cd xroar-$1

	./autogen.sh
	./configure

	echo $(nproc) / 2 | bc
	cores=$(echo $(nproc) / 2 | bc)
	make -j$cores

	if [ -f src/xroar ]; then
		echo sudo cp src/xroar /usr/local/bin/xroar-$1
		echo
		sudo cp src/xroar /usr/local/bin/xroar-$1
	else
	echo xroar binary not found!
	echo
	fi


fi


echo
echo Done!

