#!/bin/bash

clear

echo
echo
echo
echo
echo
echo
echo
echo

echo "The following HDD images are available:"
echo

# Enable case-insensitive globbing
shopt -s nocaseglob nullglob

# Collect matching files and exclude symbolic links
files=()
for f in /media/share1/EMU/VHD/*.{dsk,img,vhd}; do
    if [ -f "$f" ] && [ ! -L "$f" ]; then
        files+=("$f")
    fi
done

# Disable nocaseglob to avoid affecting other parts of the script
shopt -u nocaseglob

# Check if any valid files were found
if [ ${#files[@]} -eq 0 ]; then
    echo "No valid HDD image files found in /media/share1/EMU/VHD/"
    exit 1
fi

# Set the prompt used by select
PS3=$'\nPlease select one to use as the default or type the number for stop to cancel: '

select filename in "${files[@]}"
do
    if [[ "$REPLY" == stop ]]; then
        echo "Operation cancelled."
        break
    fi

    if [[ -z "$filename" ]]; then
        echo "'$REPLY' is not a valid number"
        continue
    fi

    sudo rm -f /media/share1/EMU/VHD/HDD.DSK
    sudo ln -s "$filename" /media/share1/EMU/VHD/HDD.DSK
    echo
    echo "$filename is now the default HDD image."
    echo
    read -p "Press any key to continue... " -n1 -s
    echo
    break
done

cd $HOME/.mame

