#!/bin/bash

echo -e "zenity --info --width=200 --height=50 --title=\"Attract Mode\" --text=\"Click OK to cancel\nAttract Mode.\n\nProcess ID: $$\"; kill $$ &" > /tmp/cancel.sh
chmod a+x /tmp/cancel.sh; /tmp/cancel.sh &

# loop over Dragon 32 cartridges and run them for 120 seconds each

MAMEPARMSFILE=`cat $HOME/.mame/.optional_mame_parameters.txt`
export MAMEPARMS=$MAMEPARMSFILE

shopt -s extglob
shopt -s nocasematch

for f in `ls /media/share1/software/dragon_cart/*.zip`

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

                echo file = "$f"
                echo
                echo "Press [CTRL][C] to BREAK out of ATTRACT mode."
		echo
		echo "Press [F10] to toggle the no throttle option (helps speed things up)."
		sleep 2
		mame dragon32 ${f//+(*\/|.*)} -seconds_to_run 120 $MAMEPARMS
	done

cd $HOME/.mame
