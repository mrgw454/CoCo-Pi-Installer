    clear
    RETVAL=$(whiptail --title "$(cat $HOME/cocopi-release.txt) $(cat $HOME/rpi-model.txt)" \
    --menu "\nPlease select from the following:" 18 70 10 \
    "1" "TRS-80 Color Computer 2 DECB w/64K" \
    "2" "TRS-80 Color Computer 2 HDBDOS w/64K" \
    "3" "Return to Main Menu" \
    3>&1 1>&2 2>&3)

    # Below you can enter the corresponding commands

    case $RETVAL in
        1) $HOME/.trs80gp/coco2-decb-trs80gp.sh;;
        2) $HOME/.trs80gp/coco2-hdbdos-trs80gp.sh;;
        3) menu;;
        *) echo "Quitting...";;
    esac
