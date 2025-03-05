#!/bin/bash

echo -e "zenity --info --width=200 --height=50 --title=\"Attract Mode\" --text=\"Click OK to cancel\nAttract Mode.\n\nProcess ID: $$\"; kill $$ &" > /tmp/cancel.sh
chmod a+x /tmp/cancel.sh; /tmp/cancel.sh &

# select 100 random MC-10 titles and run them for 120 seconds each

MAMEPARMSFILE=`cat $HOME/.mame/.optional_mame_parameters.txt`
export MAMEPARMS=$MAMEPARMSFILE

shopt -s extglob
shopt -s nocasematch

for run in {1..100}
do

file=$(shuf -ezn 1 /media/share1/software/mc10/* | xargs -0 -n1 echo)

     clear
     echo
     echo
     echo
     echo
     echo
     echo
     echo
     echo

     echo "Random program $run"
     program=$(basename $file)
     echo "file = $program"
     echo
     echo "Press [CTRL][C] to BREAK out of ATTRACT mode."
     echo
     echo "echo Press [F10] to toggle the no throttle option (helps speed things up)."
     sleep 2
     mame mc10 -ramsize 20K ${program//+(*\/|.*)} -seconds_to_run 120 $MAMEPARMS
     read -p  "Press any key to continue." -n1 -s
done

cd $HOME/.mame
