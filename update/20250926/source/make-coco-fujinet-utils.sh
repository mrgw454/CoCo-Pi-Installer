#!/bin/bash

# install prerequisites
echo NOTE!  You need to make sure the following projects are already built and installed:
echo
echo CMOC
echo lwasm
echo
echo
echo
read -p "Press any key to continue... " -n1 -s
echo

cd $HOME/source

# if a previous coco-fujinet-utils folder exists, move into a date-time named folder

if [ -d "coco-fujinet-utils" ]; then

       	foldername=$(date +%Y-%m-%d_%H.%M.%S)

       	mv "coco-fujinet-utils" "coco-fujinet-utils-$foldername"

       	echo -e Archiving existing coco-fujinet-utils-git folder ["coco-fujinet-utils"] into backup folder ["coco-fujinet-utils-$foldername"]
       	echo -e
       	echo -e
fi

# https://github.com/RichStephens/coco-fujinet-utils
git clone https://github.com/RichStephens/coco-fujinet-utils.git

cd coco-fujinet-utils

GITREV=`git rev-parse --short HEAD`

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)
make -j$cores

if [ $? -eq 0 ]
then
        echo "Compilation was successful."
        echo
else
        echo "Compilation was NOT successful.  Aborting installation."
        echo
        exit 1
fi

if [ ! -d /media/share1/SDC/FUJINET ]; then
	mkdir -p /media/share1/SDC/FUJINET
fi

cp fujiutil.dsk /media/share1/SDC/FUJINET


cd $HOME/source


echo
echo Done!
