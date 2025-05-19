#!/bin/bash

echo -e "zenity --info --width=200 --height=50 --title=\"Attract Mode\" --text=\"Click OK to cancel\nAttract Mode.\n\nProcess ID: $$\"; kill $$ &" > /tmp/cancel.sh
chmod a+x /tmp/cancel.sh; /tmp/cancel.sh &

# loop over MIDI files and run them for 180 seconds (-seconds_to_run option) each

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
	echo Processing file = "$file"
	echo "file = $file"
	echo
	echo
	echo "Press [CTRL][C] to BREAK out of ATTRACT mode."
	echo
	sleep 2

	# this will break apart the original strings into individual ones (as $1, $2, $3, etc.).
	#set -- $string

	timelimit -t120 fluidsynth "$file"


done
