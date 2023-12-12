#!/bin/bash

# Check if a file name is provided as an argument
if [ $# -eq 0 ]; then
    echo "Please provide the file name."
    exit 1
fi

file_name="$1"

# Check if the file exists
if [ -f "$file_name" ]; then
    # Read the file line by line and install each package using pacman
    while IFS= read -r package || [[ -n "$package" ]]; do
        sudo pacman -S --noconfirm "$package"
    done < "$file_name"
    echo "All packages from $file_name have been installed."
else
    echo "File '$file_name' not found."
fi
