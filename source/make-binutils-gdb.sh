#!/bin/bash

# install prerequisites
sudo apt -y install ddd

cd $HOME/source

# if a previous binutils-gdb-git folder exists, move into a date-time named folder

if [ -d "binutils-gdb-git" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "binutils-gdb-git" "binutils-gdb-git-$foldername"

        echo -e Archiving existing binutils-gdb-git folder ["binutils-gdb-git"] into backup folder ["binutils-gdb-git-$foldername"]
        echo -e
        echo -e
fi

pyenv global pypy2.7-7.3.11

# https://www.6809.org.uk/dragon/m6809-gdb.shtml
#git clone -b m6809-7.6 https://www.6809.org.uk/git/binutils-gdb.git binutils-gdb-git
git clone -b m6809-15.0 https://www.6809.org.uk/git/binutils-gdb.git binutils-gdb-git

cd binutils-gdb-git

GITREV=`git rev-parse --short HEAD`

#./autogen.sh
#./configure --target=m6809 --disable-werror
./configure --target=m6809 --disable-readline --with-system-readline --disable-sim --disable-ld --with-gnu-as=no

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)
make -j$cores

if [ $? -eq 0 ]
then
        echo "compilation install was successful.  Installing."
        echo
	sudo make install
else
        echo "compilation was NOT successful.  Aborting installation." >&2
        echo
        exit 1
fi

cd ..

echo
echo Done!

