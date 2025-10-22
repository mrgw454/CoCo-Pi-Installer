#!/bin/bash

cd $HOME/source

# if a previous mc6809-git folder exists, move into a date-time named folder

if [ -d "mc6809-git" ]; then

        foldername=$(date +%Y-%m-%d_%H.%M.%S)

        mv "mc6809-git" "mc6809-git-$foldername"

        echo -e Archiving existing mc6809-git folder ["mc6809-git"] into backup folder ["mc6809-git-$foldername"]
        echo -e
        echo -e
fi

# https://github.com/spc476/mc6809
git clone https://github.com/spc476/mc6809.git mc6809-git

cd mc6809-git

GITREV=`git rev-parse --short HEAD`

# Patch mc6809.h to define byte order
sed -i '/#  error You need to define the byte order/{
r /dev/stdin
d
}' mc6809.h <<'EOF'
#define LITTLE_ENDIAN 1

#if defined(LITTLE_ENDIAN)
#  define MSB 1
#  define LSB 0
#elif defined(BIG_ENDIAN)
#  define MSB 0
#  define LSB 1
#else
#  error You need to define the byte order
#endif
EOF

echo $(nproc) / 2 | bc
cores=$(echo $(nproc) / 2 | bc)
make -j$cores

if [ $? -eq 0 ]
then
        echo "compilation was successful.  Installing."
        echo
else
        echo "compilation was NOT successful.  Aborting."
        echo
	exit 1
fi

sudo make install

cd ..


echo
echo Done!
