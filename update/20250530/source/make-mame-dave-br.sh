#!/bin/bash

# install prerequisites
echo NOTE!  You need to make sure the following projects are already built and installed:
echo
echo lwtools-unofficial
echo
echo
read -p "Press any key to continue... " -n1 -s
echo

cd $HOME/source

echo Setting mame version to mame-dave-br.
mamever=mame-dave-br
mamevernum=git

# if a previous mame folder exists, move into a date-time named folder
if [ -d "$mamever" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "$mamever" "$mamever-$foldername"

        echo -e Archiving existing mame folder ["$mamever"] into backup folder ["$mamever-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/dave-br/mame
echo "Pulling current WIP mame from git"
echo git https://github.com/dave-br/mame.git $mamever
git clone https://github.com/dave-br/mame.git $mamever

if [ $? -eq 0 ]
then
	echo "Pull from git was successful"
	echo
else
	echo "Pull from git was not successful"
	echo
	exit 1
fi

cd $HOME/source/$mamever

echo current folder: $(pwd)
echo

git checkout 804ccde

GITREV=`git rev-parse --short HEAD`

# useroptions.mak file required.
if [ -f ../useroptions.mak ]; then
	cp ../useroptions.mak ./
else
	echo
	echo useroptions.mak file not found.  Building all systems.
	echo
fi

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)
make -j$cores TOOLS=1 NOWERROR=1


if [ -f mame ]; then
	echo mame binary exists.  Compilation was successful.
	echo

	# remove existing symbolc link
	if [ -L /opt/mame-dave-br-$mamevernum ]; then
		sudo rm /opt/mame-dave-br-$mamevernum
	fi

	# create new symbolic link
	echo creating new symbolic link for /opt/mame-dave-br-$mamevernum ...
	echo
	sudo ln -s $HOME/source/$mamever /opt/mame-dave-br-$mamevernum

else
	echo mame binary not found!  Compilation was unsuccessful.
	echo
fi

cd ..

echo
echo Done!
