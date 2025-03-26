#!/bin/bash
# tag: language BASIC

# install prerequisites
sudo apt install nodejs

cd $HOME/source

# if a previous basic_renumber folder exists, move into a date-time named folder

if [ -d "basic_renumber" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "basic_renumber" "basic_renumber-$foldername"

        echo -e Archiving existing basic_renumber folder ["basic_renumber"] into backup folder ["basic_renumber-$foldername"]
        echo -e
        echo -e
fi


# script to basic_renumber a BASIC program
# more information about this utility can be found here:
# https://github.com/tilleul/basic_renumber

# 3 parameters are required
# original filename, new filename, basic_renumber increcment value

# nodejs $HOME/source/basic_renumber/basic_renumber.js $1 $2 $3

git clone https://github.com/tilleul/basic_renumber.git

cd ..

echo
echo Done!
