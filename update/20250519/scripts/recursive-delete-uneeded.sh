#!/bin/bash

shopt -s globstar
shopt -s extglob
shopt -s nocasematch

find . -type f -iname '*.zip' -delete
find . -type f -iname '*.torrent' -delete
find . -type f -iname '*.gif' -delete
find . -type f -iname '*.txt' -delete
find . -type f -iname '*.png' -delete
find . -type f -iname '*.sqlite' -delete
find . -type f -iname '*.xml' -delete
find . -type f -iname '*.zip' -delete
find . -type f -iname '*.jpg' -delete
find . -type f -iname '*.jpeg' -delete
find . -type f -iname '*.tiff' -delete
find . -type f -iname '*.pdf' -delete
find . -type f -iname '*.nib' -delete
find . -type f -iname '*.ogv' -delete
find . -type f -iname '*.mp4' -delete
find . -type f -iname '*.mp3' -delete
find . -type f -iname '*.wav' -delete
find . -type f -iname '*.ogg' -delete
find . -type f -iname '*.htm*' -delete
find . -type f -iname '*.js' -delete
find . -type f -iname '*.doc' -delete
find . -type f -iname '*.bmp' -delete
find . -type f -iname '*.djvu' -delete
find . -type f -iname '*.class' -delete
find . -type f -iname '*.css' -delete
find . -type f -iname '*.flac' -delete
find . -type f -iname '*.cue' -delete
find . -type f -iname '*.bin' -delete
find . -type f -iname '*.md' -delete
find . -type f -iname '*.log' -delete
find . -type f -iname '*.py' -delete
find . -type f -iname '*.asc' -delete
find . -type f -iname '*.doc' -delete

# remove files with no extension
#find . -type f  ! -iname "*.*"  -delete

# AVG specific
#find . -type f -iname '*.atr' -delete
