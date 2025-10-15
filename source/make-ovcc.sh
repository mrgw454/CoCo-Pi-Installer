#!/bin/bash

# install prerequisites
echo NOTE!  You need to make sure the following projects are already built and installed:
echo
echo libagar
echo
echo
read -p "Press any key to continue... " -n1 -s
echo


# verify correct libagar version is installed
# Path to version header
VERSION_HEADER="/usr/local/include/agar/agar/config/version.h"

# Required minimum version
REQUIRED_VERSION="1.7.1"

# Extract version string from header
AGAR_VERSION=$(grep -oP '(?<=#define VERSION ")[^"]+' "$VERSION_HEADER")

# Function to compare versions
version_ge() {
    # Returns 0 if $1 >= $2
    [ "$(printf '%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]
}

# Check version
if version_ge "$AGAR_VERSION" "$REQUIRED_VERSION"; then
    echo "libagar version $AGAR_VERSION is sufficient."
    echo
else
    echo "libagar version $AGAR_VERSION is too old. Requires at least $REQUIRED_VERSION."
    echo
    exit 1
fi

cd $HOME/source

# if a previous OVCC folder exists, move into a date-time named folder

if [ -d "OVCC" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "OVCC" "OVCC-$foldername"

        echo -e Archiving existing OVCC folder ["OVCC"] into backup folder ["OVCC-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/WallyZambotti/OVCC
git clone https://github.com/WallyZambotti/OVCC.git

cd OVCC

# we need this specific version to apply patches
git checkout cc936b2

GITREV=`git rev-parse --short HEAD`

# check for existance of patch package
if [ ! -f ../ovcc-patch-package-cc936b2.tar.gz ]; then
	echo
	echo OVCC patch file does NOT exist.  Aborting.
	echo
	exit 1
fi


# extract patch package
tar zxvf $HOME/source/ovcc-patch-package-cc936b2.tar.gz -C $HOME/source/OVCC

# apply patches
patch -p1 < ovcc-patch-package/ovcc-fix-cc936b2.patch

if [ $? -eq 0 ]
then
        echo "patching was successful"
        echo
else
        echo "patching was NOT successful.  Aborting."
        echo
        exit 1
fi

make

if [ -f CoCo/ovcc ]; then
	echo ovcc binary found.
	echo Copying files to $HOME/.ovcc
	echo

	if [ ! -d $HOME/.ovcc ]; then
		mkdir $HOME/.ovcc
	fi

	if [ ! -d $HOME/.ovcc/OVCC_Libs ]; then
		mkdir $HOME/.ovcc/OVCC_Libs
	fi

	cp CoCo/ovcc $HOME/.ovcc
	cp CoCo/ovcc.ico $HOME/.ovcc
	cp README* $HOME/.ovcc

	find . -name *.so -type f -exec cp {} $HOME/.ovcc/OVCC_Libs \;
else
	echo ovcc binary not found!
	echo
fi

cd ..

echo
echo Done!
