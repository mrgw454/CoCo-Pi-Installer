#!/bin/bash

cd $HOME/source

# if a previous fujinet-firmware-CoCo folder exists, move into a date-time named folder

if [ -d "fujinet-firmware-CoCo" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "fujinet-firmware-CoCo" "fujinet-firmware-CoCo-$foldername"

        echo -e Archiving existing fujinet-firmware-CoCo folder ["fujinet-firmware-CoCo"] into backup folder ["fujinet-firmware-CoCo-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/FujiNetWIFI/fujinet-firmware
git clone https://github.com/FujiNetWIFI/fujinet-firmware.git fujinet-firmware-CoCo

cd fujinet-firmware-CoCo

GITREV=`git rev-parse --short HEAD`

export PATH=/usr/bin:$PATH:$HOME/.platformio/penv/bin

cp platformio-sample.ini platformio.ini

sed -i 's|;build_platform = BUILD_COCO|build_platform = BUILD_COCO|' platformio.ini
sed -i 's|;build_bus      = DRIVEWIRE|build_bus      = DRIVEWIRE|' platformio.ini
sed -i 's|;fujinet-coco-devkitc      ; Color Computer Drivewire using ESP32-DEVKITC-VE|fujinet-coco-devkitc      ; Color Computer Drivewire using ESP32-DEVKITC-VE|' platformio.ini
sed -i 's|/dev/ttyUSB0|/dev/ttyUSB1|' platformio.ini

./build.sh -s fujinet-coco-devkitc

# normal build
#./build.sh -b

# build zip package
./build.sh -z

if [ $? -eq 0 ]
then
        echo "Building of firmware was successful."
        echo
else
        echo "Building of firmware was NOT successful.  Aborting."
        echo
        exit 1
fi

cd $HOME/source


echo
echo Done!
