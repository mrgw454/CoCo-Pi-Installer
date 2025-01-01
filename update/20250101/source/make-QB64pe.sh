#!/bin/bash

cd $HOME/source

# if a previous QB64pe folder exists, move into a date-time named folder

if [ -d "QB64pe" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "QB64pe" "QB64pe-$foldername"

        echo -e Archiving existing QB64pe folder ["QB64pe"] into backup folder ["QB64pe-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/QB64peTeam/QB64pe
git clone https://github.com/QB64-Phoenix-Edition/QB64pe.git

cd $HOME/source/QB64pe

./setup_lnx.sh

if [ -f qb64pe ]; then
	sudo ln -s $HOME/source/QB64pe/qb64pe /usr/local/bin/qb64pe
else
	echo
	echo qb64pe binary not found.  Aborting.
	echo
	exit 1
fi

cd $HOME/source


echo
echo Done!

