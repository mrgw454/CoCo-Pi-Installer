#!/bin/bash

cd $HOME

sudo apt -y install inetutils-telnet inetutils-telnetd inetutils-inetd

if [ -f /etc/inetd.conf ]; then

	# enable telnet
	backupdate=$(date +"%Y%m%d_%H%M%S")
	sudo cp /etc/inetd.conf /etc/inetd.conf.$backupdate
	sudo sed -i 's|#<off># telnet|telnet|' /etc/inetd.conf

	# start inetd daemon
	process=$(pidof inetutils-inetd)

	if [[ -z "$process" ]]; then
        	echo inetutils-inetd process not found.  Starting.
		echo
		sudo inetutils-inetd
		echo Process started $(pidof inetutils-inetd).
        	echo
	else
        	echo "inetutils-inetd process ($process) found.  Restarting."
        	echo
		sudo kill $process
		sudo inetutils-inetd
		echo New process started $(pidof inetutils-inetd).
		echo
	fi

fi

echo
echo Done!
echo
