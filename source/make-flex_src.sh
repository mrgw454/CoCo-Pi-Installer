#!/bin/bash

# install prerequisites
echo NOTE!  Optional projects you may want built and installed:
echo
echo flex_50_coco
echo multicomp6809
echo
echo
read -p "Press any key to continue... " -n1 -s
echo
echo

cd $HOME/source

# if a previous flex_src folder exists, move into a date-time named folder

if [ -d "flex_src" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "flex_src" "flex_src-$foldername"

        echo -e Archiving existing flex_src folder ["flex_src"] into backup folder ["flex_src-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/n6il/flex_src
git clone https://github.com/n6il/flex_src.git

cd flex_src/dbasic14a

sed -i 's|~/src/flex_50_coco|~/source/flex_50_coco|' $HOME/source/flex_src/dbasic14a/Makefile
sed -i 's|~/src/flex_50_coco|~/source/flex_50_coco|' $HOME/source/flex_src/dbasic14a/Makefile
sed -i 's|~/src/multicomp6809|~/source/multicomp6809|' $HOME/source/flex_src/dbasic14a/vfs.sh

make
if [ $? -eq 0 ]
then
        echo "Compilation was successful"
        echo
else
        echo "Compilation was NOT successful"
        echo
        exit 1
fi

find . -iname "*.sdf" -exec cp {} /media/share1/SDC/FLEX \;
find . -iname "*.dsk" -exec cp {} /media/share1/SDC/FLEX \;
find . -iname "*.dmk" -exec cp {} /media/share1/EMU/FLEX \;

cd ..


echo
echo Done!

