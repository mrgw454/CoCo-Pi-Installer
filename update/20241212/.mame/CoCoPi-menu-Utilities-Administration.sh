    clear
    RETVAL=$(whiptail --title "$(cat $HOME/cocopi-release.txt) $(cat $HOME/rpi-model.txt)" \
    --menu "\nPlease select from the following:" 18 70 10 \
    "1"  "System Status" \
    "2" "Select    MAME version" \
    "3" "Select    XRoar version" \
    "4" "Edit      optional MAME parameters (CAUTION)" \
    "5" "Edit      optional XRoar parameters (CAUTION)" \
    "6" "Toggle    MAME ini file usage" \
    "7" "Edit      WiFi configuration" \
    "8" "Adjust    RPi audio volume" \
    "9" "Test      Bluetooth/USB Game Controller" \
    "10" "Run       Raspi-Config Script" \
    "11" "Edit      /boot/config.txt (DANGEROUS)" \
    "12" "Enable    Overlock Raspberry Pi (DANGEROUS)" \
    "13" "Show      Existing Bluetooth Pairing(s)" \
    "14" "Backup    Existing Bluetooth Pairing(s)" \
    "15" "Restore   Bluetooth Pairing(s) from Archive" \
    "16" "Show      Existing Emulator Configuration File(s)" \
    "17" "Backup    Existing Emulator Configuration File(s)" \
    "18" "Restore   Emulator Configuration File(s) from Archive" \
    "19" "Backup    RPi to alternate SD card" \
    "20" "Update    CoCo-Pi from git repo" \
    "21" "Run       CoCo-Pi fix script" \
    "22" "Install   MAME  package file" \
    "23" "Install   XRoar package file" \
    "24" "Install   OVCC package file" \
    "25" "Update    MAME software HASH file for CoCo" \
    "26" "Toggle    Raspberry PI config.txt updates" \
    "27" "Reboot    Raspberry Pi" \
    "28" "Shutdown  Raspberry Pi" \
    "29" "Return to Utilities Menu" \
    "30" "Return to Main Menu" \
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
        12) overlock-cocopi.sh && CoCoPi-menu-Utilities-Administration.sh;;
        13) showBluetoothPairings.sh && CoCoPi-menu-Utilities-Administration.sh;;
        14) backupBluetoothPairings.sh && CoCoPi-menu-Utilities-Administration.sh;;
        15) restoreBluetoothPairings.sh && CoCoPi-menu-Utilities-Administration.sh;;
        16) showEMUConfigs.sh && CoCoPi-menu-Utilities-Administration.sh;;
        17) backupEMUConfigs.sh && CoCoPi-menu-Utilities-Administration.sh;;
        18) restoreEMUConfigs.sh && CoCoPi-menu-Utilities-Administration.sh;;
        19) backupSD.sh && CoCoPi-menu-Utilities-Administration.sh;;
        20) updateCoCo-Pi-Installer.sh && CoCoPi-menu-Utilities-Administration.sh;;
        21) fix-cocopi.sh && CoCoPi-menu-Utilities-Administration.sh;;
        22) installMAMEpackage.sh && CoCoPi-menu-Utilities-Administration.sh;;
        23) installXRoarpackage.sh && CoCoPi-menu-Utilities-Administration.sh;;
        24) installOVCCpackage.sh && CoCoPi-menu-Utilities-Administration.sh;;
        25) updateMAME-hash-CoCo.sh && CoCoPi-menu-Utilities-Administration.sh;;
        26) toggleRpiConfigUpdate.sh && CoCoPi-menu-Utilities-Administration.sh;;
        27) rebootRPi.sh;;
        28) shutdownRPi.sh;;
        29) CoCoPi-menu-Utilities.sh;;
        30) menu;;
        *) echo "Quitting...";;
    esac
