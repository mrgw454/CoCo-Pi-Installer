#!/bin/bash

cd $HOME/source

# if a previous trs80gp folder exists, move into a date-time named folder

if [ -d "trs80gp" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "trs80gp" "trs80gp-$foldername"

        echo -e Archiving existing trs80gp folder ["trs80gp"] into backup folder ["trs80gp-$foldername"]
        echo -e
        echo -e
fi

if [ ! -d trs80gp ]; then
	mkdir trs80gp
fi

cd trs80gp

# http://48k.ca/trs80gp.html
wget http://48k.ca/trs80gp-latest.zip

systemtype=$(dpkg --print-architecture)
echo architecture = $systemtype

if [[ $systemtype =~ arm64 ]];then
	unzip -j trs80gp-latest.zip rpi-64/trs80gp
fi


if [[ $systemtype =~ amd64 ]];then
	unzip -j trs80gp-latest.zip linux-64/trs80gp
fi


if [ -f trs80gp ]; then
       	sudo cp trs80gp /usr/local/bin
else
       	echo trs80gp binary not found!
       	echo
fi

cd ..

echo
echo Done!
