#!/bin/bash

cd $HOME/source

# if a previous CMOC folder exists, move into a date-time named folder

if [ -d "CMOC" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "CMOC" "CMOC-$foldername"

        echo -e Archiving existing CMOC folder ["CMOC"] into backup folder ["CMOC-$foldername"]
        echo -e
        echo -e
fi


if [ ! -d CMOC ]; then
	mkdir CMOC
fi


# https://perso.b2b2c.ca/~sarrazip/dev/cmoc.html

cd CMOC

#wget --no-check-certificate https://perso.b2b2c.ca/~sarrazip/dev/cmoc.html
wget --no-check-certificate http://sarrazip.com/dev/cmoc.html
version=`grep "current version" cmoc.html | tail -c 8 | cut -c1-6`

echo
echo Latest version is: $version
echo

#wget --no-check-certificate https://perso.b2b2c.ca/~sarrazip/dev/cmoc-$version.tar.gz
wget --no-check-certificate http://gvlsywt.cluster051.hosting.ovh.net/dev/cmoc-$version.tar.gz


if [ ! -f cmoc-$version.tar.gz ]; then
	echo
	echo cmoc-$version.tar.gz archive does not exist.  Aborting.
	echo
	exit 1
fi

tar zxvf cmoc-$version.tar.gz --strip-components 1 -C $HOME/source/CMOC

./configure
make

sudo make install

wkhtmltopdf "http://sarrazip.com/dev/cmoc-manual.html" cmoc-manual.pdf
wkhtmltopdf "http://gvlsywt.cluster051.hosting.ovh.net/dev/cmoc-for-basic-programmers.html" cmoc-for-basic-programmers.pdf

cd ..


echo
echo Done!
