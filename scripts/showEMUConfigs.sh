#!/bin/bash
# show emulator configuration files

clear
> msg.txt  # Ensure msg.txt is empty before appending

# Helper function to append listing if files exist
append_listing() {
    local pattern="$1"
    if compgen -G "$pattern" > /dev/null; then
        ls -l $pattern >> msg.txt
    else
        echo "No files found for pattern: $pattern" >> msg.txt
    fi
}

append_listing "$HOME/.mame/*.ini"
append_listing "$HOME/.mame/cfg/*.cfg"
append_listing "$HOME/.xroar/*.conf"
append_listing "$HOME/.ovcc/*.ini"
append_listing "$HOME/.ovcc/ini/*.ini"
append_listing "$HOME/.trs80gp/*.ini"

echo >> msg.txt
echo >> msg.txt

whiptail --title "Show Emulator Configuration File(s)" --textbox msg.txt 0 0
rm msg.txt

cd "$HOME/.mame"
