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
	echo pyenv entries found in $HOME/.bashrc .  Skipping...
	echo
else
	echo pyenv entries not found in $HOME/.bashrc .  Adding...
	echo

cat >/tmp/np <<EOF
# pyenv setup for pyDriveWire
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOF

	cat /tmp/np >> ~/.bashrc
	source ~/.bashrc
	rm /tmp/np
	echo
	echo
fi

# check if correct version of python2 is installed for pyenv
if [ -d $HOME/.pyenv/versions/pypy2.7-7.3.11 ]; then
	echo correct verion of python2 exists in ~/.pyenv/versions folder.  Skipping...
	echo
else
	echo correct verion of python2 does not exist in ~/.pyenv/versions folder.  Installing...
	echo

	source $HOME/.bashrc

	pyenv install pypy2.7-7.3.11
	echo
	echo
	source $HOME/.bashrc

fi

pyenv global pypy2.7-7.3.11

echo
echo
echo Done!
echo
