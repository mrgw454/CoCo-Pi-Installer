clear

cd $HOME/.xroar

XROARPARMSFILE=`cat $HOME/.xroar/.optional_xroar_parameters.txt`
export XROARPARMS=$XROARPARMSFILE

clear

cd $HOME/.xroar
#xroar -c $HOME/.xroar/xroar.conf -default-machine coco2bus -machine-cart yados -ao-fragments 1
xroar -c $HOME/.xroar/xroar.conf -default-machine coco3 -machine-cart yados -v 2 $XROARPARMS

# capture XRoar ERRORLEVEL

if [ $? -eq 0 ]
then
        echo

else
        echo
        echo "Please make note of message above when requesting help."
        echo
        read -p  "Press any key to continue." -n1 -s
fi

cd $HOME/.mame
CoCoPi-menu-Coco3-XRoar.sh
exit
