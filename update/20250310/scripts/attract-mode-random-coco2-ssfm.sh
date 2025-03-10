#!/bin/bash

echo -e "zenity --info --width=200 --height=50 --title=\"Attract Mode\" --text=\"Click OK to cancel\nAttract Mode.\n\nProcess ID: $$\"; kill $$ &" > /tmp/cancel.sh
chmod a+x /tmp/cancel.sh; /tmp/cancel.sh &

# loop over CoCo 2 DSK images (for the SSFM device)  and run them for 120 seconds each
# requires SSFM board, a 6309 and 2nd display enabled!

MAMEPARMSFILE=`cat $HOME/.mame/.optional_mame_parameters.txt`
export MAMEPARMS=$MAMEPARMSFILE

# needed to ensure SSFM I/O address of &HFF56 is used for MPI
cp $HOME/.mame/cfg/coco2bh.cfg.SSFM-enabled $HOME/.mame/cfg/coco2bh.cfg

shopt -s extglob
shopt -s nocasematch

for run in {1..100}
do

     #file=$(shuf -ezn 1 $1/*.* | xargs -0 -n1 echo)
	 file=$(find "$1" -type f -print0 | shuf -z | xargs -0 -n1 echo 2>/dev/null | head -n 1)

     file_path="$file"

     # Extract filename with extension
     filename_with_ext=$(basename "$file_path")

     # Extract filename without extension
     filename_no_ext="${filename_with_ext%.*}"

     #echo "Original path: $file_path"
     #echo "Filename with extension: $filename_with_ext"
     #echo "Filename without extension: $filename_no_ext"

     #clear
     echo
     echo
     echo
     echo
     echo
     echo
     echo
     echo

     echo "Random program $run"
     echo "file = $file"
     echo
     echo "Press [CTRL][C] to BREAK out of ATTRACT mode."
	echo
	echo "Press [F10] to toggle the no throttle option (helps speed things up)."
	sleep 2

     if [[ $file == *.dsk ]]; then
	decb dir "$file"
	echo -e

	dir=$(decb dir "$file" | grep -E '.BAS')
	program=$(echo $dir | cut -d " " -f1)
	ext=$(echo $dir | cut -d " " -f2)
	echo -e

	echo -e "program: $program"
	echo -e "ext    : $ext"

	# BASIC program
	if [[ $ext == 'BAS' ]]; then

		echo Program to run/execute: $program
		sleep 2
		#mame coco2bh -ram 64k -flop1 "$file" -seconds_to_run 120 -autoboot_delay 2 -autoboot_command "RUN \"$program\"\n" $MAMEPARMS
		# added -nothrottle option to speed up the loading process
		mame coco2bh -ram 64k -ext multi -ext:multi:slot1 ssfm -flop1 "$file" -seconds_to_run 120 -autoboot_delay 4 -autoboot_command "RUN \"$program\"\n" $MAMEPARMS

		BAS=1

	fi



	if [[ $BAS != 1 ]]; then
		dir=$(decb dir "$file" | grep -E '.BIN')
		program=$(echo $dir | cut -d " " -f1)
		ext=$(echo $dir | cut -d " " -f2)
		echo -e

		# BINARY program
		if [[ $ext == 'BIN' ]]; then

			echo Program to run/execute: $program
			sleep 2
			#mame coco2bh -ram 64k -flop1 "$file" -seconds_to_run 120 -autoboot_delay 2 -autoboot_command "LOADM \"$program\":EXEC\n" $MAMEPARMS
			# added -nothrottle option to speed up the loading process
			mame coco2bh -ram 64k -ext multi -ext:multi:slot1 ssfm -flop1 "$file" -seconds_to_run 120 -autoboot_delay 4 -autoboot_command "LOADM \"$program\":EXEC\n" $MAMEPARMS
		fi
	fi


     fi

BAS=0

done

cd $HOME/.mame
