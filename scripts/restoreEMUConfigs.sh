#!/bin/bash
# backup emulator configuration files

clear

echo "This script will restore an archived copy of your"
echo "emulator configuration files."
echo
echo "WARNING - this will overwrite any existing configuration file(s)!"
echo
echo "The following emulator configuration file(s) are available:"
echo

# set the prompt used by select, replacing "#?"
PS3="
Please select one to use as the default or 'stop' to cancel:"

# allow the user to choose a file
select filename in /media/share1/backupEMUConfigs-*

do
    # leave the loop if the user says 'stop'
    if [[ "$REPLY" == stop ]]; then break; fi

    # complain if no file was selected, and loop to ask again
    if [[ "$filename" == "" ]]
    then
        echo "'$REPLY' is not a valid number"
        continue
    fi

    # now we can use the selected file
    tar xzvf "$filename" -C /
    echo
    read -p "Restore complete.  Press any key to continue." -n1 -s
    break
done

cd $HOME/.mame

