#!/bin/bash

# script to create a new Coco floppy disk image and and copy all Coco related files to it.
# It will also (optionally) run MAME XRoar or trs80gp mount the disk image (pyDriveWire or normal DECB)

# this script can take up to 3 command line parameters:
# Emulator to use (i.e. mame, xroar or trs80gp) Coco driver to use for emulator (i.e. coco2 coco3, etc.) and use pyDriveWire (yes or no)

# syntax example:

# ./makeDSK mame coco2b y

# this will create a new disk image and copy all Coco compatible files to a disk image
# using name of the current folder.  In addition, it will launch MAME emulator using the Coco 2
# driver (with HDBDOS) and use pyDriveWire with this disk image mounted as DRIVE 0.
# If pyDriveWire is not running, the script will start it.

# Define function for displaying error codes from Toolshed's 'decb' command

functionErrorLevel() {

	if [ $? -eq 0 ]
	then

		echo -e "Successfully copied file to DSK image."
		echo -e

	else

		echo -e "Error during copy process to DSK image."
		echo -e
		read -p "Press any key to continue... " -n1 -s
		echo -e
		echo -e

	fi

}

# get name of script and place it into a variable
scriptname=`basename "$0"`

# get name of current folder and place it into a variable
floppy=`basename "$PWD"`

workdir=$(pwd)


# parse command line parameters for standard help options
if [[ $1 =~ --h|--help|-h ]];then

    echo -e
    echo -e "Example syntax:"
    echo -e
    echo -e "./$scriptname <emulator > <coco driver> <y>|<n>"
    echo -e
    exit 1

fi


# if a previous disk image exists, move into a date-time named folder
if [ -f "$floppy.DSK" ]; then

	foldername=$(date +%Y-%m-%d_%H.%M.%S)

	mkdir "$foldername"

	mv "$floppy.DSK" "$foldername"

	echo -e Archiving existing disk image ["$floppy.DSK"] into backup folder ["$foldername"]
	echo -e
	echo -e
fi

# create new DSK image based on current folder name
echo -e Creating new floppy disk image [$floppy.DSK]
echo -e

decb dskini "$floppy.DSK"

# ignore file extension case
shopt -s nocasematch

for f in *; do

	# Copy all BASIC files (and convert names to UPPERCASE) to DSK image
	if [[ $f == *.BAS ]]; then

		echo -e decb copy -0 -a -t -r "$f" "$floppy.DSK","${f^^}"
		decb copy -0 -a -t -r "$f" "$floppy.DSK","${f^^}"
		functionErrorLevel

	fi


	# Copy all BINARY files (and convert names to UPPERCASE) to DSK image
	if [[ $f == *.BIN ]]; then

		echo -e decb copy -2 -b -r "$f" "$floppy.DSK","${f^^}"
		decb copy -2 -b -r "$f" "$floppy.DSK","${f^^}"
		functionErrorLevel

	fi


	# Copy all TEXT files (and convert names to UPPERCASE) to DSK image
	if [[ $f == *.TXT ]]; then

		echo -e decb copy -3 -a -r "$f" "$floppy.DSK","${f^^}"
		decb copy -3 -a -r "$f" "$floppy.DSK","${f^^}"
		functionErrorLevel

	fi


	# Copy all DAT files (and convert names to UPPERCASE) to DSK image
	if [[ $f == *.DAT ]]; then

		echo -e decb copy -2 -b -r "$f" "$floppy.DSK","${f^^}"
		decb copy -2 -b -r "$f" "$floppy.DSK","${f^^}"
		functionErrorLevel

	fi


	# Copy all ROM files (and convert names to UPPERCASE) to DSK image
	if [[ $f == *.ROM ]]; then

		echo -e decb copy -2 -b -r "$f" "$floppy.DSK","${f^^}"
		decb copy -2 -b -r "$f" "$floppy.DSK","${f^^}"
		functionErrorLevel

	fi


	# Copy all CHR files for CoCoVGA (and convert names to UPPERCASE) to DSK image
	if [[ $f == *.CHR ]]; then

		echo -e decb copy -2 -b -r "$f" "$floppy.DSK","${f^^}"
		decb copy -2 -b -r "$f" "$floppy.DSK","${f^^}"
		functionErrorLevel

	fi


# Copy all VG6 files for CoCoVGA (and convert names to UPPERCASE) to DSK image
	if [[ $f == *.VG6 ]]; then

		echo -e decb copy -2 -b -r "$f" "$floppy.DSK","${f^^}"
		decb copy -2 -b -r "$f" "$floppy.DSK","${f^^}"
		functionErrorLevel

	fi


# Copy all SCR files for CoCoVGA (and convert names to UPPERCASE) to DSK image
	if [[ $f == *.SCR ]]; then

		echo -e decb copy -2 -b -r "$f" "$floppy.DSK","${f^^}"
		decb copy -2 -b -r "$f" "$floppy.DSK","${f^^}"
		functionErrorLevel

	fi


# Copy all PNG files for ugBasicA (and convert names to UPPERCASE) to DSK image
	if [[ $f == *.PNG ]]; then

		echo -e decb copy -2 -b -r "$f" "$floppy.DSK","${f^^}"
		decb copy -2 -b -r "$f" "$floppy.DSK","${f^^}"
		functionErrorLevel

	fi


done

echo -e

# list disk image contents
decb dir "$floppy.DSK"
echo -e


# if no parameters, only make disk image and exit
if [ $# -eq 0 ]
  then
    echo -e "Only made disk image as no command line parameters supplied"

	echo -e
	echo -e "Done."
	echo -e

	exit 1

fi


# get substr of passed variable for coco driver
driver=$2
driversub=${driver:0:5}


# (optional) load emulator and mount disk image in pyDrivewire INSTANCE 0 as DRIVE 0
if [[ $3 =~ Y|y ]]; then

	# make sure HDBDOS is used for pyDriveWire access

	# Coco 2 section
	if [[ $driversub =~ coco2 ]]; then
	
		# eject disk from pyDriveWire
		$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0
		echo -e

		# insert disk for pyDriveWire
		$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk insert 0 "$workdir/$floppy.DSK"
		echo -e

		# show (confirm) disk mounted in pyDriveWire
		$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk show 0
		echo -e
	
		# MAME emulator
		if [ "$1" == "mame" ]; then

			# use parameter file for MAME (if found)
			MAMEPARMSFILE=`cat $HOME/.mame/.optional_mame_parameters.txt`
			export MAMEPARMS=$MAMEPARMSFILE
	
			# enable Becker port
			cp $HOME/.mame/cfg/$2.cfg.beckerport-enabled $HOME/.mame/cfg/$2.cfg

			mame $2 -homepath $HOME/.mame -cart /media/share1/roms/hdbdw3bck.rom -ext fdc $MAMEPARMS
		
			# disable Becker port
			cp $HOME/.mame/cfg/$2.cfg.beckerport-disabled $HOME/.mame/cfg/$2.cfg

		fi

		
		# XRoar emulator
		if [ "$1" == "xroar" ]; then

			# use parameter file for XRoar (if found)
			XROARPARMSFILE=`cat $HOME/.xroar/.optional_xroar_parameters.txt`
			export XROARPARMS=$XROARPARMSFILE
	
			xroar -c $HOME/.xroar/xroar.conf -default-machine $2 -machine-cart becker $XROARPARMS		
		fi


		# trs80gp emulator
		if [ "$1" == "trs80gp" ]; then

			# use parameter file for trs80gp (if found)
			TRS80GPPARMSFILE=`cat $HOME/.trs80gp/.optional_trs80gp_parameters.txt`
			export TRS80GPPARMS=$TRS80GPPARMSFILE
	
			trs80gp $TRS80GPPARMS -mc -bck localhost:65504 -pakq /media/share1/roms/hdbdw3bc3.rom
		
		fi
		

		# eject disk from pyDriveWire
		$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0


		echo -e
		echo -e "Done."
		echo -e
		exit 1

	fi


	# Coco 3 section
	if [[ $driversub =~ coco3 ]]; then

		# eject disk from pyDriveWire
		$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0
		echo -e

		# insert disk for pyDriveWire
		$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk insert 0 "$workdir/$floppy.DSK"
		echo -e

		# show (confirm) disk mounted in pyDriveWire
		$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk show 0
		echo -e

		# MAME emulator
		if [[ "$1" == mame ]]; then

			# use parameter file for MAME (if found)
			MAMEPARMSFILE=`cat $HOME/.mame/.optional_mame_parameters.txt`
			export MAMEPARMS=$MAMEPARMSFILE
	
			# enable Becker port
			cp $HOME/.mame/cfg/$2.cfg.beckerport-enabled $HOME/.mame/cfg/$2.cfg

			mame $2 -homepath $HOME/.mame -ramsize 512k -ext multi -ext:multi:slot4 fdc -cart5 /media/share1/roms/hdbdw3bc3.rom $MAMEPARMS
			
			# disable Becker port
			cp $HOME/.mame/cfg/$2.cfg.beckerport-disabled $HOME/.mame/cfg/$2.cfg

		fi

		
		# XRoar emulator
		if [[ "$1" == xroar ]]; then

			# use parameter file for XRoar (if found)
			XROARPARMSFILE=`cat $HOME/.xroar/.optional_xroar_parameters.txt`
			export XROARPARMS=$XROARPARMSFILE
	
			xroar -c $HOME/.xroar/xroar.conf -default-machine $2 -machine-cart becker $XROARPARMS		

		fi


		# eject disk from pyDriveWire
		$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0


		echo -e
		echo -e "Done."
		echo -e
		exit 1

	fi


else


	# (optional) load emulator and mount the disk image (LOCAL) as DRIVE 0

	# Coco 2 and Coco 3 section
		# MAME emulator
		if [ "$1" == "mame" ]; then

			# use parameter file for MAME (if found)
			MAMEPARMSFILE=`cat $HOME/.mame/.optional_mame_parameters.txt`
			export MAMEPARMS=$MAMEPARMSFILE
	
			mame $2 -homepath $HOME/.mame -flop1 "$workdir/$floppy.DSK" $MAMEPARMS

		fi

		
		# XRoar emulator
		if [ "$1" == "xroar" ]; then

			# use parameter file for XRoar (if found)
			XROARPARMSFILE=`cat $HOME/.xroar/.optional_xroar_parameters.txt`
			export XROARPARMS=$XROARPARMSFILE
	
			xroar -c $HOME/.xroar/xroar.conf -default-machine $2 -load "$workdir/$floppy.DSK" $XROARPARMS
		
		fi
		
		
		# trs80gp emulator
		if [ "$1" == "trs80gp" ]; then

			# use parameter file for trs80gp (if found)
			TRS80GPPARMSFILE=`cat $HOME/.trs80gp/.optional_trs80gp_parameters.txt`
			export TRS80GPPARMS=$TRS80GPPARMSFILE
	
			trs80gp -mc $TRS80GPPARMS -d0 "$workdir/$floppy.DSK"
		
		fi

		echo -e
		echo -e "Done."
		echo -e

		exit 1

	fi

fi


echo -e
echo -e "Done."
echo -e

exit 1
