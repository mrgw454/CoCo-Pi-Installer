#!/bin/bash
# tag: language BASIC

cd $HOME/source

# if a previous basic_utils.beta folder exists, move into a date-time named folder

if [ -d "basic_utils.beta" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "basic_utils.beta" "basic_utils.beta-$foldername"

        echo -e Archiving existing basic_utils.beta folder ["basic_utils.beta"] into backup folder ["basic_utils.beta-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/varmfskii/basic_utils.beta
git clone https://github.com/varmfskii/basic_utils.beta.git

cd basic_utils.beta

GITREV=`git rev-parse --short HEAD`

cd ..

echo
echo Done!

