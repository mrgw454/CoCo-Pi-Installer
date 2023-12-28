# CoCo-Pi-Installer
Experimental installer for the CoCo-Pi (64 bit) distribution

The CoCo-Pi Installer will add the CoCo-Pi components (i.e. menus, launch scripts, emulators, development tools, etc.) to a fresh Raspberry Pi OS SD card image from:

https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-64-bit



You will need to use this specific image (for now) as this is what I'm developing with and testing on:

https://downloads.raspberrypi.com/raspios_full_arm64/images/raspios_full_arm64-2023-12-06/2023-12-05-raspios-bookworm-arm64-full.img.xz

Release date: December 5th 2023
System: 64-bit
Kernel version: 6.1
Debian version: 12 (bookworm)
Size: 2,732MB

At this time, I've only begun my initial testing on a Raspberry Pi 5 (8 GB) and Raspberry Pi 4 (8 GB) platform.  This is not meant for general consumption use just yet.  I'll be populating the repository over the next few weeks and update this README.md when things are ready.

For those early adopters that would like to try this out now, here are the basic steps:

1. Download and install the SD card image (link above) to an SD card of at least 32GB.
2. Boot image on RPi 4, 400 or 5 (I don't recommend the RPi3 at this time) and follow initital installation steps for the Raspberry Pi OS.
3. When prompted to add a user, add user pi
4. Make note of the password you choose for user pi.  You will need that same password later when installing samba (i.e. Windows files sharing).
5. You will need a network connection to the Internet (either wired or wireless).
6. Allow the OS to update.  That may take a bit.

File system on SD card will automatically be expanded after your first reboot.  No need to perform that step manually any longer.

7. Log into Raspberry Pi OS.
8. DO NOT CLONE this repository.  You only need to download a single file (Downloads folder is fine):<br/>
    https://github.com/mrgw454/CoCo-Pi-Installer/blob/master/CoCo-Pi-Installer-setup.sh

9. Open a terminal, change directories to where you downloaded the file and type the following commands:<br/>

   `chmod a+x CoCo-Pi-Installer-setup.sh`<br/>
   `./CoCo-Pi-Installer-setup.sh`<br/>
   When this part is complete, REBOOT Raspberry Pi.<br/>

10. Log back into Raspberry Pi, open a terminal and type the following commands:<br/>
    `cd $HOME/source`<br/>
    `./CoCo-Pi-apt-packages-to-install.sh`<br/>
    When this part is complete, REBOOT Raspberry Pi.<br/>

11. Log back into Rasperry Pi, open a terminal and type the following commands:<br/>
    `select-project-build.sh`<br/>
    A menu of projects to compile and install will be presented.  I suggest starting with lwtools, toolshed and gcc6809.  Having these projects installed first will allow successful building of other projects.<br/>

The rest of this should be familiar.  The same CoCo-Pi Menus are there (for launching emulators, downloading software, etc.).  I'm sure you will encounter issues/bugs.

This method of obtaining and using CoCo-Pi is a big departure from a "ready to go" SD card image.  Due to nature of the Raspebrry Pi OS (and the packages / settings it uses) this method of installing CoCo-Pi may still need to be tied specific version(s) of the Raspberry Pi OS.


More information about the regular CoCo-Pi Project can be found here:

https://coco-pi.com/
