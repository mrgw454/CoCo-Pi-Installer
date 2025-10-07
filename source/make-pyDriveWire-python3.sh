#!/bin/bash

# https://github.com/n6il/pyDriveWire
# https://github.com/n6il/pyDriveWire/blob/master/docs/pyDriveWire%20General%20Installation%20Instructions.md

# install python3 3.12.1 via pyenv

# Target Python version that is compatible with pyDriveWire
PYTHON_VERSION="3.12.1"

# Check if pyenv is available
if ! command -v pyenv &> /dev/null; then
  echo "❌ pyenv is not installed or not in PATH."
  exit 1
fi

# Check if Python version is already installed
if pyenv versions --bare | grep -q "^${PYTHON_VERSION}$"; then
  echo "✅ Python ${PYTHON_VERSION} is already installed in pyenv."
else
  echo "🔧 Installing Python ${PYTHON_VERSION} via pyenv..."
  pyenv install "${PYTHON_VERSION}"
  echo "✅ Installation complete."
fi

# set default to python 3.12.1
pyenv global 3.12.1

echo
python --version
echo


# install modules required for pyDriveWire
pip install --upgrade wheel
pip install --upgrade setuptools
pip install pyserial reportlab playsound


# install pyDriveWire
cd $HOME/source

# remove symbolic link if it exists
if [ -L $HOME/pyDriveWire ]; then
        rm $HOME/pyDriveWire
fi

# if a previous pyDriveWire-git folder exists, move into a date-time named folder
if [ -d "pyDriveWire-git" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "pyDriveWire-git" "pyDriveWire-git-$foldername"

        echo -e Archiving existing pyDriveWire-git folder ["pyDriveWire-git"] into backup folder ["pyDriveWire-git-$foldername"]
        echo -e
        echo -e
fi

echo
echo

git clone https://github.com/n6il/pyDriveWire.git pyDriveWire-git

cd pyDriveWire-git

git checkout develop
git branch -a

GITREV=`git rev-parse --short HEAD`


# fix daemon.py buffering error
sed -i "s/se = open(self.stderr, 'a+', 0)/se = open(self.stderr, 'ab+', 0)/" daemon.py

# set all python scripts to executable
chmod a+x *.py

echo
echo

# restore backed up config file
if [ -f ../pyDriveWire-git-$foldername/config/pydrivewirerc-daemon ]; then
	echo "Found existing config file.  Restoring from ../pyDriveWire-git-$foldername/config to $HOME/source/pyDriveWire-git/config"
	echo
	cp ../pyDriveWire-git-$foldername/config/pydrivewirerc-daemon $HOME/source/pyDriveWire-git/config
	echo
	echo
else
	echo No existing config file.  Copying from CoCo-Pi-Installer...
	tar zxvf $HOME/CoCo-Pi-Installer/pyDriveWire-files.tar.gz --strip-components 1 pyDriveWire/config/pydrivewirerc-daemon -C $HOME/source/pyDriveWire-git/config
	echo
	echo
fi


# restore scripts
if [ -d ../pyDriveWire-git-$foldername ]; then
        echo "Found existing backup folder with scripts.  Restoring from ../pyDriveWire-git-$foldername to $HOME/source/pyDriveWire-git"
        echo
	cp ../pyDriveWire-git-$foldername/start_pyDW.sh $HOME/source/pyDriveWire-git
	cp ../pyDriveWire-git-$foldername/status_pyDW.sh $HOME/source/pyDriveWire-git
        cp ../pyDriveWire-git-$foldername/stop_pyDW.sh $HOME/source/pyDriveWire-git
	echo
else
        echo No existing backup folder.  Copying from CoCo-Pi-Installer...
	echo
	tar zxvf $HOME/CoCo-Pi-Installer/pyDriveWire-files.tar.gz --strip-components 1 pyDriveWire/start_pyDW.sh -C $HOME/source/pyDriveWire-git
	tar zxvf $HOME/CoCo-Pi-Installer/pyDriveWire-files.tar.gz --strip-components 1 pyDriveWire/status_pyDW.sh -C $HOME/source/pyDriveWire-git
	tar zxvf $HOME/CoCo-Pi-Installer/pyDriveWire-files.tar.gz --strip-components 1 pyDriveWire/stop_pyDW.sh -C $HOME/source/pyDriveWire-git
	echo
fi


cd ..

# create new symbolic links
ln -s $HOME/source/pyDriveWire-git $HOME/pyDriveWire

if [ ! -L $HOME/.pydrivewirerc ]; then
	ln -s $HOME/pyDriveWire/config/pydrivewirerc-daemon $HOME/.pydrivewirerc
fi


cd $HOME/source

echo
echo
echo Done!
echo
