#!/bin/bash

systemtype=$(dpkg --print-architecture)
echo architecture = $systemtype

if [[ $systemtype != arm64 ]];then
        echo This project is not compatible with your device platform.  Aborting.
        echo
        echo
        exit 1
fi

cd $HOME/source

# if a previous mame folder exists, move into a date-time named folder
if [ -d "mame-danmons" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "mame-danmons" "mame-danmons-$foldername"

        echo -e Archiving existing mame folder ["mame-danmons"] into backup folder ["mame-danmons-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/danmons/mame_raspberrypi_cross_compile
# https://stickfreaks.com/mame/

mkdir mame-danmons
cd mame-danmons

# Get latest MAME version from official site
LATEST_VERSION=$(curl -s https://www.mamedev.org/release.html | grep -Eo 'MAME [0-9]+\.[0-9]+' | head -n 1 | grep -Eo '[0-9]+\.[0-9]+')

# Confirm version was found
if [ -z "$LATEST_VERSION" ]; then
  echo "Could not determine latest MAME version."
  exit 1
fi

# Construct filename and paths
FILENAME="mame_${LATEST_VERSION}_debian_13_trixie_arm64.7z"
BASE_URL="https://stickfreaks.com/mame"
FULL_URL="${BASE_URL}/${FILENAME}"
TARGET_DIR="/opt/mame-${LATEST_VERSION}"

# Check if target directory already exists
if [ -d "$TARGET_DIR" ]; then
  echo "Target directory $TARGET_DIR already exists. Aborting."
  exit 1
fi

# Download the archive
echo "Downloading $FILENAME..."
curl -O "$FULL_URL" || { echo "Download failed."; exit 1; }

# Extract using root privileges
echo "Extracting to $TARGET_DIR..."
sudo mkdir -p "$TARGET_DIR"
sudo 7z x "$FILENAME" -o"$TARGET_DIR" || { echo "Extraction failed."; exit 1; }

echo "Extraction complete."


exit


cd ..


echo
echo Done!
