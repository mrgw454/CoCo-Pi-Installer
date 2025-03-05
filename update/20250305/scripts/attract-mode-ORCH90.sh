#!/bin/bash

echo -e "zenity --info --width=200 --height=50 --title=\"Attract Mode\" --text=\"Click OK to cancel\nAttract Mode.\n\nProcess ID: $$\"; kill $$ &" > /tmp/cancel.sh
chmod a+x /tmp/cancel.sh; /tmp/cancel.sh &

cd $HOME/.mame

clear

echo -e "Coco 3 Orchestra 90 Attract Mode Music Demo" > msg.txt
echo -e >> msg.txt
echo -e "MOD music player (CoCoTracker) by Sockmaster" >> msg.txt
echo -e "More information can be found at:" >> msg.txt
echo -e >> msg.txt
echo -e "http://users.axess.com/twilight/sock/mod/index.html" >> msg.txt
echo -e >> msg.txt
echo -e >> msg.txt

whiptail --title "Orchestra 90 Attract Mode Music Demo" --textbox msg.txt 0 0
rm msg.txt


# loop over Coco 3 disk images with MOD music files and run them for 180 seconds (-seconds_to_run option) each

MAMEPARMSFILE=`cat $HOME/.mame/.optional_mame_parameters.txt`
export MAMEPARMS=$MAMEPARMSFILE

# eject DSK in DRIVE 0
#$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk eject 0

# insert CoCoTracker DSK in DRIVE 0
#$HOME/pyDriveWire/pyDwCli http://localhost:6800 dw disk insert 0 "/media/share1/SDC/MUSIC/MOD6309.DSK"


shopt -s extglob
shopt -s nocasematch

for file in /media/share1/SDC/MUSIC/MODS/*.@(dsk|DSK);
do

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
	echo
	echo
	echo "Press [CTRL][C] to BREAK out of ATTRACT mode."
	echo
	echo "Press [F10] to toggle the no throttle option (helps speed things up)."
	sleep 2

	PROGNAME="$(decb dir $file | grep ' BIN')"
	string="${PROGNAME}"

	# this will break apart the original strings into individual ones (as $1, $2, $3, etc.).
	set -- $string

	mame coco3h -ramsize 512k -ext multi -ext:multi:slot4 fdcv11 -ext:multi:slot1 orch90 -flop1 /media/share1/SDC/MUSIC/MOD6309.DSK -flop2 "$file" -autoboot_script $HOME/scripts/attract-mode-ORCH90.lua -autoboot_delay 2 -seconds_to_run 300 $MAMEPARMS


done

cd $HOME/.mame
