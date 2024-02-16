#!/bin/bash

echo
echo -e "Windows software for sharing locally connected USB devices to other machines, including Hyper-V guests and WSL 2"
echo

# https://github.com/dorssel/usbipd-win
wget https://github.com/dorssel/usbipd-win/releases/download/v4.1.0/usbipd-win_4.1.0.msi

# GUI for usbipd
# https://gitlab.com/alelec/wsl-usb-gui
wget https://gitlab.com/api/v4/projects/35133362/packages/generic/wsl-usb-gui/5.2.0/WSL-USB-5.2.0.msi

echo
echo Done!
echo
