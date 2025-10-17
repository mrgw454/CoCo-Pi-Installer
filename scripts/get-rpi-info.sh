#!/bin/bash

systemtype=$(dpkg --print-architecture)
echo architecture = $systemtype

if [[ $systemtype != arm64 ]]; then
    echo This script is not compatible with your platform.  Aborting.
    echo
    echo
    read -p "Press any key to continue... " -n1 -s
    exit 1
fi

clear

cd $HOME/CoCo-Pi-Installer

infodate=$(date +%Y-%m-%d_%H.%M.%S)

# if previous RPi info file exists, delete it first
if [ -e /tmp/rpi-info.txt ]; then
    rm /tmp/rpi-info.txt
else
    touch /tmp/rpi-info.txt
fi

# CoCo-Pi version
cat $HOME/cocopi-release.txt >> /tmp/rpi-info.txt

# timezone timestamp
cat /etc/timezone >> /tmp/rpi-info.txt
echo $infodate >> /tmp/rpi-info.txt

# get OS version
version_check=$(grep VERSION= /etc/os-release | cut -d'"' -f 2)
echo "OS version: $version_check" >> /tmp/rpi-info.txt

echo "Architecture: $systemtype" >> /tmp/rpi-info.txt

# get RPi model
if [ -e /proc/device-tree/model ]; then
    RPI=$(tr -d '\0' </proc/device-tree/model)
else
    RPI=$(dmesg | grep -i '] DMI:')
    RPI=${RPI:20}
fi
echo $RPI >> /tmp/rpi-info.txt

# get serial number
grep Serial /proc/cpuinfo | awk '{print $NF}' >> /tmp/rpi-info.txt

# get git revision
GITREV=$(git rev-parse --short HEAD)
echo -e "git revision HEAD id: $GITREV" >> /tmp/rpi-info.txt
echo >> /tmp/rpi-info.txt

# get storage information
df -h / | tail -1 | awk '{print "Root Partition (" $1 "):\n  - Total Size : " $2 "\n  - Used       : " $3 "\n  - Available  : " $4 "\n  - Usage      : " $5 "\n  - Mount Point: " $6}' >> /tmp/rpi-info.txt
echo >> /tmp/rpi-info.txt

# get available RAM and swap
free -h | awk '/Mem:/ {print "RAM Total: " $2 >> "/tmp/rpi-info.txt"; print "RAM Used: " $3 >> "/tmp/rpi-info.txt"; print "RAM Free: " $4 >> "/tmp/rpi-info.txt"}'
free -h | awk '/Swap:/ {print "Swap Total: " $2 >> "/tmp/rpi-info.txt"; print "Swap Used: " $3 >> "/tmp/rpi-info.txt"; print "Swap Free: " $4 >> "/tmp/rpi-info.txt"}'
echo >> /tmp/rpi-info.txt

# get current CPU usage
top -bn1 | grep "Cpu(s)" | awk '{print "CPU Used: " $2 + $4 "%"}' >> /tmp/rpi-info.txt

# get current CPU clock speed
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq ]; then
    cpufreq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)
    cpufreq_mhz=$((cpufreq / 1000))
    echo "CPU Clock Speed: ${cpufreq_mhz} MHz" >> /tmp/rpi-info.txt
else
    echo "CPU Clock Speed: Not available" >> /tmp/rpi-info.txt
fi
echo >> /tmp/rpi-info.txt

echo
cat /tmp/rpi-info.txt
echo

cd $HOME/.mame
