#!/bin/bash

cd $HOME/source

# if a previous dynosprite folder exists, move into a date-time named folder

if [ -d "dynosprite" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "dynosprite" "dynosprite-$foldername"

        echo -e Archiving existing dynosprite folder ["dynosprite"] into backup folder ["dynosprite-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/richard42/dynosprite
git clone https://github.com/richard42/dynosprite.git

cd dynosprite

# set up some symbolic links so makefile works correctly
ln -s /usr/local/bin/lwasm ./tools/lwasm

GITREV=`git rev-parse --short HEAD`

# Check if numpy is installed
python3 -c "import numpy" 2>/dev/null

if [[ $? -eq 0 ]]; then
	echo "numpy is already installed."
	echo
else
	echo "numpy not found. Installing..."
	pip install numpy
	echo
fi

make all CPU=6809

if [ -f DYNO6809.DSK ]; then
	echo 6809 version created successfully
	echo
else
	echo 6809 version NOT created successfully!
	echo
fi


make all CPU=6309

if [ -f DYNO6309.DSK ]; then
	echo 6309 version created successfully
	echo
else
	echo 6309 version NOT created successfully!
	echo
fi

cd ..

echo
echo Done!
