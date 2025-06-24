#!/bin/bash

# check for existing coco-hash project files folder
if [ -d $HOME/source/coco-hash ]
then
    echo coco-hash project folder exists.  Updating...
    echo
    cd $HOME/source/coco-hash
    git pull

else
    echo coco-hash project folder does not exist.  Cloning...
    echo
    cd $HOME/source
    git clone https://github.com/mrgw454/coco-hash.git
    echo
    read -p "Press any key to continue... " -n1 -s
fi


# check for existing disk software files in coco_flop folder
if [ -d $HOME/source/coco-hash/software/coco_flop ]
then
    echo coco_flop disk software files exist.
    echo
else
    echo coco_flop disk software files do not exist.  Downloading, extracting and generating new HASH file...
    echo
    cd $HOME/source/coco-hash
    ./get-disk-images-full.sh
    ./extract-zips.sh
    ./coco-hash.sh
    echo
    echo
    read -p "Press any key to continue... " -n1 -s
    exit 1
fi


# check for existing of symlink folder
if [ -L /media/share1/software/coco_flop ]
then
    echo software symlink folder exists.
    echo
else
    echo software symlink folder does not exist.  Creating...
    echo
	rm  -r -f /media/share1/software/coco_flop
    ln -s $HOME/source/coco-hash/software/coco_flop /media/share1/software/coco_flop
    echo
fi


if [ -d $HOME/.mame/hash ]
then
    echo hash folder exists.
    echo
else
    echo hash folder does not exist.  Creating...
    echo
    mkdir $HOME/.mame/hash
    echo
fi


if [ -L $HOME/.mame/hash/coco_flop.xml ]
then
    echo hash file symlink exists.
    echo
else
    echo hash file does not exist.  Creating...
    echo
	rm  -r -f $HOME/.mame/hash/coco_flop.xml
    ln -s $HOME/source/coco-hash/hash/coco_flop.xml $HOME/.mame/hash/coco_flop.xml
    echo
fi


cd $HOME/.mame

echo -e
echo -e
read -p "Press any key to continue... " -n1 -s
echo -e
