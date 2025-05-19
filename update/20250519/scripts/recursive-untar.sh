#!/bin/bash

# Function to extract a single tar file
extract_tar() {
  local tar_file="$1"
  local dir_name="${tar_file%.tar}"

  # Create directory if it doesn't exist
  mkdir -p "$dir_name"

  # Extract the tar file
  tar -xvf "$tar_file" -C "$dir_name"

  echo "Extracted $tar_file to $dir_name"
}

# Function to recursively find and extract tar files
find_and_extract_tar() {
  find . -name "*.tar" -print0 | while IFS= read -r -d $'\0' tar_file; do
    extract_tar "$tar_file"
  done
}

# Run the function
find_and_extract_tar
