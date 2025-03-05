#!/bin/bash

echo -e "zenity --info --width=200 --height=50 --title=\"Attract Mode\" --text=\"Click OK to cancel\nAttract Mode.\n\nProcess ID: $$\"; kill $$ &" > /tmp/cancel.sh
chmod a+x /tmp/cancel.sh; /tmp/cancel.sh &

# loop over Coco 3 disk images with MOD music files and run them for 180 seconds (-seconds_to_run option) each

MAMEPARMSFILE=`cat $HOME/.mame/.optional_mame_parameters.txt`
export MAMEPARMS=$MAMEPARMSFILE

# eject DSK in DRIVE 0
#$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0

# insert CoCoTracker DSK in DRIVE 0
#$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk insert 0 "/media/share1/SDC/MUSIC/MOD6309.DSK"


shopt -s extglob
shopt -s nocasematch

for run in {1..100}
do

file=$(shuf -ezn 1 $1/* | xargs -0 -n1 echo)

	# eject DSK in DRIVE 1
	#$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 1

	# insert MOD music file DSK in DRIVE 1
	#$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk insert 1 "$file"

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
	echo "Press [F10] to toggle the no throttle option (helps speed things up)."
	sleep 2

	PROGNAME="$(decb dir $file | grep ' BIN')"
	string="${PROGNAME}"

	# this will break apart the original strings into individual ones (as $1, $2, $3, etc.).
	#set -- $string

	mame coco3h -ramsize 512k -ext multi -ext:multi:slot4 fdcv11 -ext:multi:slot1 orch90 -flop1 /media/share1/SDC/MUSIC/MOD6309.DSK -flop2 "$file" -autoboot_script $HOME/scripts/attract-mode-ORCH90.lua -autoboot_delay 2 -seconds_to_run 120 $MAMEPARMS


done

cd $HOME/.mame
