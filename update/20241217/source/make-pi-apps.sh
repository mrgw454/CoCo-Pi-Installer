#!/bin/bash

systemtype=$(dpkg --print-architecture)
echo architecture = $systemtype

if [[ $systemtype != arm64 ]];then
        echo This project is not compatible with your device platform.  Aborting.
        echo
        echo
        exit 1
fi

cd $HOME

# if a previous pi-apps folder exists, move into a date-time named folder

if [ -d "pi-apps" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "pi-apps" "pi-apps-$foldername"

        echo -e Archiving existing pi-apps folder ["pi-apps"] into backup folder ["pi-apps-$foldername"]
        echo -e
        echo -e
fi

# https://pi-apps.io/
# https://pi-apps.io/install/
git clone https://github.com/Botspot/pi-apps && ~/pi-apps/install

echo
echo Done!

