#!/bin/bash

# this is for emulation only (Becker port)
# adjust for your specific configuration

# install prerequisites
sudo apt -y install python3-venv python3-distutils-extra python3-jinja2 libexpat1-dev libmbedtls-dev libbsd-dev python3-importlib-resources python3-importlib-metadata doxygen graphviz libargtable2-dev

cd $HOME/source

# if a previous fujinet-pc-CoCo folder exists, move into a date-time named folder

if [ -d "fujinet-pc-CoCo" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "fujinet-pc-CoCo" "fujinet-pc-CoCo-$foldername"

        echo -e Archiving existing fujinet-pc-CoCo folder ["fujinet-pc-CoCo"] into backup folder ["fujinet-pc-CoCo-$foldername"]
        echo -e
        echo -e
fi

git clone https://github.com/FujiNetWIFI/fujinet-firmware.git fujinet-pc-CoCo

cd fujinet-pc-CoCo

# select a commit that still works
#git checkout 1.5.0

# Fetch all tags to ensure we have the full tag list
git fetch --tags >/dev/null 2>&1

echo
echo "Retrieving the 10 most recent tags..."
echo

# Get the 10 most recent tags by creation date
mapfile -t TAGS < <(git for-each-ref --sort=-creatordate --format='%(refname:short)' refs/tags | head -n 10)

# Display menu
i=1
for tag in "${TAGS[@]}"; do
    echo "  $i) $tag"
    ((i++))
done

echo
read -p "Select a tag number to check out: " choice

# Validate input
if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#TAGS[@]} )); then
    echo "Invalid selection. Aborting."
    exit 1
fi

SELECTED="${TAGS[$((choice-1))]}"

echo
echo "Checking out tag: $SELECTED"
git checkout "$SELECTED"
echo

GITREV=`git rev-parse --short HEAD`

if [ ! -f platformio.ini ]; then
	cp platformio-sample.ini platformio.ini
fi

mkdir build

./build.sh -b -p COCO


if [ -f $HOME/source/fujinet-pc-CoCo/build/dist/fujinet ]; then
	echo fujinet binary exists.
       	echo
       	echo "Compilation was successful."
	echo
else
	echo fujinet binary does NOT exist!
	echo
	echo "Compilation was NOT successful.  Attempting to run ./build.sh script again..."
        echo

	./build.sh -b -p COCO

	if [ -f $HOME/source/fujinet-pc-CoCo/build/dist/fujinet ]; then

		echo fujinet binary exists.
       		echo
       		echo "Compilation was successful."
		echo
	else
		echo fujinet binary does NOT exist!
		echo
		echo "Compilation was NOT successful.  Aborting installation."
        	echo

		exit 1
	fi
fi


# set SERIAL port parameters
sed -i '/Serial/,$s/port=/port=\/dev\/ttyUSB2/' build/dist/fnconfig.ini
sed -i '/port=\/dev\/ttyUSB2/a baud=57600' build/dist/fnconfig.ini

# enable BECKER port
sed -i '/[BOIP]/{n; s/enabled=0/enabled=1/}' build/dist/fnconfig.ini


cd ..


echo
echo Done!
