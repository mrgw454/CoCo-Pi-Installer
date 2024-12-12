#!/bin/bash

# install prerequisites
sudo apt install python3-venv python3-distutils python3-jinja2 libexpat1-dev libmbedtls-dev libbsd-dev python3-importlib-resources python3-importlib-metadata doxygen graphviz libargtable2-dev

cd $HOME/source

# if a previous fujinet-pc-CoCo-three folder exists, move into a date-time named folder

if [ -d "fujinet-pc-CoCo-three" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "fujinet-pc-CoCo-three" "fujinet-pc-CoCo-three-$foldername"

        echo -e Archiving existing fujinet-pc-CoCo-three folder ["fujinet-pc-CoCo-three"] into backup folder ["fujinet-pc-CoCo-three-$foldername"]
        echo -e
        echo -e
fi

git clone https://github.com/FujiNetWIFI/fujinet-firmware.git fujinet-pc-CoCo-three

cd fujinet-pc-CoCo-three

# select a commit that still works

# use this for a working BECKER port
git checkout 6960d909

GITREV=`git rev-parse --short HEAD`

if [ ! -f platformio.ini ]; then
	cp platformio-sample.ini platformio.ini
fi

mkdir build

# this allows python3 to be found in PATH first
PATH=/usr/bin:$PATH


if [ ! -f /usr/lib/python3.11/EXTERNALLY-MANAGED.disabled ]; then
        sudo mv /usr/lib/python3.11/EXTERNALLY-MANAGED /usr/lib/python3.11/EXTERNALLY-MANAGED.disabled
fi

pip3 install abimap

if [ -f /usr/lib/python3.11/EXTERNALLY-MANAGED.disabled ]; then
        sudo mv /usr/lib/python3.11/EXTERNALLY-MANAGED.disabled /usr/lib/python3.11/EXTERNALLY-MANAGED
fi


sed -i '/#!\/usr\/bin\/env bash/a PATH=\/usr\/bin:$PATH' build.sh
sed -i 's/strlcpy/strncpy/' lib/device/drivewire/fuji.cpp

./build.sh -b -p COCO


if [ -f $HOME/source/fujinet-pc-CoCo-three/build/dist/fujinet ]; then
	echo fujinet binary exists.
       	echo
       	echo "Compilation was successful."
	echo
else
	echo fujinet binary does NOT exist!
	echo
	echo "Compilation was NOT successful.  Attempting to run ./build.sh script again..."
        echo

	./build.sh -b -p COCO

	if [ -f $HOME/source/fujinet-pc-CoCo-three/build/dist/fujinet ]; then

		echo fujinet binary exists.
       		echo
       		echo "Compilation was successful."
		echo
	else
		echo fujinet binary does NOT exist!
		echo
		echo "Compilation was NOT successful.  Aborting installation."
        	echo

		exit 1
	fi
fi


# for CoCo 1

echo Creating CoCo 1 folder...
echo

if [ -d $HOME/source/fujinet-pc-CoCo1 ]; then
	rm -r -f $HOME/source/fujinet-pc-CoCo1
fi

cp -r $HOME/source/fujinet-pc-CoCo-three $HOME/source/fujinet-pc-CoCo1

# set SERIAL port parameters
sed -i '1,/port=/s/port=/port=\/dev\/ttyUSB0/' $HOME/source/fujinet-pc-CoCo1/build/dist/fnconfig.ini
sed -i '/port=\/dev\/ttyUSB0/a baud=38400' $HOME/source/fujinet-pc-CoCo1/build/dist/fnconfig.ini

# disable BECKER port
sed -i '/[BOIP]/{n; s/enabled=1/enabled=0/}' $HOME/source/fujinet-pc-CoCo1/build/dist/fnconfig.ini

echo
echo



# for CoCo 2

echo Creating CoCo 2 folder...
echo

if [ -d $HOME/source/fujinet-pc-CoCo1 ]; then
	rm -r -f $HOME/source/fujinet-pc-CoCo2
fi

cp -r $HOME/source/fujinet-pc-CoCo-three $HOME/source/fujinet-pc-CoCo2

# set SERIAL port parameters
sed -i '1,/port=/s/port=/port=\/dev\/ttyUSB2/' $HOME/source/fujinet-pc-CoCo2/build/dist/fnconfig.ini
sed -i '/port=\/dev\/ttyUSB2/a baud=57600' $HOME/source/fujinet-pc-CoCo2/build/dist/fnconfig.ini

# disable BECKER port
sed -i '/[BOIP]/{n; s/enabled=1/enabled=0/}' $HOME/source/fujinet-pc-CoCo2/build/dist/fnconfig.ini

echo
echo



# for CoCo 3

echo Creating CoCo 3 folder...
echo

if [ -d $HOME/source/fujinet-pc-CoCo1 ]; then
	rm -r -f $HOME/source/fujinet-pc-CoCo3
fi

cp -r $HOME/source/fujinet-pc-CoCo-three $HOME/source/fujinet-pc-CoCo3

# set SERIAL port parameters
sed -i '1,/port=/s/port=/port=\/dev\/ttyUSB1/' $HOME/source/fujinet-pc-CoCo3/build/dist/fnconfig.ini
sed -i '/port=\/dev\/ttyUSB1/a baud=115200' $HOME/source/fujinet-pc-CoCo3/build/dist/fnconfig.ini

# disable BECKER port
sed -i '/[BOIP]/{n; s/enabled=1/enabled=0/}' $HOME/source/fujinet-pc-CoCo3/build/dist/fnconfig.ini

echo
echo


cd ..


echo
echo Done!
