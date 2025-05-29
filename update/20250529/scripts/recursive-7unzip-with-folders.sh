#!/bin/bash

shopt -s globstar
shopt -s extglob
shopt -s nocasematch

for f in "$PWD"/**/*
do

	if [[ $f == *.7z ]]; then

		dir=${f%.7z}
		#7z x -o"$dir" "$f"
		7z x -o"$dir" "$f" -aos

	fi

done

