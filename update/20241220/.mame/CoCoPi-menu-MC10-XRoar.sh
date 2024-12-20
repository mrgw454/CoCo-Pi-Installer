    clear
    RETVAL=$(whiptail --title "$(cat $HOME/cocopi-release.txt) $(cat $HOME/rpi-model.txt)" \
    --menu "\nPlease select from the following:" 18 65 10 \
    "1" "TRS-80 Micro Color Computer   4K" \
    "2" "TRS-80 Micro Color Computer  20K" \
    "3" "TRS-80 Micro Color Computer  32K" \
    "4" "TRS-80 Micro Color Computer 128K (MCX Basic)" \
    "5" "Return to Main Menu" \
    3>&1 1>&2 2>&3)

    # Below you can enter the corresponding commands

    case $RETVAL in
        1) $HOME/.xroar/mc-10-4k-xroar.sh;;
        2) $HOME/.xroar/mc-10-20k-xroar.sh;;
        3) $HOME/.xroar/mc-10-32k-xroar.sh;;
        4) $HOME/.xroar/mc-10-128k-xroar.sh;;
        5) menu;;
        *) echo "Quitting...";;
    esac
