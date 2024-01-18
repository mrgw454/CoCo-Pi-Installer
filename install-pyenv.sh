#!/bin/bash

# using info from https://linuxways.net/debian/how-to-install-python-on-debian-12-bookworm/

# install pyenv to add python2 - if needed

# check if .pyenv home folder exists
if [ ! -d $HOME/.pyenv ]; then
	echo ~/.pyenv folder does not exist.  Installing pyenv...
	echo
	echo git clone https://github.com/pyenv/pyenv.git ~/.pyenv
	git clone https://github.com/pyenv/pyenv.git ~/.pyenv
else
	echo ~/.pyenv folder exists.  Skipping...
	echo
fi

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

# check if correct version of python2 is installed for pyenv
if [ -d $HOME/.pyenv/versions/pypy2.7-7.3.11 ]; then
	echo correct version of python2 exists in ~/.pyenv/versions folder.  Skipping...
	echo
else
	echo correct version of python2 does not exist in ~/.pyenv/versions folder.  Installing...
	echo

	source $HOME/.bashrc

	$HOME/.pyenv/bin/pyenv install pypy2.7-7.3.11
	echo
	echo
	source $HOME/.bashrc

fi

$HOME/.pyenv/bin/pyenv global pypy2.7-7.3.11

# set up symbolic link for system instgalled python3
if [ -L /usr/bin/python3 ]; then
        sudo ln -s /usr/bin/python3 /usr/bin/python
fi


echo
echo
echo Done!
echo
