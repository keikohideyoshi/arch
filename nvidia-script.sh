#!/bin/bash

# Update system
clear
sudo pacman -Syu --noconfirm

sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils vulkan-tools --noconfirm

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Installation was successful!"
else
    echo "There was an error during installation."
fi

