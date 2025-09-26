\#!/bin/bash

# install prerequisites
echo NOTE!  You need to make sure the following projects are already built and installed:
echo
echo lst2cmt
echo
echo
read -p "Press any key to continue... " -n1 -s
echo

cd $HOME/source

echo Setting mame version to mame-source-debugging-preview.
mamever=mame-source-debugging-preview
mamevernum=git

# if a previous mame folder exists, move into a date-time named folder
if [ -d "$mamever" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "$mamever" "$mamever-$foldername"

        echo -e Archiving existing mame folder ["$mamever"] into backup folder ["$mamever-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/dave-br/mame-source-debugging-preview
git clone https://github.com/dave-br/mame-source-debugging-preview.git $mamever

cd $HOME/source/$mamever

git submodule update --force --recursive --init --remote

GITREV=`git rev-parse --short HEAD`

cd lwtools-unofficial/lwtools

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)
make -j$cores

if [ $? -eq 0 ]
then
        echo "Compilation of lwtools-unofficial successful"
        echo
else
        echo "Compilation of lwtools-unofficial was NOT successful.  Aborting."
        echo
        exit 1
fi

#sudo make install


cd $HOME/source/$mamever

cd mame-unofficial

# useroptions.mak file required.
if [ -f $HOME/source/useroptions.mak ]; then
	cp $HOME/source/useroptions.mak ./
else
	echo
	echo useroptions.mak file not found.  Building all systems.
	echo
fi


# Set your github username and repo name
repo="mamedev/mame"

# Get latest release info
release=$(curl --silent -m 10 --connect-timeout 5 \
    "https://api.github.com/repos/$repo/releases/latest")

# Release version
vtag=$(echo "$release" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

version=$(sed 's/.*-//' <<< "$vtag")

mamevernum=0.${version: -3}

echo
echo mamevernum      = $mamevernum
echo

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)
make -j$cores TOOLS=1 NOWERROR=1


if [ -f mame ]; then
	echo mame binary exists.  Compilation was successful.
	echo

	# remove existing symbolc link
	if [ -L /opt/mame-source-debugging-preview-$mamevernum ]; then
		sudo rm /opt/mame-source-debugging-preview-$mamevernum
	fi

	# create new symbolic link
	echo creating new symbolic link for /opt/mame-source-debugging-preview-$mamevernum ...
	echo
	sudo ln -s $HOME/source/mame-source-debugging-preview/mame-unofficial /opt/mame-source-debugging-preview-$mamevernum

else
	echo mame binary not found!  Compilation was unsuccessful.
	echo
fi


cd $HOME/source


echo
echo Done!
