clear

echo
echo
echo
echo
echo
echo
echo
echo

echo Clearing all MAME and XRoar saved mount files...
echo

files=(
  "$HOME/.mame/.mame_floppy"
  "$HOME/.mame/.mame_rom"
  "$HOME/.xroar/.xroar_bin"
  "$HOME/.xroar/.xroar_cassette"
  "$HOME/.xroar/.xroar_floppy"
  "$HOME/.xroar/.xroar_rom"
)

for file in "${files[@]}"; do
  if [ -e "$file" ]; then
    rm "$file"
    echo "Deleted: $file"
  else
    #echo "Not found: $file"
    echo
  fi
done

echo
echo
echo Done!
echo
read -p "Press any key to continue." -n1 -s

cd $HOME/.mame


