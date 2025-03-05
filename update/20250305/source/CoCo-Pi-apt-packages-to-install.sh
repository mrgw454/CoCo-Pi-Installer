#!/bin/bash

# set up some variables
# determine architecture type
systemtype=$(dpkg --print-architecture)

# detect WSL environment
if $(echo uname -a) | grep -q "WSL"; then
	WSL=1
fi

# get user ID
userid=$(whoami)

# set this variable to 1 if you wish to install NON CoCo-Pi specific packages
NONCOCOPI=0

# set this variable to 1 if you wish to install nVidia graphic drivers (non arm64 or WSL environments only)
NVIDIA=0

# set this variable to 1 if you wish to install KVM QEMU (non arm64 non WSL environments only)
KVMQEMU=0


# install CoCo-Pi specific packages (for all architectures and WSL environments)
echo "Installing CoCo-Pi specific packages (for all architectures and WSL environments)..."
echo

sudo apt -y autoremove

# remove geany as version 2.x is needed
sudo apt -y remove geany geany-common

sudo apt -y install glances neofetch net-tools dos2unix screenfetch screen psmisc curl nala xterm wget xfsprogs rmlint fdupes timelimit
sudo apt -y install mercurial libfuse-dev bison flex libgtk-3-dev build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev
sudo apt -y install xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git llvm libncurses5-dev libncursesw5-dev nodejs texinfo intltool internetarchive
sudo apt -y install xxd gcc libncurses5-dev libffi-dev libgl1-mesa-dev libx11-dev libxext-dev libxrender-dev libxrandr-dev libxpm-dev libtinfo5 libgpm-dev
sudo apt -y install subversion libsdl1.2-dev libao-dev meld devscripts xterm markdown cpanminus libglew-dev pkg-config libcurl4-openssl-dev libswt-gtk-4-java
sudo apt -y install libsdl2-mixer-dev install libsmpeg-dev libsdl-ttf2.0-dev libsdl-net1.2-dev hexedit wxhexeditor hexyl ghex wkhtmltopdf bchunk drawing

# for file managers
sudo apt -y install mc doublecmd-gtk

# for archivers
sudo apt -y install p7zip p7zip-full unrar rar unace-nonfree

# for media player
sudo apt -y install vlc

# par utilities
sudo apt -y install par2 parchive

# additional fonts
sudo apt-add-repository contrib non-free -y
sudo apt -y install ttf-mscorefonts-installer

# fonts specific to PuTTy
wget https://github.com/adobe-fonts/source-code-pro/releases/download/2.042R-u%2F1.062R-i%2F1.026R-vf/TTF-source-code-pro-2.042R-u_1.062R-i.zip
if [ ! -d $HOME/.fonts ]; then
	mkdir $HOME/.fonts
fi
unzip -j TTF-source-code-pro-2.042R-u_1.062R-i.zip -d $HOME/.fonts
fc-cache -f -v

# putty
sudo apt -y install putty putty-tools

# required for building Java programs
sudo apt -y install ant

# install flatpak
sudo apt -y install flatpak
echo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# for building certain Java projects
sudo apt -y install maven default-jdk

# misc
sudo apt -y install mlocate tigervnc-viewer minicom npm unionfs-fuse diffuse filezilla rhash xclip jstest-gtk exfat-fuse exfatprogs

# for xroar
sudo apt -y install git python3 libsdl2-dev libsdl2-ttf-dev libfontconfig-dev libpulse-dev qtbase5-dev qtbase5-dev-tools qtchooser qt5-qmake
sudo apt -y install build-essential libsndfile1-dev libgtk2.0-dev libgtkglext1-dev libasound2-dev ddd

# for gcc6809
sudo apt -y install libgmp-dev libmpfr-dev libmpc-dev markdown mercurial subversion bison texinfo

# for VGMPlay
sudo apt -y install make gcc zlib1g-dev libao-dev libdbus-1-dev

# for VGMPlay and lzsa
sudo apt -y install clang

# for flashfloppy and greaseweazle
sudo apt -y install git gcc-arm-none-eabi python3-pip srecord stm32flash zip unzip python3-intelhex python3-crcmod

# for pyDriveWire
sudo apt -y install build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git

# for DriveWire4
sudo apt -y install openjdk-17-jdk ant

# for Fuzix
sudo apt -y install byacc
sudo update-alternatives --set yacc /usr/bin/byacc

# additional fonts
sudo apt-add-repository contrib non-free -y
sudo apt -y install ttf-mscorefonts-installer

# misc ASCII art utilities
sudo apt -y linuxlogo jp2a cmatrix cowsay aewan lolcat figlet toilet boxes

# for samba
sudo apt -y install samba samba-common-bin smbclient cifs-utils
echo
echo
echo Please make sure to enter a password for user - $userid
echo This password is for samba and should be set to match the login password entered at first power-up set up.
echo
sudo smbpasswd -a $userid
echo
echo

# remove uneeded packages
sudo apt -y autoremove

echo
echo


# install CoCo-Pi specific packages (for amd64 with WSL environments only)
if [ $systemtype = amd64 ] && [ $WSL -eq 1 ]; then
	echo "Installing CoCo-Pi specific packages (for amd64 with WSL environments only)..."
	echo

	echo No packages at this time.

	echo
	echo
fi



# install CoCo-Pi specific packages (for amd64 WITHOUT WSL environments only)
if [ $systemtype = amd64 ] && [ $WSL -eq 0 ]; then
	echo "Installing CoCo-Pi specific packages (for amd64 WITHOUT WSL environments only)..."
	echo

	echo No packages at this time.

	echo
	echo
fi



# install NON CoCo-Pi specific packages (for all architectures and WSL environments)
if [ $NONCOCOPI -eq 1 ]; then
	echo "Installing NON CoCo-Pi specific packages (for all architectures and WSL environments)..."
	echo

	# install Google Chrome
	dpkg -l google-chrome-stable
	if [ $? -eq 0 ]
	then
		echo "google-chrome-stable package already exists.  Skipping."
		echo
	else
		# add respository for Google Chrome
		curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg >> /dev/null
		echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/d
		sudo apt update

		sudo apt -y install software-properties-common apt-transport-https ca-certificates curl
		sudo apt -y install google-chrome-stable

		sudo apt -y install apt-transport-https ca-certificates curl software-properties-common fonts-liberation libu2f-udev libvulkan1
		sudo apt -y install openssh-client network-manager-openvpn-gnome openvpn network-manager-openvpn
	fi


	# install Google Drive
        dpkg -l google-drive-ocamlfuse
        if [ $? -eq 0 ]
        then
                echo "google-drive-ocamlfuse package already exists.  Skipping."
                echo
        else
		# https://github.com/astrada/google-drive-ocamlfuse/wiki/Installation
		sudo touch /etc/apt/sources.list.d/alessandro-strada-ubuntu-ppa-bionic.list
		sudo echo -e "deb http://ppa.launchpad.net/alessandro-strada/ppa/ubuntu xenial main" > /etc/apt/sources.list.d/alessandro-strada-ubuntu-ppa-bionic.list
		sudo echo -e "deb-src http://ppa.launchpad.net/alessandro-strada/ppa/ubuntu xenial main" >> /etc/apt/sources.list.d/alessandro-strada-ubuntu-ppa-bionic.list
		sudo sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AD5F235DF639B041
		sudo apt update
		sudo apt -y install google-drive-ocamlfuse
		mkdir $HOME/GoogleDrive
	fi


	# for older openvpn client 2.4.12
	sudo apt -y install liblz4-dev libssl-dev liblzo2-dev libpam0g-dev

	# for hardware statistics utilities
	sudo apt -y install atop dstat sysstat nmon nvtop psensor lm-sensors hardinfo smartmontools gsmartcontrol nvme-cli baobab lshw-gtk libusb-1.0-0-dev libudev-dev pulseview net-tools

	# for benchmark and stress test programs
	sudo apt -y install sysbench stress-ng stress s-tui

	# qBittorrent
	sudo apt -y install cmake qttools5-dev libqt5svg5-dev extra-cmake-modules

	# for gsplus
	sudo apt -y install re2c libsdl2-dev libsdl2-image-dev libfreetype6-dev libpcap0.8-dev

	# for gsport
	sudo apt -y install gcc-multilib g++-multilib re2c libsdl2-dev libsdl2-image-dev libfreetype6-dev libpcap0.8-devudo gcc-multilib g++-multilib libx11-dev:i386 libxext-dev:i386 libpcap-dev:i386

	# for dolphin emulator
	sudo apt -y install build-essential git cmake ffmpeg libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libevdev-dev libusb-1.0-0-dev libxrandr-dev libxi-dev libpangocairo-1.0-0 qt6-base-private-dev libqt6svg6-dev libbluetooth-dev libasound2-dev libpulse-dev libgl1-mesa-dev libcurl4-openssl-dev

	# for h19term
	sudo apt -y install python3-serial python3-pip python3-dev python3-setuptools python3-pyaudio

	# for dlang
	sudo wget https://netcologne.dl.sourceforge.net/project/d-apt/files/d-apt.list -O /etc/apt/sources.list.d/d-apt.list
	sudo apt update --allow-insecure-repositories
	sudo apt -y --allow-unauthenticated install --reinstall d-apt-keyring
	sudo apt update && sudo apt-get install dmd-compiler dub


	# for Visual Studio Code
        dpkg -l code
        if [ $? -eq 0 ]
        then
                echo "code package already exists.  Skipping."
                echo
        else
		# add repository for Visual Studio Code
		sudo apt -y install wget gpg
		wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
		sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
		sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
		rm -f packages.microsoft.gpg
		sudo apt update
		sudo apt -y install apt-transport-https libmedstl-dev python3-jinja2
		sudo apt -y install code
	fi


	# for kicad
	sudo apt -y install kicad

	# for simplescreenrecorder
	sudo apt -y install simplescreenrecorder

	# serial port based utilities
	sudo apt -y install socat setserial

	# terminal based utilities
	sudo apt -y install tack

	# misc
	sudo apt -y install xmlstarlet

	echo
	echo
fi



# install NON CoCo-Pi specific packages (for amd64 WITHOUT WSL environments only)
if [ $NONCOCOPI -eq 1 ] && [ $systemtype = amd64 ] && [ $WSL -eq 0 ] && [KVMQEMU -eq 1 ]; then
	echo "Installing NON CoCo-Pi specific packages (for amd64 WITHOUT WSL environments only)..."
	echo

	# for KVM QEMU
	sudo apt -y install qemu-kvm libvirt-daemon-system libvirt-daemon virtinst bridge-utils libosinfo-bin virt-manager
	sudo apt -y install vim libguestfs-tools libosinfo-bin  qemu-system virt-manager

	# for ARM virtualization and mounting SD cards
	kpartx qemu-arm-static systemd-container

	userid=$(whoami)
	sudo usermod -a -G libvirt $userid

	sudo systemctl status libvirtd
	sudo systemctl enable --now libvirtd

	lsmod | grep -i kvm
	sudo virsh net-start default
	sudo virsh net-autostart default
	sudo virsh net-list --all
	sudo modprobe vhost_net
	ip address

	wget https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe
	wget https://github.com/winfsp/winfsp/releases/download/v2.0/winfsp-2.0.23075.msi
	wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.240-1/virtio-win-guest-tools.exe

	# OBS Studio
	sudo apt-y install obs-studio v4l2loopback-dkms v4l2loopback-utils

	echo
	echo

fi



# install NON CoCo-Pi specific packages (for amd64 and WSL environments only)
if [ $NONCOCOPI -eq 1 ] && [ $systemtype = amd64 ]; then
	echo "Installing NON CoCo-Pi specific packages (for amd64 and WSL environments only)..."
	echo

	sudo apt -y install cpu-x

       # for dlang
        dpkg -l dmd-compiler
        if [ $? -eq 0 ]
        then
                echo "required dlang packages already exist.  Skipping."
                echo
        else
	        sudo wget https://netcologne.dl.sourceforge.net/project/d-apt/files/d-apt.list -O /etc/apt/sources.list.d/d-apt.list
        	sudo apt update --allow-insecure-repositories
	        sudo apt -y --allow-unauthenticated install --reinstall d-apt-keyring
	        sudo apt update && sudo apt-get install dmd-compiler dub
	fi

	echo
	echo

fi



if [ $NVIDIA -eq 1 ] && [ $systemtype = amd64 ]; then
	echo "Installing nVidia drivers (for amd64 architectures only)..."
	echo

	# install drivers for nVidia
        dpkg -l nvidia-driver
        if [ $? -eq 0 ]
        then
                echo "required nVidia packages already exist.  Skipping."
                echo
        else
		sudo apt -y install linux-headers-amd64

			## Add "contrib", "non-free" and "non-free-firmware" components to /etc/apt/sources.list, for example:
			## Debian Bookworm
			#deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
			#sudo apt update

		sudo apt-add-repository contrib non-free -y
		sudo apt-add-repository contrib non-free-firmware -y
		sudo apt update

		# for nVidia based GPUs only
		sudo apt -y install nvidia-driver firmware-misc-nonfree
		sudo apt -y install nvidia-detect
	fi

	echo
	echo
fi

sudo apt -y autoremove


echo
echo
echo Please reboot as soon as possible so all updates can be applied.  Thank you.
echo
read -p "Press any key to continue... " -n1 -s

echo
echo Done!
echo
