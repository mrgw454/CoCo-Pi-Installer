#!/bin/bash

# this for emulation only (Becker port)

# make sure python3 is the default prior to running this
pyenv shell system
# ... or ...
PATH=`echo $PATH | tr ':' '\n' | sed '/pyenv/d' | tr '\n' ':' | sed -r 's/:$/\n/'`

# start FujiNet PC for Becker port
cd $HOME/source/fujinet-pc-CoCo/build/dist
./run-fujinet &

#read -p "Press any key to continue... " -n1 -s

cd $HOME/source

echo
echo

ps auwx | grep fuji

echo
echo

#google-chrome http://localhost:8000 &

exit
