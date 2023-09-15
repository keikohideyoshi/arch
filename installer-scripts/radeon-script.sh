#!/bin/bash

# Update system
clear
sudo pacman -Syu --noconfirm

sudo pacman -S mesa vulkan-radeon vulkan-tools lib32-vulkan-radeon --noconfirm

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Installation was successful!"
else
    echo "There was an error during installation."
fi
