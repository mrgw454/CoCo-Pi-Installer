#!/bin/bash
clear
export COCOPI_MENU_CALLER="$HOME/scripts/CoCoPi-menu.z3.sh"
TITLE="$(cat $HOME/cocopi-release.txt) $(cat $HOME/rpi-model.txt)"

CHOICE=$(zenity --list \
  --title="$TITLE" \
  --width=700 --height=500 \
  --column="Option" --column="Description" \
  "1" "TRS-80 Color Computer 2 DECB" \
  "2" "TRS-80 Color Computer 2 DECB w/6309" \
  "3" "TRS-80 Color Computer 2 DECB w/SSC & MPI" \
  "4" "TRS-80 Color Computer 2 DECB w/GMC & MPI" \
  "5" "TRS-80 Color Computer 2 DECB w/X-SID & MPI" \
  "6" "TRS-80 Color Computer 2 ECB  w/GMC" \
  "7" "TRS-80 Color Computer 2 DECB w/6309,SSFM & MPI" \
  "8" "TRS-80 Color Computer 2 HDB-DOS" \
  "9" "TRS-80 Color Computer 2 HDB-DOS w/6309" \
  "10" "TRS-80 Color Computer 2 HDB-DOS w/PLATO" \
  "11" "TRS-80 Color Computer 2 YA-DOS w/HDD" \
  "12" "TRS-80 Color Computer 2 YA-DOS w/6309 & HDD" \
  "13" "TRS-80 Color Computer 2 ECB w/64KB" \
  "14" "TRS-80 Color Computer 2 w/FLEX" \
  "15" "TRS-80 Deluxe Color Computer ACB w/64KB" \
  "16" "Return to Main Menu"
)

case $CHOICE in
  "1") coco2-decb.sh;;
  "2") coco2-decb-6309.sh;;
  "3") coco2-decb-ssc-mpi.sh;;
  "4") coco2-decb-gmc-mpi.sh;;
  "5") coco2-decb-xsid-mpi.sh;;
  "6") coco2-ecb-gamemaster.sh;;
  "7") coco2-decb-SSFM-mpi-6309.sh;;
  "8") coco2-hdbdos.sh;;
  "9") coco2-hdbdos-6309.sh;;
  "10") coco2-hdbdos-pyDW-PLATO.sh;;
  "11") coco2-yados-HD-mpi.sh;;
  "12") coco2-yados-HD-6309-mpi.sh;;
  "13") coco2-ecb.sh;;
  "14") coco2-flex.sh;;
  "15") deluxecoco-decb.sh;;
  "16") "$COCOPI_MENU_CALLER";;
  "*") echo "Quitting...";;
  "*") echo "Quitting...";;
esac
