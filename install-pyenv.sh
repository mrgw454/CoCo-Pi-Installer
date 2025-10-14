#!/bin/bash

# install required dependencies
sudo apt install make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl \
llvm libncursesw5-dev xz-utils tk-dev libxml2-dev \
libxmlsec1-dev libffi-dev liblzma-dev git


# clone the pyenv repository into your home directory:
git clone https://github.com/pyenv/pyenv.git ~/.pyenv


# check if pyenv entires exist in .bashrc file
if grep -q PYENV_ROOT $HOME/.bashrc; then
	source $HOME/.bashrc
	echo pyenv entries found in $HOME/.bashrc .  Skipping...
	echo
else
	echo pyenv entries not found in $HOME/.bashrc .  Adding...
	echo

	if [ -f $HOME/CoCo-Pi-Installer/pyenv-bashrc-cocopi.txt ]; then
		cat $HOME/CoCo-Pi-Installer/pyenv-bashrc-cocopi.txt >> $HOME/.bashrc
		source $HOME/.bashrc
	fi

	source $HOME/.bashrc
fi

echo
echo

# set up symbolic link for system instgalled python3
if [ -L /usr/bin/python3 ]; then
        sudo ln -s /usr/bin/python3 /usr/bin/python
fi


echo
echo
echo Done!
echo
