    clear
export COCOPI_MENU_CALLER="${BASH_SOURCE[0]}"
    RETVAL=$(whiptail --title "$(cat $HOME/cocopi-release.txt) $(cat $HOME/rpi-model.txt)" \
    --menu "\nPlease select from the following:" 18 75 10 \
    "1" "Tandy Color Computer 3 DECB" \
    "2" "Tandy Color Computer 3 DECB w/6309,2MB" \
    "3" "Tandy Color Computer 3 DECB w/SSC & MPI" \
    "4" "Tandy Color Computer 3 DECB w/GMC & MPI" \
    "5" "Tandy Color Computer 3 DECB w/X-SID & MPI" \
    "6" "Tandy Color Computer 3 ECB  w/GMC" \
    "7" "Tandy Color Computer 3 DECB w/6309 & ORCH90" \
    "8" "Tandy Color Computer 3 DECB w/Deluxe RS-232 Pak" \
    "9" "Tandy Color Computer 3 HDB-DOS" \
    "10" "Tandy Color Computer 3 HDB-DOS w/6309" \
    "11" "Tandy Color Computer 3 HDB-DOS w/6309,2MB & NitrOS9 EOU" \
    "12" "Tandy Color Computer 3 HDB-DOS w/6309,2MB,Fuzix & pyDW" \
    "13" "Tandy Color Computer 3 HDB-DOS w/6309,2MB,Fuzix & lwwire" \
    "14" "Tandy Color Computer 3 HDB-DOS w/6309,2MB,Fuzix & HDD" \
    "15" "Tandy Color Computer 3 HDB-DOS w/PLATO" \
    "16" "Tandy Color Computer 3 YA-DOS w/HDD" \
    "17" "Tandy Color Computer 3 YA-DOS w/6309,2MB & HDD" \
    "18" "Tandy Color Computer 3 HDB-DOS w/6309,2MB & NitrOS9 EOU (IDE)" \
    "19" "Tandy Color Computer 3 ECB w/128KB" \
    "20" "Return to Main Menu" \
    3>&1 1>&2 2>&3)

    # Below you can enter the corresponding commands

    case $RETVAL in
        1) coco3-decb.sh;;
        2) coco3-decb-6309-2MB.sh;;
        3) coco3-decb-ssc-mpi.sh;;
        4) coco3-decb-gmc-mpi.sh;;
        5) coco3-decb-xsid-mpi.sh;;
        6) coco3-ecb-gamemaster.sh;;
	7) coco3-decb-6309-ORCH90.sh;;
        8) coco3-decb-term.sh;;
        9) coco3-hdbdos.sh;;
       10) coco3-hdbdos-6309.sh;;
       11) coco3-hdbdos-6309-nitros9.sh;;
       12) coco3-Fuzix-pyDW.sh;;
       13) coco3-Fuzix-lwwire.sh;;
       14) coco3-Fuzix-HDD.sh;;
       15) coco3-hdbdos-pyDW-PLATO.sh;;
       16) coco3-yados-HD-mpi.sh;;
       17) coco3-yados-HD-6309-mpi.sh;;
       18) coco3-hdbdos-6309-nitros9-ide.sh;;
       19) coco3-ecb.sh;;
       20) menu;;
        *) echo "Quitting...";;
    esac
