#!/bin/bash

# install prerequisites
sudo apt -y install jam

cd $HOME/source

# if a previous coco3-jaggies folder exists, move into a date-time named folder

if [ -d "coco3-jaggies" ]; then
	foldername=$(date +%Y-%m-%d_%H.%M.%S)
       	mv "coco3-jaggies" "coco3-jaggies-$foldername"

       	echo -e Archiving existing coco3-jaggies folder ["coco3-jaggies"] into backup folder ["coco3-jaggies-$foldername"]
       	echo -e
       	echo -e
fi

# https://github.com/jaggies/coco3
git clone https://github.com/jaggies/coco3.git coco3-jaggies

cd coco3-jaggies

GITREV=`git rev-parse --short HEAD`

# git revision required to be compatible with the patches
git checkout 0acd98f

# Unzip and apply patches
PATCH_ZIP="$HOME/source/coco3-jaggies-patches.zip"
PATCH_DIR="$HOME/source/coco3-jaggies-patches"
SOURCE_DIR="$HOME/source/coco3-jaggies"

if [ -f "$PATCH_ZIP" ]; then
    echo "Unzipping patch bundle: $PATCH_ZIP"
    unzip -o "$PATCH_ZIP" -d "$HOME/source"
else
    echo "Patch zip not found: $PATCH_ZIP"
fi

if [ -d "$PATCH_DIR" ]; then
    echo "Applying patches from $PATCH_DIR to $SOURCE_DIR..."
    cd "$SOURCE_DIR"
    for patch in "$PATCH_DIR"/*.patch; do
        echo "  → Applying patch: $(basename "$patch")"
        git apply "$patch"
    done
    echo "All patches applied successfully."
else
    echo "Patch directory not found: $PATCH_DIR"
    echo "Skipping patch application."
fi


sed -i 's/triangles/triangle/' apps/Jamfile
sed -i 's/triangles/triangle/' apps/triangles/Jamfile
sed -i 's/TRIANGLES/TRIANGLE/' apps/triangles/Jamfile

mv apps/triangles/triangles.c apps/triangles/triangle.c
mv apps/triangles apps/triangle

jam

if [ $? -eq 0 ]
then
        echo "build process was successful"
        echo
else
        echo "build process was NOT successful.  Some programs may have had come errors."
        echo
fi

if [ ! -d /media/share1/SDC/JAGGIES ]; then
	mkdir -p /media/share1/SDC/JAGGIES
fi

find . -iname "*.dsk" -exec cp {} /media/share1/SDC/JAGGIES \;

cd ..


echo
echo Done!
