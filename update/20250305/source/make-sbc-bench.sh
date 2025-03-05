#!/bin/bash

systemtype=$(dpkg --print-architecture)
echo architecture = $systemtype

if [[ $systemtype != arm64 ]];then
        echo This project is not compatible with your device platform.  Aborting.
        echo
        echo
        exit 1
fi

cd $HOME/source

# if a previous sbc-bench folder exists, move into a date-time named folder

if [ -d "sbc-bench" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "sbc-bench" "sbc-bench-$foldername"

        echo -e Archiving existing sbc-bench folder ["sbc-bench"] into backup folder ["sbc-bench-$foldername"]
        echo -e
        echo -e
fi


# https://github.com/ThomasKaiser/sbc-bench
git clone https://github.com/ThomasKaiser/sbc-bench.git

cd sbc-bench

GITREV=`git rev-parse --short HEAD`

chmod a+x *.sh


cd ..


echo
echo Done!
