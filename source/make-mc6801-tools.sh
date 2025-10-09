#!/bin/bash

cd $HOME/source

# if a previous mc6801-tools folder exists, move into a date-time named folder

if [ -d "mc6801-tools" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "mc6801-tools" "mc6801-tools-$foldername"

        echo -e Archiving existing mc6801-tools folder ["mc6801-tools"] into backup folder ["mc6801-tools-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/retrotinker/mc6801-tools
git clone https://github.com/retrotinker/mc6801-tools.git

cd mc6801-tools

GITREV=`git rev-parse --short HEAD`

# cleanup previous symbolic links
if [ -L /usr/local/bin/ar01 ]; then
	sudo rm /usr/local/bin/ar01
fi

if [ -L /usr/local/bin/as01 ]; then
	sudo rm /usr/local/bin/as01
fi

if [ -L /usr/local/bin/ld01 ]; then
	sudo rm /usr/local/bin/ld01
fi

if [ -L /usr/local/bin/nm01 ]; then
	sudo rm /usr/local/bin/nm01
fi

if [ -L /usr/local/bin/objcopy01 ]; then
	sudo rm /usr/local/bin/objcopy01
fi

if [ -L /usr/local/bin/objdump01 ]; then
	sudo rm /usr/local/bin/objdump01
fi

if [ -L /usr/local/bin/size01 ]; then
	sudo rm /usr/local/bin/size01
fi


sed -i 's|PREFIX=/usr/local/m6801-tools|PREFIX=$(HOME)/source/mc6801-tools/bins|' Makefile

cd as
make

if [ $? -eq 0 ]
then
        echo "Compilation of as01 and chk was successful.  Installing."
        echo
       # sudo ln -s $HOME/source/mc6801-tools/as/as01 /usr/local/bin/as01
else
        echo "Compilation of as01 and chk was NOT successful.  Aborting installation." >&2
        echo
        exit 1
fi


cd ..
cd ar

make

if [ $? -eq 0 ]
then
        echo "Compilation of ar01 was successful.  Installing."
        echo
        #sudo ln -s $HOME/source/mc6801-tools/ar/ar01 /usr/local/bin/ar01
else
        echo "Compilation of ar01 was NOT successful.  Aborting installation." >&2
        echo
        exit 1
fi


cd ..
cd ld

sed -i '/PUBLIC int main(argc, argv)/i void ld86r(int argc, char **argv);' ld.c
sed -i '/#include "ar.h"/a void fatalerror(const char *message);' mkar.c

make

if [ $? -eq 0 ]
then
        echo "Compilation of ld01, objcopy01 and objdump01 was successful.  Installing."
        echo
        #sudo ln -s $HOME/source/mc6801-tools/ld/ld01 /usr/local/bin/ld01
        #sudo ln -s $HOME/source/mc6801-tools/ld/objcopy01 /usr/local/bin/objcopy01
        #sudo ln -s $HOME/source/mc6801-tools/ld/objdump01 /usr/local/bin/objdump01
else
        echo "Compilation of ld01, objcopy01 and objdump01 was NOT successful.  Aborting installation." >&2
        echo
        exit 1
fi

cd $HOME/source/mc6801-tools

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)
make -j$cores

if [ $? -eq 0 ]
then
       	echo "Compilation was successful.  Installing."
       	echo
	mkdir bins
	make install
else
       	echo "Compilation was NOT successful.  Aborting installation." >&2
       	echo
       	exit 1
fi

cd bins
for i in *; do [ -x "$i" ] && sudo ln -s "$HOME/source/mc6801-tools/bins/$i" /usr/local/bin/$i; done


cd $HOME/source


echo
echo Done!
