#!/bin/bash

# install prerequsites
sudo apt -y install python3-serial python3-pip python3-dev python3-setuptools python3-pyaudio

if [ ! -f /usr/lib/python3.11/EXTERNALLY-MANAGED.disabled ]; then
	sudo mv /usr/lib/python3.11/EXTERNALLY-MANAGED /usr/lib/python3.11/EXTERNALLY-MANAGED.disabled
fi

pip3 install pysinewave

cd $HOME/source

# if a previous h19term folder exists, move into a date-time named folder

if [ -d "h19term" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "h19term" "h19term-$foldername"

        echo -e Archiving existing h19term folder ["h19term"] into backup folder ["h19term-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/horga83/h19term
git clone https://github.com/horga83/h19term.git

cd h19term

GITREV=`git rev-parse --short HEAD`

echo "#!/bin/bash" > h19term.sh
echo >> h19term.sh
echo resize >> h19term.sh
echo "resize -s 31 82" >> h19term.sh
echo >> h19term.sh
echo "cd $HOME/source/h19term" >> h19term.sh
echo "./h19term.py" >> h19term.sh
echo >> h19term.sh
echo "resize -s $LINES $COLUMNS" >> h19term.sh
echo >> h19term.sh

chmod a+x h19term.sh

sudo ln -s $HOME/source/h19term/h19term.sh /usr/local/bin/h19term.sh

if [ -f /usr/lib/python3.11/EXTERNALLY-MANAGED.disabled ]; then
	sudo mv /usr/lib/python3.11/EXTERNALLY-MANAGED.disabled /usr/lib/python3.11/EXTERNALLY-MANAGED
fi

cd ..


echo
echo Done!

