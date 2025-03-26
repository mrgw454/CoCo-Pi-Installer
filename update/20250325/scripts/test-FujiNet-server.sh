#!/bin/bash

# script to see FujiNet packet activity for helping with debugging
# adjust as needed for port, etc.


#socat  /dev/ttyUSB0,raw,echo=0  \
#    SYSTEM:'tee in.txt | socat - "PTY,link=/tmp/ttyV0,raw,echo=0,waitslave" | tee out.txt'

#socat -d -d pty,rawer,echo=0,link=/tmp/ttyV0, baud=57600 pty,rawer,echo=0,link=/tmp/ttyV1,baud=57600

socat -d -d pty,rawer,echo=0,link=/tmp/ttyV0, baud=57600
