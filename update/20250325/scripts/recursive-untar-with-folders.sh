#!/bin/bash

# Function to extract a single tgz file
extract_tgz() {
  local tgz_file="$1"
  local dir_name="${tgz_file%.tgz}"

  # Create directory if it doesn't exist
  mkdir -p "$dir_name"

  # Extract the tgz file
  tar -xzf "$tgz_file" -C "$dir_name"

  echo "Extracted $tgz_file to $dir_name"
}

# Function to recursively find and extract tgz files
find_and_extract_tgz() {
  find . -name "*.tgz" -print0 | while IFS= read -r -d $'\0' tgz_file; do
    extract_tgz "$tgz_file"
  done
}

# Run the function
find_and_extract_tgz
