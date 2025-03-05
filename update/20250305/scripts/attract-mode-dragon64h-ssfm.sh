#!/bin/bash

echo -e "zenity --info --width=200 --height=50 --title=\"Attract Mode\" --text=\"Click OK to cancel\nAttract Mode.\n\nProcess ID: $$\"; kill $$ &" > /tmp/cancel.sh
chmod a+x /tmp/cancel.sh; /tmp/cancel.sh &

# loop over Dragon 64 VDK images (for the MSX2-ssfm device)  and run them for 120 seconds each
# requires 6309 and 2nd display enabled!

MAMEPARMSFILE=`cat $HOME/.mame/.optional_mame_parameters.txt`
export MAMEPARMS=$MAMEPARMSFILE

shopt -s extglob
shopt -s nocasematch

for file in /media/share1/SDC-Dragon/MSX2/*.@(vdk|VDK);
do

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
	echo
	echo
	echo "Press [CTRL][C] to BREAK out of ATTRACT mode."
	echo
	echo "Press [F10] to toggle the no throttle option (helps speed things up)."
	sleep 2

	PROGNAME="$(decb dir $file | grep ' BAS')"
	string="${PROGNAME}"

	# this will break apart the original strings into individual ones (as $1, $2, $3, etc.).
	set -- $string

	# added -nothrottle option to speed up the loading process
	#mame dragon64h -ext multi -ext:multi:slot3 ssfm -flop1 "$file" -seconds_to_run 120 -autoboot_delay 2 -autoboot_command "LOAD \"$1\":RUN\n" $MAMEPARMS
	mame dragon64h -ext multi -ext:multi:slot3 ssfm -flop1 "$file" -seconds_to_run 120 -autoboot_delay 4 -autoboot_command "RUN \"RO.BAS\"\n" $MAMEPARMS
done

cd $HOME/.mame
