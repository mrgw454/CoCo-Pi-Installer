#!/bin/bash

# https://forums.debian.net/viewtopic.php?t=156005

if [ ! -f /etc/systemd/sleep.conf.d/nosuspend.conf ]; then
	echo nosuspend.conf does NOT exist.  Creating.
	echo
	sudo mkdir -p /etc/systemd/sleep.conf.d

	echo "[Sleep]" > nosuspend.conf
	echo "AllowSuspend=no" >> nosuspend.conf
	echo "AllowHibernation=no" >> nosuspend.conf
	echo "AllowSuspendThenHibernate=no" >> nosuspend.conf
	echo "AllowHybridSleep=no" >> nosuspend.conf
	echo
	echo Please reboot your workstation.
	echo
else
	echo nosuspend.conf exists.  Skipping.
	echo
fi

echo
echo Done!
echo
