#!/bin/bash

# script to compile ugBasic programs for the CoCo.

# syntax example:

# ./compile-ugBasic-coco.sh <FILE> <COCO MODEL> <EMULATOR> <BETA Y or N>

# get name of script and place it into a variable
scriptname=`basename "$0"`

# parse command line parameters for standard help options
if [ $# -eq 0 ]; then
    echo -e
    echo -e "Example syntax:"
    echo -e
    echo -e "./$scriptname <FILE> <COCO MODEL> <EMULATOR> <beta Y or N>"
    echo -e
    exit 1
else
	if [[ $1 =~ --h|--help|-h ]];then

		echo -e
		echo -e "Example syntax:"
		echo -e
		echo -e "./$scriptname <FILE> <COCO MODEL> <EMULATOR> <beta Y or N>"
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

# get substr of passed variable for coco driver
driver=$2
driversub=${driver:0:5}


# remove existing files
if [ -f "$workdir/$filename.dsk" ]; then
	rm "$workdir/$filename.dsk"
fi

# enable ugBasic-beta
if [[ $4 =~ y|Y ]];then
	beta=.beta
else
	unset beta
fi

# compile ugBasic program

if [[ $2 =~ coco2 ]];then

	/usr/local/bin/ugbc.coco$beta -O dsk $workdir/$filename.$extension -o $workdir/$filename.dsk
	
	if [ $? -eq 0 ]
	then
			echo "Compilation was successful."
			echo
	else
			echo "Compilation was NOT successful.  Aborting."
			echo
			exit 1
	fi

fi


if [[ $2 =~ coco3 ]];then

	/usr/local/bin/ugbc.coco3$beta -O dsk $workdir/$filename.$extension -o $workdir/$filename.dsk

	if [ $? -eq 0 ]
	then
			echo "Compilation was successful."
			echo
	else
			echo "Compilation was NOT successful.  Aborting."
			echo
			exit 1
	fi


fi

exit

# launch emulator
if [ -f "$workdir/$filename.dsk" ]; then

	# launch emulator and mount DSK image
	if [[ $3 =~ mame ]];then
		$HOME/.mame/$driversub-decb.sh $filename.dsk
	fi

	if [[ $3 =~ xroar ]];then
		$HOME/.xroar/$driversub-decb-xroar.sh $workdir/$filename.dsk
	fi

	if [[ $3 =~ trs80gp ]];then
		$HOME/.trs80gp/coco2-decb-trs80gp.sh $workdir/$filename.dsk
	fi

else

	echo "$workdir/$filename.dsk" does not existing.  Not launching $3.
	echo

fi


echo -e
echo -e "Done."
echo -e

exit 1
