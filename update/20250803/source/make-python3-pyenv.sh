#!/bin/bash

cd $HOME/source

# if a previous mame folder exists, move into a date-time named folder
if [ -d "$python3-pyenv" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "$python3-pyenv" "$python3-pyenv-$foldername"

        echo -e Archiving existing mame folder ["$python3-pyenv"] into backup folder ["$python3-pyenv-$foldername"]
        echo -e
        echo -e
fi


# install compatible version of python3 for use with pyDW for python3
pyenv install 3.12.1
if [ $? -eq 0 ]
then
	echo "Installation was successful"
	echo
else
	echo "Installation was NOT successful.  Aborting."
	echo
	exit 1
fi


pyenv local 3.12.1
python --version

pip install --upgrade pip
if [ $? -eq 0 ]
then
        echo "Installation was successful"
        echo
else
        echo "Installation was NOT successful.  Aborting."
        echo
        exit 1
fi


# install pyserial
pip install pyserial
if [ $? -eq 0 ]
then
        echo "Installation was successful"
        echo
else
        echo "Installation was NOT successful.  Aborting."
        echo
        exit 1
fi


# install reportlab
pip install reportlab
if [ $? -eq 0 ]
then
        echo "Installation was successful"
        echo
else
        echo "Installation was NOT successful.  Aborting."
        echo
        exit 1
fi


# install setuptools - required for playsound
pip install --upgrade setuptools
if [ $? -eq 0 ]
then
        echo "Installation was successful"
        echo
else
        echo "Installation was NOT successful.  Aborting."
        echo
        exit 1
fi


# install wheel - required for playsound
pip install --upgrade wheel
if [ $? -eq 0 ]
then
        echo "Installation was successful"
        echo
else
        echo "Installation was NOT successful.  Aborting."
        echo
        exit 1
fi


# install playsound
pip install playsound
if [ $? -eq 0 ]
then
        echo "Installation was successful"
        echo
else
        echo "Installation was NOT successful.  Aborting."
        echo
        exit 1
fi


cd $HOME/source


echo
echo Done!
