#!/bin/bash

# remove older, cached APT installed packages
sudo apt clean
sudo apt autoclean
sudo apt autoremove


echo
echo Done!
echo

