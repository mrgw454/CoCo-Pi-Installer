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
    if [ ! -L /usr/local/bin/qb64pe ]; then
        sudo ln -s "$HOME/source/QB64pe/qb64pe" /usr/local/bin/qb64pe
    else
        echo "Symbolic link /usr/local/bin/qb64pe already exists. Skipping link creation."
    fi
else
    echo
    echo "qb64pe binary not found. Aborting."
    echo
    exit 1
fi


systemtype=$(dpkg --print-architecture)
echo architecture = $systemtype


if [[ $systemtype =~ arm64 ]];then
	echo
	echo building some missing items to run tests...
	echo

	cd tests/compile_tests/declare_library_static
	gcc -c lib.c -o lib.o
	ar rcs liblib-linux.a lib.o

	echo
	file liblib-linux.a
	echo

	ar x liblib-linux.a
	echo
	file lib.o
	echo

	echo
	#read -p "Press any key to continue... " -n1 -s
	echo
fi

cd ~/source/QB64pe

# optional run tests
#./tests/run_tests.sh


cd $HOME/source


echo
echo Done!
