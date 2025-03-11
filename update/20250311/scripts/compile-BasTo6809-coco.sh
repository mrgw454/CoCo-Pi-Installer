#!/bin/bash

# clean up BASIC-To-6809 project files
function cleanup {
        echo
	echo Deleting temporary files and folders...
	echo
        rm -rf $workdir/Basic_Includes
        rm -rf $workdir/Basic_Commands

	# Define an array of additional files to delete
	files_to_delete=("$workdir/Assembly_Listing.txt" "$workdir/$basefilename.asm" "$workdir/BASIC_Text.bas" \
		"$workdir/BasicTokenizedB4Pass2.bin" "$workdir/BasicTokenizedB4Pass3.bin" "$workdir/BasicTokenized.bin" \
		"$workdir/DefFNUsed.txt" "$workdir/DefVarUsed.txt" "$workdir/NumericArrayVarsUsed.txt" "$workdir/NumericCommandsFound.txt" \
		"$workdir/NumericVariablesUsed.txt" "$workdir/StringArrayVarsUsed.txt" "$workdir/StringCommandsFound.txt" \
		"$workdir/StringVariablesUsed.txt" "$workdir/FloatingPointVariablesUsed.txt" "$workdir/GeneralCommandsFound.txt" \
		"$workdir/BasTo6809" "$workdir/BasTo6809.1.Tokenizer" "$workdir/BasTo6809.2.Compile" "$workdir/cc1sl")

	# Loop through the array and delete each file
	for file in "${files_to_delete[@]}"; do
		if [[ -f "$file" ]]; then
		rm "$file"
	else
		echo > /dev/null
	fi
	done
	echo
}

# script to compile BASIC-to-6809 programs for the CoCo.

# syntax example:

# ./compile-BasTo6809-coco.sh <FILE>

# get name of script and place it into a variable
scriptname=`basename "$0"`

# parse command line parameters for standard help options
if [ $# -eq 0 ]; then
    echo -e
    echo -e "Example syntax:"
    echo -e
    echo -e "./$scriptname <FILE>"
    echo -e
    exit 1
else
	if [[ $1 =~ --h|--help|-h ]];then
		echo -e
		echo -e "Example syntax:"
		echo -e
		echo -e "./$scriptname <FILE>"
		echo -e
		exit 1
	fi
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
#./BasTo6809 -ascii "$filename"
output=$(./BasTo6809 -ascii "$filename")
result=$(echo "$output" | grep "Error")

if [[ $? -eq 0 ]]; then
	echo "generating asm file was NOT successful.  Aborting."
	echo "$result"
	cleanup
	exit 1
else
	echo "generating asm file was successful."
fi


# assemble to binary
echo assembling into binary file...
echo
output=$(lwasm -9bl -p cd -o./$basefilename.bin $basefilename.asm > ./Assembly_Listing.txt)
result=$(echo "$output" | grep "ERROR")

if [[ $? -eq 0 ]]; then
        echo "assembling into binary file was NOT successful.  Aborting."
        echo "$result"
	cleanup
	exit 1
else
        echo "assembling into binary file was successful."
fi

cleanup
