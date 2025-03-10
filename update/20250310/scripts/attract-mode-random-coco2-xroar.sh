#!/bin/bash

echo -e "zenity --info --width=200 --height=50 --title=\"Attract Mode\" --text=\"Click OK to cancel\nAttract Mode.\n\nProcess ID: $$\"; kill $$ &" > /tmp/cancel.sh
chmod a+x /tmp/cancel.sh; /tmp/cancel.sh &

# select random Coco 2 program and run for 120 seconds each

cd $HOME/.xroar

XROARPARMSFILE=`cat $HOME/.xroar/.optional_xroar_parameters.txt`
export XROARPARMS=$XROARPARMSFILE

shopt -s extglob
shopt -s nocasematch

for run in {1..100}
do

#file=$(shuf -ezn 1 $1/* | xargs -0 -n1 echo)
file=$(find "$1" -type f -print0 | shuf -z | xargs -0 -n1 echo 2>/dev/null | head -n 1)

     clear
     echo
     echo
     echo
     echo
     echo
     echo
     echo
     echo

     echo "Random disk $run"
     echo "file = $file"
     echo
     echo "Press [CTRL][C] to BREAK out of ATTRACT mode."
     echo
     echo "Press [SHIFT][F12] to toggle the no throttle option (helps speed things up)."
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
		xroar -c $HOME/.xroar/xroar.conf -machine coco2bus -timeout 120 $XROARPARMS -cart mpi -mpi-load-cart 3=rsdos -mpi-slot 3 -load "$file" -type 'RUN "'$program'"\r'
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
			xroar -c $HOME/.xroar/xroar.conf -machine coco2bus -timeout 120 $XROARPARMS -cart mpi -mpi-load-cart 3=rsdos -mpi-slot 3 -load "$file" -type 'LOADM "'$program'"\rEXEC/r'

		fi
	fi

     fi


     if [[ $file == *.ccc ]]; then

	xroar -c $HOME/.xroar/xroar.conf -default-machine coco2bus -timeout 120 $XROARPARMS -cart-autorun "$file"
     fi


BAS=0

done

cd $HOME/.mame
