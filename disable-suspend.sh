#!/bin/bash

# https://forums.debian.net/viewtopic.php?t=156005

if [ ! -f /etc/systemd/sleep.conf.d/nosuspend.conf ]; then
	echo nosuspend.conf does NOT exist.  Creating.
	echo
	sudo mkdir -p /etc/systemd/sleep.conf.d

	echo "[Sleep]" > /etc/systemd/sleep.conf.d/nosuspend.conf
	echo "AllowSuspend=no" >> /etc/systemd/sleep.conf.d/nosuspend.conf
	echo "AllowHibernation=no" >> /etc/systemd/sleep.conf.d/nosuspend.conf
	echo "AllowSuspendThenHibernate=no" >> /etc/systemd/sleep.conf.d/nosuspend.conf
	echo "AllowHybridSleep=no" >> /etc/systemd/sleep.conf.d/nosuspend.conf
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
