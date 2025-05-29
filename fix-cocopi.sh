#!/bin/bash

clear

echo "This script will resolve any minor issues that need to be addressed for the CoCo-Pi distribution."
echo
read -p "Press any key to continue or [CTRL-C] to abort..." -n1 -s
echo
echo

backupdate=$(date +"%Y%m%d_%H%M%S")

if [ -e "$HOME/update/.fix-cocopi-skip-config-clobber" ]; then
        echo "Skipping update of /boot/config.txt - If you want this update then go to the Utilities->Administration menu and select Toggle Raspberry PI config.txt updates"
        echo
        read -p "Press any key to continue... " -n1 -s
        echo
else

        # detect model of Raspberry Pi
        RPI=`cat /proc/device-tree/model | cut -c14-16`

        if [[ "$RPI" == "5 M" ]]; then
        #sudo cp /home/pi/update/config.txt.RPi5 /boot/config.txt
        echo

        fi

        if [ "$RPI" == "400" ]; then
        #sudo cp /home/pi/update/config.txt.RPi400 /boot/config.txt
        echo

	fi

        if [ "$RPI" == "500" ]; then
        #sudo cp /home/pi/update/config.txt.RPi500 /boot/config.txt
        echo

        fi

        if [ "$RPI" == "4 M" ]; then

        #sudo cp /home/pi/update/config.txt.RPi4 /boot/config.txt
        echo

        fi

        if [ "$RPI" == "3 M" ]; then

        #sudo cp /home/pi/update/config.txt.RPi3 /boot/config.txt
        echo

        fi

fi


echo

# create new link to fix-cocopi.sh script
if [ -f $HOME/scripts/fix-cocopi.sh ]; then
        rm $HOME/scripts/fix-cocopi.sh
fi

if [ -L $HOME/scripts/fix-cocopi.sh ]; then
        rm $HOME/scripts/fix-cocopi.sh
fi

ln -s $HOME/CoCo-Pi-Installer/fix-cocopi.sh $HOME/scripts/fix-cocopi.sh


# set hotfixes file
file="$HOME/update/cocopi-fixes.txt"
# create the file if it doesn't exist
touch $file


# example placeholder
# check for fix
#fix="fix-20231023-01"
#if grep -q "$fix" $file; then
#    echo fix $fix already complete.
#    echo
#else
#    echo Applying fix $fix...
#    echo
#    tar xzf /home/pi/update/sdboot-git-20231022-CoCoPi.tar.gz -C /

#    cd $HOME

#    echo "$fix" >>$file
#    echo
#fi

# check for fix
fix="fix-20241212-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

	cp $HOME/CoCo-Pi-Installer/update/20241212/.mame/* $HOME/.mame
	cp $HOME/CoCo-Pi-Installer/update/20241212/source/* $HOME/source

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20241212-02"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

	cp $HOME/CoCo-Pi-Installer/update/20241212/source/make-all-ugBasic* $HOME/source

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20241212-03"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

	cp $HOME/CoCo-Pi-Installer/update/20241212/.mame/CoCoPi-menu-Utilities-Administration.sh $HOME/.mame

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20241217-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

	cp $HOME/CoCo-Pi-Installer/update/20241217/.mame/CoCoPi-menu-Coco2-trs80gp.sh $HOME/.mame
	cp $HOME/CoCo-Pi-Installer/update/20241217/scripts/start-FujiNet-server-CoCo-Becker.sh $HOME/scripts
	cp $HOME/CoCo-Pi-Installer/update/20241217/source/make-pi-apps.sh $HOME/source
	cp $HOME/CoCo-Pi-Installer/update/20241217/.trs80gp/coco2-hdbdos-trs80gp.sh $HOME/.trs80gp

	if [ -f $HOME/Desktop/pi-apps.desktop ]; then
		rm $HOME/Desktop/pi-apps.desktop
	fi

	if [ -f /etc/apt/sources.list.d/d-apt.list ]; then
		sudo rm /etc/apt/sources.list.d/d-apt.list
		sudo nala update
	fi

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20241217-02"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20241217/source/make-trs80gp.sh $HOME/source

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20241219-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20241219/source/make-fip-FUZIX.sh $HOME/source
    cp $HOME/CoCo-Pi-Installer/update/20241219/source/make-FUZIX-coco3.sh $HOME/source

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20241220-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20241220/.mame/CoCoPi-menu-MC10-XRoar.sh $HOME/.mame
    cp $HOME/CoCo-Pi-Installer/update/20241220/.xroar/mc-10-128k-xroar.sh $HOME/.xroar
    cp $HOME/CoCo-Pi-Installer/update/20241220/roms/mcx128.rom /media/share1/roms

    cp $HOME/CoCo-Pi-Installer/update/20241220/scripts/CoCoPi-menu-Coco2-trs80gp-z2.sh $HOME/scripts
    cp $HOME/CoCo-Pi-Installer/update/20241220/scripts/CoCoPi-menu-MC10-XRoar-z2.sh $HOME/scripts

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20241228-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20241228/.mame/* $HOME/.mame
    cp $HOME/CoCo-Pi-Installer/update/20241228/source/* $HOME/source
    cp $HOME/CoCo-Pi-Installer/update/20241228/.xroar/* $HOME/.xroar

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20241229-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20241229/.mame/* $HOME/.mame
    cp $HOME/CoCo-Pi-Installer/update/20241229/source/* $HOME/source
    cp $HOME/CoCo-Pi-Installer/update/20241229/.xroar/* $HOME/.xroar

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20241230-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20241230/source/* $HOME/source

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20241231-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20241231/source/* $HOME/source

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250101-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250101/source/* $HOME/source
    cp $HOME/CoCo-Pi-Installer/update/20250101/.xroar/* $HOME/.xroar

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250102-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250102/.mame/* $HOME/.mame
    cp $HOME/CoCo-Pi-Installer/update/20250102/.xroar/* $HOME/.xroar

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250103-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250103/source/* $HOME/source
    cp -r $HOME/CoCo-Pi-Installer/update/20250103/Desktop $HOME
    cp $HOME/CoCo-Pi-Installer/update/20250103/.xroar/* $HOME/.xroar

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250115-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250115/source/* $HOME/source

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250122-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250122/.mame/* $HOME/.mame

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250123-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250123/source/* $HOME/source

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250124-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250124/source/* $HOME/source

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250210-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250210/source/* $HOME/source
    cp $HOME/CoCo-Pi-Installer/update/20250210/scripts/* $HOME/scripts

    sudo apt -y install hexedit wxhexeditor hexyl ghex

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250212-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250212/source/* $HOME/source

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250220-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250220/source/* $HOME/source
    cp $HOME/CoCo-Pi-Installer/update/20250220/scripts/* $HOME/scripts

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250303-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250303/.bashrc $HOME
    cp $HOME/CoCo-Pi-Installer/update/20250303/source/*.sh $HOME/source

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250310-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250310/scripts/*.sh $HOME/scripts
    cp $HOME/CoCo-Pi-Installer/update/20250310/source/*.sh $HOME/source
    cp $HOME/CoCo-Pi-Installer/update/20250310/.config/geany/filedefs/*.* $HOME/.config/geany/filedefs

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250311-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250311/scripts/*.sh $HOME/scripts

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250312-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250312/scripts/*.sh $HOME/scripts
	cp $HOME/CoCo-Pi-Installer/update/20250312/.config/geany/filedefs/*.* $HOME/.config/geany/filedefs
	
	sed -i 's|run_in_vte=false|run_in_vte=true|' $HOME/.config/geany/geany.conf

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250325-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250325/scripts/*.sh $HOME/scripts
	cp $HOME/CoCo-Pi-Installer/update/20250325/source/*.sh $HOME/source

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250330-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250330/scripts/*.sh $HOME/scripts
    cp $HOME/CoCo-Pi-Installer/update/20250330/source/*.sh $HOME/source

    if [ ! -d $HOME/.config/geany/colorschemes ]; then
    	mkdir -p $HOME/.config/geany/colorschemes
    fi

    cp $HOME/CoCo-Pi-Installer/update/20250330/.config/geany/colorschemes/*.conf $HOME/.config/geany/colorschemes

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250430-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250430/scripts/*.sh $HOME/scripts
    cp $HOME/CoCo-Pi-Installer/update/20250430/source/*.sh $HOME/source
    cp $HOME/CoCo-Pi-Installer/update/20250430/Pictures/*.* $HOME/Pictures

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250430-02"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250430/scripts/downloadUltimateSDC.sh $HOME/scripts

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250519-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250519/scripts/*.sh $HOME/scripts
    cp $HOME/CoCo-Pi-Installer/update/20250519/source/*.sh $HOME/source
    cp $HOME/CoCo-Pi-Installer/update/20250519/Pictures/*.* $HOME/Pictures

    cd $HOME

    echo "$fix" >>$file
    echo
fi


# check for fix
fix="fix-20250529-01"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo

    cp $HOME/CoCo-Pi-Installer/update/20250529/scripts/*.sh $HOME/scripts
    cp $HOME/CoCo-Pi-Installer/update/20250529/source/*.sh $HOME/source

    cd $HOME

    echo "$fix" >>$file
    echo
fi


echo
echo
echo Please reboot as soon as possible so all updates can be applied.  Thank you.
echo
read -p "Press any key to continue... " -n1 -s

echo
echo Done!
echo
