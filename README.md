# CoCo-Pi-Installer
Experimental installer for the CoCo-Pi (64 bit) distribution

The CoCo-Pi Installer will add the CoCo-Pi components (i.e. menus, launch scripts, emulators, development tools, etc.) to Raspberry Pi 3 B+, 4, 400, or 5 platform.  In addition, it's been expanded to allow installation
on X86_64 (amd64) based systems (including WSL2).

Current testing has been done using OS a current image for the Raspberry Pi ("Raspberry Pi OS with desktop and recommended software" 64bit version recommended):

https://www.raspberrypi.com/software/operating-systems/<br/>


Keep in mind, things are in a heavy state of flux and it's not really meant for general consumption use just yet.  I'll be populating the repository over the next few weeks and update this README.md when things are ready.

For those early adopters that would like to try this out now, here are the basic steps:

1. Install the base OS to one of the platforms listed above.
2. Create a user called pi for Raspberry Pi platforms.  You can use any user name for x86_64 (amd64) platforms.
3. Make note of the password you choose for the user id.  You will need that same password later when installing samba (i.e. Windows files sharing).
4. You will need a network connection to the Internet (either wired or wireless).
5. Allow the OS to update.  That may take a bit.

On Raspberry Pi platforms, the file system on SD card will automatically be expanded after your first reboot.  No need to perform that step manually any longer.

7. Log into OS.
8. DO NOT CLONE this repository.  You only need to download a single file (Downloads folder is fine):<br/>
    https://github.com/mrgw454/CoCo-Pi-Installer/blob/master/CoCo-Pi-Installer-setup.sh

9. Open a terminal, change directories to where you downloaded the file and type the following commands:<br/>
   `chmod a+x CoCo-Pi-Installer-setup.sh`<br/>
   `./CoCo-Pi-Installer-setup.sh`<br/>
   When this part is complete, REBOOT.<br/>

10. Log back into OS, open a terminal and type the following commands:<br/>
    `cd $HOME/source`<br/>
    `./CoCo-Pi-apt-packages-to-install.sh`<br/>
    When this part is complete, REBOOT.<br/>

11. Log back into OS, open a terminal and type the following command:<br/>
    `select-project-build.sh`<br/><br/>
    A menu of projects to compile and install will be presented.  I suggest starting with lwtools, toolshed and gcc6809.  Having these projects installed first will allow successful building of other projects.  There is a make-ALL-projects.sh script availavble to help automate building multiple projects.<br/><br/>

The rest of this should be familiar.  The same CoCo-Pi Menus are there (for launching emulators, downloading software, etc.).  I'm sure you will encounter issues/bugs.

This method of obtaining and using CoCo-Pi is a big departure from a "ready to go" SD card image.  Due to nature of OS versions (and the packages / settings they use) this method of installing CoCo-Pi may still need to be tied specific version(s) of Debian based OS's.


More information about the regular CoCo-Pi Project can be found here:

https://coco-pi.com/
