#!/bin/bash

cd $HOME/source

# if a previous vasm6809 folder exists, move into a date-time named folder

if [ -d "vasm6809" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "vasm6809" "vasm6809-$foldername"

        echo -e Archiving existing vasm6809 folder ["vasm6809"] into backup folder ["vasm6809-$foldername"]
        echo -e
        echo -e
fi

if [ ! -f vasm6809.tar.gz ]; then
	# http://john.ccac.rwth-aachen.de:8000/as/
	wget --no-check-certificate http://sun.hasenbraten.de/vasm/release/vasm.tar.gz -O vasm6809.tar.gz
fi

if [ ! -d vasm6809 ]; then
	mkdir vasm6809
fi

tar zxvf vasm6809.tar.gz --strip-components 1 -C $HOME/source/vasm6809

cd vasm6809

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)
make -j$cores CPU=6809 SYNTAX=mot

if [ $? -eq 0 ]
then
        echo "Compilation was successful."
        echo
else
        echo "Compilation was NOT successful.  Aborting installation."
        echo
        exit 1
fi

sudo ln -s $HOME/source/vasm6809/vasm6809_mot /usr/local/bin/vasm6809_mot

cd ..


echo
echo Done!
