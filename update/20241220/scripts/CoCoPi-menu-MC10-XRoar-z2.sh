#!/bin/bash

title="$(cat $HOME/cocopi-release.txt) $(cat $HOME/rpi-model.txt)"
prompt="<b>MC-10 XRoar Menu</b>"
options=("TRS-80 Micro Color Computer   4K" \
         "TRS-80 Micro Color Computer  20K (internal RAM)" \
         "TRS-80 Micro Color Computer  32K (internal RAM)" \
         "TRS-80 Micro Color Computer 128K (MCX Basic)" \
         "Return to Main Menu")

while opt=$(zenity --width=640 --height=480 --title="$title" --window-icon="/home/pi/Pictures/CoCo-Pi.png" --text="$prompt" --list  --column=""  "${options[@]}"); do
    select=""

    case "$opt" in
    "${options[0]}" ) $HOME/.xroar/mc-10-4k-xroar.sh;;
    "${options[1]}" ) $HOME/.xroar/mc-10-20k-xroar.sh;;
    "${options[2]}" ) $HOME/.xroar/mc-10-32k-xroar.sh;;
    "${options[3]}" ) $HOME/.xroar/mc-10-128k-xroar.sh;;
    "${options[4]}" ) $HOME/scripts/menu-z2.sh & kill $$;;

     *) echo "Quitting...";;
    esac

done
