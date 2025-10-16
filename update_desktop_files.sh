#!/bin/bash

# Get the current user's home directory
USER_HOME="$HOME"

# Define the base directory to search (adjust if needed)
SEARCH_DIR="$USER_HOME"

# Find all .desktop files under the user's home directory
find "$SEARCH_DIR" -type f -name "*.desktop" | while read -r desktop_file; do
    echo "Processing: $desktop_file"

    # Replace any /home/USERNAME with the current user's home path
    sed -i "s|/home/[^/]*/|$USER_HOME/|g" "$desktop_file"
done

echo "Update complete."

