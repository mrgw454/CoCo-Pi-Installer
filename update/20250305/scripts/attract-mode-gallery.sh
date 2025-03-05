#!/bin/bash

echo -e "zenity --info --width=200 --height=50 --title=\"Attract Mode\" --text=\"Click OK to cancel\nAttract Mode.\n\nProcess ID: $$\"; kill $$ &" > /tmp/cancel.sh
chmod a+x /tmp/cancel.sh; /tmp/cancel.sh &

cd $HOME/.mame

clear

echo -e "Coco 3 Image Gallery Slideshow (by Ron Delaux)" > msg.txt
echo -e >> msg.txt
echo -e "The images displayed by the Coco 3 are using a utility from Sockmaster" >> msg.txt
echo -e "called HiColor.  More information can be found at:" >> msg.txt
echo -e >> msg.txt
echo -e "http://users.axess.com/twilight/sock/hicolor/hicolor.html" >> msg.txt
echo -e >> msg.txt
echo -e >> msg.txt

whiptail --title "Slideshow" --textbox msg.txt 0 0
rm msg.txt


# loop over Coco 3 disk images with artwork and run them for 120 seconds (-seconds_to_run option) each

MAMEPARMSFILE=`cat $HOME/.mame/.optional_mame_parameters.txt`
export MAMEPARMS=$MAMEPARMSFILE

shopt -s extglob
shopt -s nocasematch

for file in /media/share1/RonD/**/*.@(dsk|DSK);
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

	PROGNAME="$(decb dir $file | grep ' BIN')"
	string="${PROGNAME}"

	# this will break apart the original strings into individual ones (as $1, $2, $3, etc.).
	set -- $string

	# added -nothrottle option to speed up the loading process
	mame coco3 -ext multi -flop1 "$file" -seconds_to_run 120 -autoboot_delay 2 -autoboot_command "LOADM \"$1\":EXEC\n" $MAMEPARMS

done

cd $HOME/.mame


