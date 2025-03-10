#!/bin/bash

# script to compile BASIC-to-6809 programs for the CoCo.

# syntax example:

# ./compile-BasTo6809-coco.sh <FILE>

# get name of script and place it into a variable
scriptname=`basename "$0"`

# parse command line parameters for standard help options

if [[ $1 =~ --h|--help|-h ]];then

    echo -e
    echo -e "Example syntax:"
    echo -e
    echo -e "./$scriptname <FILE>"
    echo -e
    exit 1

fi

# set up some variables
filename=$(basename -- "$1")
extension="${filename##*.}"
basefilename="${filename%.*}"
workdir=$(pwd)

# echo information back
echo workdir      : $workdir
echo filename     : $filename
echo basefilename : $basefilename
echo extension    : $extension
echo

# create temporary symbolic links to BasTo6809 project folder
if [ -d $HOME/source/BASIC-To-6809 ]; then

	if [ ! -f $workdir/BasTo6809 ]; then
		cp $HOME/source/BASIC-To-6809/BasTo6809 $workdir
	fi


	if [ ! -f $workdir/BasTo6809.1.Tokenizer ]; then
		cp $HOME/source/BASIC-To-6809/BasTo6809.1.Tokenizer $workdir
	fi


	if [ ! -f $workdir/BasTo6809.2.Compile ]; then
		cp $HOME/source/BASIC-To-6809/BasTo6809.2.Compile $workdir
	fi


	if [ ! -f $workdir/cc1sl ]; then
		cp $HOME/source/BASIC-To-6809/cc1sl $workdir
	fi


	if [ ! -d $workdir/Basic_Includes ]; then
	        cp -R $HOME/source/BASIC-To-6809/Basic_Includes $workdir
	fi


	if [ ! -d $workdir/Basic_Commands ]; then
        	cp -R $HOME/source/BASIC-To-6809/Basic_Commands $workdir
	fi

else

	echo
	echo BASIC-To-6809 project folder does not exist.  Aborting.
	echo
	exit 1
fi


# convert to asm
echo generating asm file...
echo
./BasTo6809 -ascii "$filename"

# assemble to binary
echo assembling into binary file...
echo
lwasm -9bl -p cd -o./$basefilename.bin $basefilename.asm > ./Assembly_Listing.txt

echo
echo

if [ $? -eq 0 ]
then
        echo "Compilation was successful."
        echo
else
        echo "Compilation was NOT successful.  Aborting."
        echo
        exit 1
fi


# clean up BASIC-To-6809 project files
echo
echo removing temporary files and folders...
echo
rm $workdir/BasTo6809
rm $workdir/BasTo6809.1.Tokenizer
rm $workdir/BasTo6809.2.Compile
rm $workdir/cc1sl

rm -rf $workdir/Basic_Includes
rm -rf $workdir/Basic_Commands
rm $workdir/Assembly_Listing.txt
rm $workdir/$basefilename.asm


# create DSK image with binary program
echo
echo creating DSK image...
echo
makeDSK-pyDW.sh

rm $workdir/$basefilename.bin
