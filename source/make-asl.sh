#!/bin/bash

# install prerequisites
sudo apt -y install texlive-latex-base

cd $HOME/source

# if a previous asl folder exists, move into a date-time named folder

if [ -d "asl" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "asl" "asl-$foldername"

        echo -e Archiving existing asl folder ["asl"] into backup folder ["asl-$foldername"]
        echo -e
        echo -e
fi

if [ ! -f asl-current.tar.gz ]; then
	# http://john.ccac.rwth-aachen.de:8000/as/
	wget --no-check-certificate http://john.ccac.rwth-aachen.de:8000/ftp/as/source/c_version/asl-current.tar.gz

fi

if [ ! -d asl ]; then
	mkdir asl
fi

tar zxvf asl-current.tar.gz --strip-components 1 -C $HOME/source/asl

cd asl

cp Makefile.def-samples/Makefile.def-i386-unknown-linux2.x.x ./Makefile.def

sed -i 's|-march=i586||' Makefile.def
sed -i 's|docs: docs_DE|docs:|' Makefile

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)
make -j$cores

if [ $? -eq 0 ]
then
        echo "Compilation was successful."
        echo
else
        echo "Compilation was NOT successful.  Aborting installation."
        echo
        exit 1
fi

sudo make install

cd ..


echo
echo Done!
