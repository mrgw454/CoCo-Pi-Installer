#!/bin/bash

# script to update CoCo-Pi from github repo

cd $HOME/CoCo-Pi-Installer

git fetch --all
git reset --hard origin/debian13
git pull origin debian13
git branch -a

echo -e

chmod a+x $HOME/scripts/*.sh
chmod a+x $HOME/source/*.sh
chmod a+x $HOME/.mame/*.sh
chmod a+x $HOME/.xroar/*.sh
chmod a+x $HOME/.trs80gp/*.sh
chmod a+x $HOME/.ovcc/*.sh

echo -e
echo -e
read -p "Press any key to continue... " -n1 -s
echo -e
