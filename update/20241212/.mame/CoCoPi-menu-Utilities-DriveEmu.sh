    clear
    RETVAL=$(whiptail --title "$(cat $HOME/cocopi-release.txt) $(cat $HOME/rpi-model.txt)" \
    --menu "\nPlease select from the following:" 18 70 10 \
    "1"  "System Status" \
    "2"  "Start     pyDriveWire server" \
    "3"  "Stop      pyDriveWire server" \
    "4"  "Edit      pyDriveWire configuration" \
    "5"  "Select    pyDriveWire version" \
    "6"  "Restart   Drivewire 4" \
    "7"  "Stop      Drivewire 4" \
    "8"  "Start     FujiNet-PC (WIP)" \
    "9"  "Stop      FujiNet-PC (WIP)" \
    "10" "Edit      FujiNet-PC configuration" \
    "11" "Start     Lemma (Waiter) for CoCoIO" \
    "12" "Stop      Lemma (Waiter) for CoCoIO" \
    "13" "Start     lwwire (Use option 9 prior to running)" \
    "14" "Stop      lwwire" \
    "15" "Edit      lwwire configuration" \
    "16" "Start     emceed file server (MC-10)" \
    "17" "Stop      emceed file server (MC-10)" \
    "18" "Reboot    Raspberry Pi" \
    "19" "Shutdown  Raspberry Pi" \
    "20" "Return to Utilities Menu" \
    "21" "Return to Main Menu" \
    3>&1 1>&2 2>&3)

    # Below you can enter the corresponding commands

    case $RETVAL in
        1) status.sh && CoCoPi-menu-Utilities-DriveEmu.sh;;
        2) $HOME/pyDriveWire/start_pyDW.sh && CoCoPi-menu-Utilities-DriveEmu.sh;;
        3) $HOME/pyDriveWire/stop_pyDW.sh && CoCoPi-menu-Utilities-DriveEmu.sh;;
        4) nano $HOME/.pydrivewirerc && CoCoPi-menu-Utilities-DriveEmu.sh;;
        5) select-pyDW.sh && CoCoPi-menu-Utilities-DriveEmu.sh;;
        6) $HOME/DriveWire4/restartDW4.sh && CoCoPi-menu-Utilities-DriveEmu.sh;;
        7) $HOME/DriveWire4/stopDW4.sh && CoCoPi-menu-Utilities-DriveEmu.sh;;
        8) start-FujiNet-server-CoCo-Becker.sh > /tmp/fujinet-pc-coco-log.txt && CoCoPi-menu-Utilities-DriveEmu.sh;;
        9) stop-FujiNet-server.sh >> /tmp/fujinet-pc-coco-log.txt && CoCoPi-menu-Utilities-DriveEmu.sh;;
        10) nano $HOME/source/fujinet-pc-CoCo/build/dist/fnconfig.ini && CoCoPi-menu-Utilities-DriveEmu.sh;;
        11) start-Lemma.sh && CoCoPi-menu-Utilities-DriveEmu.sh;;
        12) stop-Lemma.sh && CoCoPi-menu-Utilities-DriveEmu.sh;;
        13) $HOME/lwwire/startlwwire.sh && CoCoPi-menu-Utilities-DriveEmu.sh;;
        14) $HOME/lwwire/stoplwwire.sh && CoCoPi-menu-Utilities-DriveEmu.sh;;
        15) $HOME/lwwire/edit-tcpserv.sh && CoCoPi-menu-Utilities-DriveEmu.sh;;
        16) $HOME/emceed/start_emceed.sh && CoCoPi-menu-Utilities-DriveEmu.sh;;
        17) $HOME/emceed/stop_emceed.sh && CoCoPi-menu-Utilities-DriveEmu.sh;;
        18) rebootRPi.sh;;
        19) shutdownRPi.sh;;
        20) CoCoPi-menu-Utilities.sh;;
        21) menu;;
        *) echo "Quitting...";;
    esac
