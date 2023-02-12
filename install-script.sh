#!/bin/bash

# Update system
sudo pacman -Syu

# Install packages
sudo pacman -S vlc alsa-utils pavucontrol

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Installation was successful!"
else
    echo "There was an error during installation."
fi
