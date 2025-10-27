#!/bin/bash

# run script below to see what individual make-*.sh scripts may be missing from this one
# $HOME/compare-package-scripts.sh

# add this as a GOTO type function
#cat >/dev/null <<GOTO_1

clear

echo "WARNING!  This batch build script for packages can take a very long time to complete"
echo "(depending on host system capabilities and performance)"
echo
echo "press [CTRL]-[C] to cancel or"
echo
read -p "Press any key to continue... " -n1 -s
echo

# assemblers disassemblers
./make-lwtools.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-asm6809.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-binutils-gdb.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-6809dasm.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-f9dasm.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-dasm.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-A09.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-motorola-6800-assembler.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-naken-asm.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-as02.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-as09.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-vasm6809.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-crasm.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-asl.sh
echo
read -p "Press any key to continue... " -n1 -s
echo

# file system tools
./make-toolshed.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-bin2cas.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-cas2wav.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-conv-tools.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-cocofs.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-file2dsk.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-mc6801-tools.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-dmk2sdf.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-seer.sh
echo
read -p "Press any key to continue... " -n1 -s
echo

# C compilers
./make-gcc6809.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-CMOC.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-vbcc.sh
echo
read -p "Press any key to continue... " -n1 -s
echo

# BASIC tools
./make-basic_utils.beta.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-decb-tools.sh
echo
read -p "Press any key to continue... " -n1 -s
echo

# compression utilties
./make-dzip.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-lzsa.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-mlbr.sh
echo
read -p "Press any key to continue... " -n1 -s
echo

# bios rom files
./make-coco_roms.sh
echo
read -p "Press any key to continue... " -n1 -s
echo

# mc-10
./make-CC6303.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-mcbasic.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-tasm6801.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-trs-mc10.sh
echo
read -p "Press any key to continue... " -n1 -s
echo

# BASIC compilers
./make-fbc.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
#./make-qb64.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-QB64pe.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-ugBasic-beta.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-ugBasic.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-Squanchy-BASIC.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-as9.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-cc65.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
#./make-BASIC-To-6809.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-preprocessor.sh
echo
read -p "Press any key to continue... " -n1 -s
echo

# development librarires
#./make-CROSSLIB.sh
#./make-dynosprite.sh

# IDE editor
#./make-geany.sh
./make-sgeditremix.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-nanorc.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-basic_renumber.sh
echo
read -p "Press any key to continue... " -n1 -s
echo

# storage emulators
./make-DriveWire.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-pyDriveWire-python3.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-dload_server.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
#./make-tnfsd.sh
./make-lwwire.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-tcpser.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
.#/make-fujinet-apps.sh

# terminal programs
./make-DwTermMc10.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-DwTerm.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-platotermCoCo.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
#./make-h19term.sh

# emulators
./make-xroar.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-trs80gp.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-libagar.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-ovcc.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-sim6809.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-mc-10.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-dosbox.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-RunCPM.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-online6809.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
#./make-mame.sh
./make-MC6809.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-DragonPy.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-coco-gorsat.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-6809-gorsat.sh
echo
read -p "Press any key to continue... " -n1 -s
echo

# floppy tools
./make-flashfloppy.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-greaseweazle.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-hxcfloppyemulator.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-dmk2sdf-n6il.sh
echo
read -p "Press any key to continue... " -n1 -s
echo

# other apps
./make-Image2CoCo3.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-vgmplay.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-Apple2CoCo.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-VideoTexDemoServer.sh
echo
read -p "Press any key to continue... " -n1 -s
echo

# CoCo programs source code
./make-daftspanielcoco3.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-RetroCornerRedux.sh
echo
read -p "Press any key to continue... " -n1 -s
echo


# add this GOTO tag to match command above
#GOTO_1


# CoCo games
./make-3dMonsterMaze.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-CoCo-Flood-It.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-cocole.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-CoCoWumpus.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-templeofrom.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-coco3-jaggies.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-CoCoFun.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-cocolife.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-ROTB.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-Run-Dino-Run.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-space-bandits.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-Star-Spores_CoCo.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-xdaliclock.sh
echo
read -p "Press any key to continue... " -n1 -s
echo

# CoCo diagnostics utilities
./make-bogomips.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-chart.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-CoCo3_MemTest2023.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-cocorx.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-coremark.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-gime-mmutest.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-HiRes-Interface-Test.sh
echo
read -p "Press any key to continue... " -n1 -s
echo
./make-cocostress.sh
echo
read -p "Press any key to continue... " -n1 -s
echo

# NitrOS9
#./make-nitros9-code.sh
#./make-nitros9.sh
#./make-cmoc_os9.sh

# Fuzix
#./make-fip.sh
#./make-FUZIX-coco3.sh

# backup software
#./make-rpi-clone.sh
echo
read -p "Press any key to continue... " -n1 -s
echo

echo
echo Done!
echo
