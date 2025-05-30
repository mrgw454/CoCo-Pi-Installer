#!/bin/bash

# install prerequisites
echo NOTE!  You need to make sure the following projects are already built and installed:
echo
echo mame-dave-br
echo
echo
read -p "Press any key to continue... " -n1 -s
echo


cd $HOME/source

# if a previous lwtools-unofficial folder exists, move into a date-time named folder

if [ -d "lwtools-unofficial" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "lwtools-unofficial" "lwtools-unofficial-$foldername"

        echo -e Archiving existing lwtools-unofficial folder ["lwtools-unofficial"] into backup folder ["lwtools-unofficial-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/dave-br/lwtools-unofficial
# https://dave-br.github.io/mame-source-debugging-preview/
git clone https://github.com/dave-br/lwtools-unofficial.git

cd $HOME/source/lwtools-unofficial

git checkout 9e97f44

GITREV=`git rev-parse --short HEAD`

cd lwtools

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)
make -j$cores

if [ $? -eq 0 ]
then
        echo "Compilation was successful"
        echo
else
        echo "Compilation was NOT successful.  Aborting."
        echo
        exit 1
fi

sudo make install

cd ..

wkhtmltopdf https://dave-br.github.io/mame-source-debugging-preview mame-source-debugging-preview.pdf
wkhtmltopdf https://dave-br.github.io/mame-source-debugging-preview/quickstart.html quickstart.pdf


cd $HOME/source


echo
echo Done!
echo
