#!/bin/bash

# https://github.com/beretta42/fip/blob/master/docs/build_fuzix.txt
# https://launchpad.net/~tormodvolden/+archive/ubuntu/m6809
# https://launchpad.net/~tormodvolden/+archive/ubuntu/m6809/+sourcepub/9805837/+listing-archive-extra


# create main level build folder for Brett's FIP installer
echo Creating main level build folder in $HOME/source/fip
echo
if [ -d $HOME/source/fip ]; then
	rm -rf fip
fi
mkdir $HOME/source/fip
cd $HOME/source/fip
echo
echo Main level build folder creation complete.
#read -p "Press any key to continue... " -n1 -s
echo
echo


# install GMP, MPFR, MPC libs (for gcc)
echo Installing required dependencies - if needed...
echo
# sudo apt-get install libgmp-dev libmpfr-dev libmpc-dev markdown mercurial subversion bison texinfo
echo
echo Dependency requirements complete.
#read -p "Press any key to continue... " -n1 -s
echo
echo


# get FUZIX
echo Getting FUZIX...
echo
if [ -d FUZIX ]; then
	rm -r FUZIX
fi
git clone https://github.com/EtchedPixels/FUZIX FUZIX
echo
echo FUZIX clone complete.
#read -p "Press any key to continue... " -n1 -s
echo
echo

# get lwtools
echo Getting lwtools...
echo
if [ -d lwtools ]; then
	rm -r lwtools
fi
hg clone http://lwtools.projects.l-w.ca/hg/ lwtools
echo
echo lwtools clone complete.
#read -p "Press any key to continue... " -n1 -s
echo
echo

# get gcc
echo Getting gcc...
echo
if [ -f gcc-4.6.4.tar.bz2 ]; then
	rm -r gcc-4.6.4.tar.bz2
fi
wget https://ftp.gnu.org/gnu/gcc/gcc-4.6.4/gcc-4.6.4.tar.bz2
tar -xjf gcc-4.6.4.tar.bz2
echo
echo Extraction of gcc-4.6.4 complete.
#read -p "Press any key to continue... " -n1 -s
echo
echo

# patch gcc with lwtools patch
echo Patching gcc...
echo
cd gcc-4.6.4

#patch -p1 <../lwtools/extra/gcc6809lw-4.6.4-7.patch
# change per Ciaran
patch -p1 <../lwtools/extra/gcc6809lw-4.6.4-9.patch

echo
echo Patching of gcc-4.6.4 complete.
#read -p "Press any key to continue... " -n1 -s
echo
echo
cd ..


# fix gcc-4.6.4/gcc/doc/gcc.text file
echo Fixing gcc-4.6.4/gcc/doc/gcc.text file...
echo
sed -i 's!@bye!@end tex\n@end multitable\n@end titlepage\n\n@bye!' gcc-4.6.4/gcc/doc/gcc.texi
if [ $? -eq 0 ]
then
  echo "Successfully modified gcc-4.6.4/doc/gcc.texi"
else
  echo "Failure to modifiy gcc-4.6.4/doc/gcc.texi" >&2
  echo
fi
echo
echo Fixing of gcc-4.6.4/gcc/doc/gcc.texi file complete.
#read -p "Press any key to continue... " -n1 -s
echo
echo


# fix gcc-4.6.4/config.sub file
echo Fixing gcc-4.6.4/config.sub file...
echo
sed -i 's!| avr32 !| avr32 | arm64 | aarch64 !' gcc-4.6.4/config.sub
if [ $? -eq 0 ]
then
  echo "Successfully modified gcc-4.6.4/config.sub"
else
  echo "Failure to modify gcc-4.6.4/config.sub" >&2
  echo
fi
echo
echo Fixing of gcc-4.6.4/config.sub file complete.
#read -p "Press any key to continue... " -n1 -s
echo
echo


# fix gcc-4.6.4/gcc/cfglayout.c
# change per Ciaran
sed -i '/#include "tm.h"/a#include "tm_p.h"' gcc-4.6.4/gcc/cfglayout.c
f [ $? -eq 0 ]
then
  echo "Successfully modified gcc-4.6.4/gcc/cfglayout.c"
else
  echo "Failure to modify gcc-4.6.4/gcc/cfglayout.c" >&2
  echo
fi
echo
echo Fixing of gcc-4.6.4/gcc/cfglayout.c file complete.
#read -p "Press any key to continue... " -n1 -s
echo
echo


# build and install lwtools
echo Building lwtools...
echo
cd lwtools
make
# sudo make install
echo
echo Building of lwtools complete.
#read -p "Press any key to continue... " -n1 -s
echo
echo
cd ..


# copy fuzix's version of gcc wrappers to path
echo Creating gcc wrappers, symlinks...
echo
# remove any existing files, symlinks prior to creating new ones
if [ -f /usr/local/bin/lwtools-ar.sh ]; then
        sudo rm -r /usr/local/bin/lwtools-ar.sh
fi

if [ -f /usr/local/bin/m6809-unknown-ar ]; then
        sudo rm -r /usr/local/bin/m6809-unknown-ar
fi

if [ -f /usr/local/bin/m6809-unknown-as ]; then
        sudo rm -r /usr/local/bin/m6809-unknown-as
fi

if [ -f /usr/local/bin/m6809-unknown-ld ]; then
        sudo rm -r /usr/local/bin/m6809-unknown-ld
fi

if [ -f /usr/local/bin/m6809-unknown-objcopy ]; then
        sudo rm -r /usr/local/bin/m6809-unknown-objcopy
fi

if [ -L /usr/local/bin/m6809-unknown-objump ]; then
        sudo rm -r /usr/local/bin/m6809-unknown-objump
fi

if [ -L /usr/local/bin/m6809-unknown-nm ]; then
        sudo rm -r /usr/local/bin/m6809-unknown-nm
fi

if [ -L /usr/local/bin/m6809-unknown-ranlib ]; then
        sudo rm -r /usr/local/bin/m6809-unknown-ranlib
fi
datestamp=$(date +%Y-%m-%d_%H.%M.%S)
ls -l /usr/local/bin > ./contents-of-usr_local_bin-$datestamp.txt
sudo cp FUZIX/Build/tools/* /usr/local/bin
# ln ranlib to ar
sudo ln -s /bin/true /usr/local/bin/m6809-unknown-ranlib
sudo ln -s /bin/true /usr/local/bin/m6809-unknown-nm
sudo ln -s /bin/true /usr/local/bin/m6809-unknown-objump
echo
echo Creation of gcc wrappers, symlinks complete.
#read -p "Press any key to continue... " -n1 -s
echo
echo


# setup gcc build directory
echo Configuring gcc...
echo
mkdir gcc-4.6.4-build
cd gcc-4.6.4-build
systemtype=$(dpkg --print-architecture)
echo architecture = $systemtype
echo
# run gcc's configure (based of Tormod's ppa config)
../gcc-4.6.4/configure  --build=$systemtype-linux --enable-languages=c --target=m6809-unknown --disable-libada --program-prefix=m6809-unknown- --enable-obsolete --disable-threads --disable-nls --disable-libssp --prefix=/usr/local --with-as=/usr/local/bin/m6809-unknown-as --with-ld=/usr/local/bin/m6809-unknown-ld --with-ar=/usr/local/bin/m6809-unknown-ar
echo
echo configure of gcc complete.
#read -p "Press any key to continue... " -n1 -s
echo
echo


# build gcc
echo Building gcc...
echo
make all-gcc
sudo make install-gcc
echo
echo Building of gcc complete.
#read -p "Press any key to continue... " -n1 -s
echo
echo


# build libgcc (compiler support library)
echo Building libgcc...
echo
make all-target-libgcc
sudo make install-target-libgcc
echo
echo Building of libgcc complete.
#read -p "Press any key to continue... " -n1 -s
echo
echo
cd ..

# get and build toolshed
echo Getting and building toolshed...
echo
hg clone http://hg.code.sf.net/p/toolshed/code toolshed-code
cd toolshed-code
make -C build/unix
#sudo make -C toolshed-code/build/unix install
echo
echo Building of toolshed complete.
#read -p "Press any key to continue... " -n1 -s
echo
echo
cd ..


# build FUZIX
# NOT building FUZIX at this time due to issues for the coco3 target
#export PATH=$PATH:$(pwd)/FUZIX/tools
#cd FUZIX/Kernel/platform-coco3
#./build
#cd ../../..


# Install bison
#sudo apt-get install -y byacc
#sudo update-alternatives --set yacc /usr/bin/byacc


# get fip installer
#git clone https://github.com/beretta42/fip
#mkdir fip/cbe/roms
#cp ../*.rom fip/cbe/roms
#cd fip
#make


# get lwwire
echo Getting and building lwwire...
echo
hg clone http://lwwire.projects.l-w.ca/hg/ lwwire
make -C lwwire/src
echo
echo Building of lwwire complete.
#read -p "Press any key to continue... " -n1 -s
echo
echo
cd ..


echo
echo Done!
echo
