#!/bin/bash

title="$(cat $HOME/cocopi-release.txt) $(cat $HOME/rpi-model.txt)"
prompt="<b>CoCo 2 Menu</b>"
options=("TRS-80 Color Computer 2 DECB" \
         "TRS-80 Color Computer 2 HDBDOS"
         "Return to Main Menu")

while opt=$(zenity --width=640 --height=480 --title="$title" --window-icon="/home/pi/Pictures/CoCo-Pi.png" --text="$prompt" --list  --column=""  "${options[@]}"); do
    select=""

    case "$opt" in
    "${options[0]}" ) $HOME/.trs80gp/coco2-decb-trs80gp.sh;;
    "${options[1]}" ) $HOME/.trs80gp/coco2-hdbdos-trs80gp.sh;;
    "${options[2]}" ) $HOME/scripts/menu-z2.sh & kill $$;;

     *) echo "Quitting...";;
    esac

done
