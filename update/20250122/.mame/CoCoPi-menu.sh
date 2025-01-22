echo -n "\033]2;menu\007"

export PATH=$PATH:~/.mame:~/scripts
export NEWT_COLORS='
root=black,black
border=black,black
window=black,black
shadow=black,black
title=brightgreen,black
button=white,black
actbutton=black,white
checkbox=back,black
actcheckbox=black,black
entry=green,black
label=white,black
listbox=green,black
actlistbox=black,green
textbox=white,black
acttextbox=black,white
helpline=black
roottext=black
disentry=black,black
compactbutton=black,black
actsellistbox=black,green
sellistbox=green,black
'

    clear

    RETVAL=$(whiptail --title "$(cat $HOME/cocopi-release.txt) $(cat $HOME/rpi-model.txt)" \
    --menu "\nPlease select from the following:" 18 65 10 \
    "1" "TRS-80 Color Computer 2 Menu" \
    "2" "TRS-80 Color Computer 2 Menu (XRoar)" \
    "3" "TRS-80 Color Computer 2 Menu (trs80gp)" \
    "4" "Tandy  Color Computer 3 Menu" \
    "5" "Tandy  Color Computer 3 Menu (XRoar)" \
    "6" "Tandy  Color Computer 3 Menu (OVCC)" \
    "7" "TRS-80 MC-10 Menu" \
    "8" "TRS-80 MC-10 Menu (XRoar)" \
    "9" "TRS-80 MC-10 Menu (trs80gp)" \
    "10" "Dragon Menu" \
    "11" "Dragon Menu (XRoar)" \
    "12" "Clone Systems Menu" \
    "13" "Utilities Menu" \
    "14" "Internet/Online Menu" \
    "15" "Attract (Kiosk) Mode Menu" \
    "16" "Shutdown Raspberry Pi" \
    3>&1 1>&2 2>&3)

    # Below you can enter the corresponding commands

    case $RETVAL in
        1) CoCoPi-menu-Coco2.sh;;
        2) CoCoPi-menu-Coco2-XRoar.sh;;
        3) CoCoPi-menu-Coco2-trs80gp.sh;;
        4) CoCoPi-menu-Coco3.sh;;
        5) CoCoPi-menu-Coco3-XRoar.sh;;
        6) CoCoPi-menu-Coco3-OVCC.sh;;
        7) CoCoPi-menu-MC10.sh;;
        8) CoCoPi-menu-MC10-XRoar.sh;;
        9) CoCoPi-menu-MC10-trs80gp.sh;;
       10) CoCoPi-menu-Dragon.sh;;
       11) CoCoPi-menu-Dragon-XRoar.sh;;
       12) CoCoPi-menu-Clones.sh;;
       13) CoCoPi-menu-Utilities.sh;;
       14) CoCoPi-menu-Online.sh;;
       15) CoCoPi-menu-Attract.sh;;
       16) shutdownRPi.sh;;
        *) echo "Quitting...";;
    esac
