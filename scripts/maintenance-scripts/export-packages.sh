#!/bin/bash

# Get the current date
current_date=$(date +"%Y-%m-%d")

# Run pacman to get a list of installed packages and save it to a file with the current date in the name
pacman -Qqe > installed_packages_${current_date}.txt

echo "List of installed packages saved to installed_packages_${current_date}.txt"
