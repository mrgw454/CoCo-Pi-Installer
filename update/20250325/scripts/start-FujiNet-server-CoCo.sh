#!/bin/bash

# this for REAL CoCo HARDWARE only (Serial ports)
# adjust for your specific configuration

# make sure python3 is the default prior to running this
pyenv shell system
# ... or ...
PATH=`echo $PATH | tr ':' '\n' | sed '/pyenv/d' | tr '\n' ':' | sed -r 's/:$/\n/'`

# ttyUSB1	CoCo 3	115200
# ttyUSB2	CoCo 2   57600
# ttyUSB0	CoCo 1   38400

# start FujiNet PC
cd $HOME/source/fujinet-pc-CoCo3/build/dist
./run-fujinet &

# start FujiNet PC
cd $HOME/source/fujinet-pc-CoCo2/build/dist
./run-fujinet &

# start FujiNet PC
cd $HOME/source/fujinet-pc-CoCo1/build/dist
./run-fujinet &

#read -p "Press any key to continue... " -n1 -s

cd $HOME/source

echo
echo

ps auwx | grep fuji
check-serial-ports-in-use.sh

echo
echo

#google-chrome http://localhost:8000 &

exit
