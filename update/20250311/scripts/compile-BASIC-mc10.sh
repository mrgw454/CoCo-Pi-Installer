#!/bin/bash

# script to compile MC-10 BASIC programs (non MCX-BASIC for now) using Greg Dionne's mcbasic compiler.
# It will also create a WAV file for real cassette CLOADM'ing

# syntax example:

# ./compile-BASIC-mc10.sh <FILE> <EMULATOR>

# get name of script and place it into a variable
scriptname=`basename "$0"`

# parse command line parameters for standard help options
if [ $# -eq 0 ]; then
    echo -e
    echo -e "Example syntax:"
    echo -e
    echo -e "./$scriptname <FILE> <EMULATOR>"
    echo -e
    exit 1
else
	if [[ $1 =~ --h|--help|-h ]];then
		echo -e
		echo -e "Example syntax:"
		echo -e
		echo -e "./$scriptname <FILE> <EMULATOR>"
		echo -e
		exit 1
	fi
fi


# set up some variables
filename=$(basename -- "$1")
dir=$(dirname -- "$1")
extension="${filename##*.}"
filename="${filename%.*}"
workdir=$(pwd)


# remove existing files 
if [ -f "$workdir/$filename.c10" ]; then
	rm "$workdir/$filename.c10"
fi

if [ -f "$workdir/$filename.wav" ]; then
	rm "$workdir/$filename.wav"
fi


# compile BASIC program
mcbasic -native -el -v $workdir/$filename.$extension

if [ $? -eq 0 ]
then
	echo "Compilation was successful."
	echo
else
	echo "Compilation was NOT successful.  Aborting."
	echo
	exit 1
fi


if [ -f "$workdir/$filename.c10" ]; then

	# convert assembled binary into WAV file
	echo Converting $filename.c10 to WAV...
	echo -e
	cas2wav $workdir/$filename.c10 $workdir/$filename.wav

fi


# launch emulator
if [ -f "$workdir/$filename.c10" ]; then

	if [[ $2 =~ mame ]];then
		$HOME/.mame/mc-10-20k.sh $workdir/$filename.c10
	fi

	if [[ $2 =~ xroar ]];then
		$HOME/.xroar/mc-10-20k-xroar.sh $workdir/$filename.c10
	fi

	if [[ $2 =~ trs80gp ]];then
		$HOME/.trs80gp/mc-10-20k-trs80gp.sh $workdir/$filename.c10
	fi

else

	echo "$workdir/$filename.c10" does not existing.  Not launching $2.
	echo

fi


echo -e
echo -e "Done."
echo -e

exit 1

