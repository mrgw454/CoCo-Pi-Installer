#!/bin/bash

# install prerequsites
echo NOTE!  You need to make sure the following projects are already built and installed:
echo
echo CMOC
echo toolshed
echo
echo
read -p "Press any key to continue... " -n1 -s
echo

cd $HOME/source

# if a previous fujinet-apps-CoCo folder exists, move into a date-time named folder

if [ -d "fujinet-apps-CoCo" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "fujinet-apps-CoCo" "fujinet-apps-CoCo-$foldername"

        echo -e Archiving existing fujinet-apps-CoCo folder ["fujinet-apps-CoCo"] into backup folder ["fujinet-apps-CoCo-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/FujiNetWIFI/fujinet-apps
git clone https://github.com/FujiNetWIFI/fujinet-apps.git fujinet-apps-CoCo

cd fujinet-apps-CoCo

GITREV=`git rev-parse --short HEAD`

cd netcat/coco

sed -i '/tnfs/d' Makefile

make

if [ $? -eq 0 ]
then
       	echo "Compilation was successful."
       	echo
else
       	echo "Compilation was NOT successful."
       	echo
fi

if [ -d /media/share1/DW4/COCOVGA/WIDTH64 ]; then
	cp /media/share1/DW4/COCOVGA/WIDTH64/* ./
	decb copy -0 -a -t -r WIDTH64.BAS netcat.dsk,WIDTH64.BAS
	decb copy -2 -b -r WIDTH64.BIN netcat.dsk,WIDTH64.BIN
	decb copy -2 -b -r LOWERKIT.CHR netcat.dsk,LOWERKIT.CHR
fi

if [ ! -d /media/share1/DW4/FUJINET ]; then
	mkdir -p /media/share1/DW4/FUJINET
fi

cp netcat.dsk /media/share1/DW4/FUJINET


cd $HOME/source/fujinet-apps-CoCo/news/coco

sed -i '/tnfs/d' Makefile

make

if [ $? -eq 0 ]
then
        echo "Compilation was successful."
        echo
else
        echo "Compilation was NOT successful."
        echo
fi

if [ -d /media/share1/DW4/COCOVGA/WIDTH64 ]; then
        cp /media/share1/DW4/COCOVGA/WIDTH64/* ./
	decb copy -0 -a -t -r WIDTH64.BAS news.dsk,WIDTH64.BAS
	decb copy -2 -b -r WIDTH64.BIN news.dsk,WIDTH64.BIN
	decb copy -2 -b -r LOWERKIT.CHR news.dsk,LOWERKIT.CHR
fi

if [ ! -d /media/share1/DW4/FUJINET ]; then
        mkdir -p /media/share1/DW4/FUJINET
fi

cp news.dsk /media/share1/DW4/FUJINET


cd $HOME/source/fujinet-apps-CoCo/mastodon/coco

sed -i '/tnfs/d' Makefile

make

if [ $? -eq 0 ]
then
        echo "Compilation was successful."
        echo
else
        echo "Compilation was NOT successful."
        echo
fi

if [ -d /media/share1/DW4/COCOVGA/WIDTH64 ]; then
        cp /media/share1/DW4/COCOVGA/WIDTH64/* ./
	decb copy -0 -a -t -r WIDTH64.BAS mastodon.dsk,WIDTH64.BAS
	decb copy -2 -b -r WIDTH64.BIN mastodon.dsk,WIDTH64.BIN
	decb copy -2 -b -r LOWERKIT.CHR mastodon.dsk,LOWERKIT.CHR
fi

cp mastodon.dsk /media/share1/DW4/FUJINET


cd $HOME/source/fujinet-apps-CoCo/iss-tracker/coco

sed -i '/tnfs/d' Makefile

make

if [ $? -eq 0 ]
then
        echo "Compilation was successful."
        echo
else
        echo "Compilation was NOT successful."
        echo
fi

cp iss.dsk /media/share1/DW4/FUJINET


cd $HOME/source/fujinet-apps-CoCo/weather/coco

sed -i '/tnfs/d' Makefile

make

if [ $? -eq 0 ]
then
        echo "Compilation was successful."
        echo
else
        echo "Compilation was NOT successful."
        echo
fi

cp weather.dsk /media/share1/DW4/FUJINET


cd $HOME/source/fujinet-apps-CoCo/5cardstud/cross-platform

sed -i '/tnfs/d' Makefile.coco

make -f Makefile.coco

if [ $? -eq 0 ]
then
        echo "Compilation was successful."
        echo
else
        echo "Compilation was NOT successful."
        echo
fi

cp 5cs.dsk /media/share1/DW4/FUJINET

cd $HOME/source


echo
echo Done!

