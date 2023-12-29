#!/bin/bash


if [ ! -d $HOME/CoCo-Pi-Installer ]; then
	mkdir $HOME/CoCo-Pi-Installer
fi

cd $HOME/CoCo-Pi-Installer

# remove previous files if they exist
if [ -f select-project-build-scripts.tar.gz ]; then
	rm select-project-build-scripts.tar.gz
fi


if [ -f scripts.tar.gz ]; then
	rm scripts.tar.gz
fi


if [ -f Pictures.tar.gz ]; then
	rm Pictures.tar.gz
fi


if [ -f Desktop.tar.gz ]; then
	rm Desktop.tar.gz
fi


if [ -f fonts.tar.gz ]; then
	rm fonts.tar.gz
fi


if [ -f mame-menus.tar.gz ]; then
	rm mame-menus.tar.gz
fi


if [ -f xroar-menus.tar.gz ]; then
	rm xroar-menus.tar.gz
fi


if [ -f trs80gp-menus.tar.gz ]; then
	rm trs80gp-menus.tar.gz
fi


if [ -f misc-files.tar.gz ]; then
	rm misc-files.tar.gz
fi


if [ -f source.tar.gz ]; then
	rm source.tar.gz
fi


# create new files
tar czvf select-project-build-scripts.tar.gz /home/pi/scripts/select-project-build.sh /home/pi/source/CoCo-Pi-apt-packages-to-install.sh /home/pi/source/make-*.sh
tar czvf scripts.tar.gz /home/pi/scripts
tar czvf Pictures.tar.gz /home/pi/Pictures
tar czvf Desktop.tar.gz /home/pi/Desktop
tar czvf fonts.tar.gz /home/pi/.fonts

tar czvf mame-menus.tar.gz /home/pi/.mame
tar czvf xroar-menus.tar.gz /home/pi/.xroar
tar czvf trs80gp-menus.tar.gz /home/pi/.trs80gp

tar czvf misc-files.tar.gz /etc/samba/smb.conf /home/pi/.vim /home/pi/.wgetrc /home/pi/.config/geany/geany.conf /home/pi/.config/geany/filedefs /home/pi/pyDriveWire/config/pydrivewirerc-daemon /home/pi/pyDriveWire/*.sh /home/pi/DriveWire4/*.sh /home/pi/DriveWire4/config.xml
tar czvf source.tar.gz /home/pi/source/new_windows.zip /media/share1/source

# capture .bashrc modifications for CoCo-Pi
grep -A500 -m1 -e 'modifications' $HOME/.bashrc > ./bashrc-cocopi.txt


if [ -f $HOME/cocopi-release.txt ]; then
	cp $HOME/cocopi-release.txt ./
fi

echo
echo
echo Done!
echo

