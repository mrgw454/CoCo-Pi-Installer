#!/bin/bash

cd $HOME/source

# if a previous cloud-kingdoms folder exists, move into a date-time named folder

if [ -d "cloud-kingdoms" ]; then

       	foldername=$(date +%Y-%m-%d_%H.%M.%S)

       	mv "cloud-kingdoms" "cloud-kingdoms-$foldername"

       	echo -e Archiving existing cloud-kingdoms folder ["cloud-kingdoms"] into backup folder ["cloud-kingdoms-$foldername"]
       	echo -e
       	echo -e
fi

# https://gitlab.com/cocodev/lee/cloud-kingdoms
git clone https://gitlab.com/cocodev/lee/cloud-kingdoms.git

cd cloud-kingdoms

GITREV=`git rev-parse --short HEAD`

if [ ! -d /media/share1/SDC/PERKINS ]; then
	mkdir -p /media/share1/SDC/PERKINS
fi

cp build/cloudKingdoms1.dsk /media/share1/SDC/PERKINS/CLOUDK1.DSK
cp build/cloudKingdoms2.dsk /media/share1/SDC/PERKINS/CLOUDK2.DSK
cp build/test.dsk /media/share1/SDC/PERKINS/TEST.DSK


echo
echo Done!
