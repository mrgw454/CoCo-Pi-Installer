    clear
    RETVAL=$(whiptail --title "$(cat $HOME/cocopi-release.txt) $(cat $HOME/rpi-model.txt)" \
    --menu "\nPlease select from the following:" 18 70 10 \
    "1"  "System Status" \
    "2" "Select    MAME version" \
    "3" "Select    XRoar version" \
    "4" "Edit      optional MAME parameters (CAUTION)" \
    "5" "Edit      optional XRoar parameters (CAUTION)" \
    "6" "Toggle    MAME ini file usage" \
    "7" "Edit      WiFi configuration (RPi only!)" \
    "8" "Adjust    RPi audio volume (RPi only!)" \
    "9" "Test      Bluetooth/USB Game Controller" \
    "10" "Run       Raspi-Config Script (RPi only!)" \
    "11" "Edit      /boot/firmware/config.txt (RPi only!)" \
    "12" "Show      Existing Bluetooth Pairing(s)" \
    "13" "Backup    Existing Bluetooth Pairing(s)" \
    "14" "Restore   Bluetooth Pairing(s) from Archive" \
    "15" "Show      Existing Emulator Configuration File(s)" \
    "16" "Backup    Existing Emulator Configuration File(s)" \
    "17" "Restore   Emulator Configuration File(s) from Archive" \
    "18" "Update    CoCo-Pi from git repo" \
    "19" "Run       CoCo-Pi fix script" \
    "20" "Install   MAME  package file" \
    "21" "Install   XRoar package file" \
    "22" "Install   OVCC package file" \
    "23" "Update    MAME software HASH file for CoCo" \
    "24" "Toggle    Raspberry PI config.txt updates" \
    "25" "Reboot    Raspberry Pi" \
    "26" "Shutdown  Raspberry Pi" \
    "27" "Return to Utilities Menu" \
    "28" "Return to Main Menu" \
    3>&1 1>&2 2>&3)

    # Below you can enter the corresponding commands

    case $RETVAL in
        1) status.sh && CoCoPi-menu-Utilities-Administration.sh;;
        2) select-emu.sh && CoCoPi-menu-Utilities-Administration.sh;;
        3) select-xroar.sh && CoCoPi-menu-Utilities-Administration.sh;;
        4) editMAMEparms.sh && CoCoPi-menu-Utilities-Administration.sh;;
        5) editXROARparms.sh && CoCoPi-menu-Utilities-Administration.sh;;
        6) toggleMAMEini.sh && CoCoPi-menu-Utilities-Administration.sh;;
        7) editWiFi.sh && CoCoPi-menu-Utilities-Administration.sh;;
        8) adjustVol.sh && CoCoPi-menu-Utilities-Administration.sh ;;
        9) test-controller.sh && CoCoPi-menu-Utilities-Administration.sh;;
        10) runRaspiConfig.sh && CoCoPi-menu-Utilities-Administration.sh;;
        11) editConfig-txt.sh && CoCoPi-menu-Utilities-Administration.sh;;
        12) showBluetoothPairings.sh && CoCoPi-menu-Utilities-Administration.sh;;
        13) backupBluetoothPairings.sh && CoCoPi-menu-Utilities-Administration.sh;;
        14) restoreBluetoothPairings.sh && CoCoPi-menu-Utilities-Administration.sh;;
        15) showEMUConfigs.sh && CoCoPi-menu-Utilities-Administration.sh;;
        16) backupEMUConfigs.sh && CoCoPi-menu-Utilities-Administration.sh;;
        17) restoreEMUConfigs.sh && CoCoPi-menu-Utilities-Administration.sh;;
        18) updateCoCo-Pi-Installer.sh && CoCoPi-menu-Utilities-Administration.sh;;
        19) fix-cocopi.sh && CoCoPi-menu-Utilities-Administration.sh;;
        20) installMAMEpackage.sh && CoCoPi-menu-Utilities-Administration.sh;;
        21) installXRoarpackage.sh && CoCoPi-menu-Utilities-Administration.sh;;
        22) installOVCCpackage.sh && CoCoPi-menu-Utilities-Administration.sh;;
        23) updateMAME-hash-CoCo.sh && CoCoPi-menu-Utilities-Administration.sh;;
        24) toggleRpiConfigUpdate.sh && CoCoPi-menu-Utilities-Administration.sh;;
        25) rebootRPi.sh;;
        26) shutdownRPi.sh;;
        27) CoCoPi-menu-Utilities.sh;;
        28) menu;;
        *) echo "Quitting...";;
    esac
