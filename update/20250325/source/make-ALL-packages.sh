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
./make-asm6809.sh
./make-binutils-gdb.sh
./make-6809dasm.sh
./make-f9dasm.sh
./make-dasm.sh
./make-A09.sh
./make-motorola-6800-assembler.sh
./make-naken-asm.sh
./make-as02.sh
./make-as09.sh
./make-vasm6809.sh
./make-crasm.sh
./make-asl.sh

# file system tools
./make-toolshed.sh
./make-bin2cas.sh
./make-cas2wav.sh
./make-conv-tools.sh
./make-cocofs.sh
./make-file2dsk.sh
./make-mc6801-tools.sh
./make-dmk2sdf.sh
./make-seer.sh

# C compilers
./make-gcc6809.sh
./make-CMOC.sh
./make-vbcc.sh

# BASIC tools
./make-basic_utils.beta.sh
./make-decb-tools.sh

# compression utilties
./make-dzip.sh
./make-lzsa.sh
./make-mlbr.sh

# bios rom files
./make-coco_roms.sh

# mc-10
./make-CC6303.sh
./make-mcbasic.sh
./make-tasm6801.sh
./make-trs-mc10.sh

# BASIC compilers
./make-fbc.sh
./make-qb64.sh
./make-QB64pe.sh
./make-ugBasic-beta.sh
./make-ugBasic.sh
./make-Squanchy-BASIC.sh
./make-as9.sh
./make-cc65.sh
./make-BASIC-To-6809.sh
./make-preprocessor.sh

# development librarires
./make-CROSSLIB-coco.sh
./make-dynosprite.sh

# IDE editor
./make-geany.sh
./make-sgeditremix.sh
./make-nanorc.sh
./make-basic_renumber.sh

# storage emulators
./make-DriveWire.sh
./make-pyDriveWire.sh
./make-dload_server.sh
./make-tnfsd.sh
./make-lwwire.sh
./make-tcpser.sh
./make-fujinet-apps.sh
./make-fujinet-pc-CoCo.sh

# terminal programs
./make-DwTermMc10.sh
./make-DwTerm.sh
./make-platotermCoCo.sh
./make-h19term.sh

# emulators
./make-xroar.sh
./make-trs80gp.sh
./make-libagar.sh
./make-ovcc.sh
./make-sim6809.sh
./make-mc-10.sh
./make-dosbox.sh
./make-RunCPM.sh
./make-online6809.sh
#./make-mame.sh
./make-MC6809.sh
./make-DragonPy.sh

# floppy tools
./make-flashfloppy.sh
./make-greaseweazle.sh
./make-hxcfloppyemulator.sh
./make-dmk2sdf-n6il.sh

# other apps
./make-Image2CoCo3.sh
./make-vgmplay.sh
./make-Apple2CoCo.sh
./make-VideoTexDemoServer.sh

# CoCo programs source code
./make-daftspanielcoco3.sh
./make-RetroCornerRedux.sh


# add this GOTO tag to match command above
#GOTO_1


# CoCo games
./make-3dMonsterMaze.sh
./make-CoCo-Flood-It.sh
./make-cocole.sh
./make-CoCoWumpus.sh
./make-templeofrom.sh
./make-coco3-jaggies.sh
./make-CoCoFun.sh
./make-cocolife.sh
./make-ROTB.sh
./make-Run-Dino-Run.sh
./make-space-bandits.sh
./make-Star-Spores_CoCo.sh
./make-xdaliclock.sh

# CoCo diagnostics utilities
./make-bogomips.sh
./make-chart.sh
./make-CoCo3_MemTest2023.sh
./make-cocorx.sh
./make-coremark.sh
./make-gime-mmutest.sh
./make-HiRes-Interface-Test.sh
./make-cocostress.sh
./make-dragon-refresh-test.sh
./make-ramchk64.sh

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
echo Done!
echo
