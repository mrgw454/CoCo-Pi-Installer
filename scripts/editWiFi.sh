
#!/bin/bash

systemtype=$(dpkg --print-architecture)
echo architecture = $systemtype

if [[ $systemtype != arm64 ]];then
        echo This method of editing WiFi is not compatible with your platform.  Aborting.
        echo
        echo
	read -p "Press any key to continue... " -n1 -s
        exit 1
fi

sudo nmtui

cd $HOME/.mame
