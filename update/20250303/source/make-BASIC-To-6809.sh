#!/bin/bash

# install prerequisites
echo NOTE!  You need to make sure the following projects are already built and installed:
echo
echo QB64pe
echo lwasm
echo
echo
echo
read -p "Press any key to continue... " -n1 -s
echo

cd $HOME/source

# if a previous BASIC-To-6809-git folder exists, move into a date-time named folder

if [ -d "BASIC-To-6809-git" ]; then

       	foldername=$(date +%Y-%m-%d_%H.%M.%S)

       	mv "BASIC-To-6809-git" "BASIC-To-6809-git-$foldername"

       	echo -e Archiving existing BASIC-To-6809-git folder ["BASIC-To-6809-git"] into backup folder ["BASIC-To-6809-git-$foldername"]
       	echo -e
       	echo -e
fi

# https://nowhereman999.wordpress.com/2024/07/27/coco-basic-to-6809-compiler/
# https://wordpress.com/post/nowhereman999.wordpress.com/5054
# https://github.com/nowhereman999/BASIC-To-6809
git clone https://github.com/nowhereman999/BASIC-To-6809.git

cd BASIC-To-6809

GITREV=`git rev-parse --short HEAD`

if [ ! -f $HOME/source/QB64pe/qb64pe ]; then
	echo
	echo qb64pe compiler missing.  Aborting.
	echo
	exit 1
fi

echo
echo Compiling tools can take a few moments.  Please be patient.
echo


# compile Tokenizer
$HOME/source/QB64pe/qb64pe -c BasTo6809.1.Tokenizer.bas -o Tokenizer

if [ ! -f Tokenizer ]; then
	echo
	echo Compiling of Tokenizer tool failed.  Aborting.
	echo
	exit 1
fi

# compile BasTo6809 compiler
$HOME/source/QB64pe/qb64pe -c BasTo6809.2.Compile.bas -o BasTo6809

if [ ! -f BasTo6809 ]; then
        echo
        echo Compiling of BasTo6809 tool failed.  Aborting.
        echo
        exit 1
fi

sudo ln -s $HOME/source/BASIC-To-6809/BasTo6809 /usr/local/bin/BasTo6809
sudo ln -s $HOME/source/BASIC-To-6809/Tokenizer /usr/local/bin/Tokenizer


# get manual
# https://github.com/pwillard/basto6809Manual
wget https://github.com/pwillard/basto6809Manual/blob/main/manual.pdf


echo
echo Done!
