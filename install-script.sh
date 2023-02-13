#!/bin/bash

# Update system
clear
sudo pacman -Syu --noconfirm

# Install SOUND packages
clear
echo "Installing sound packages."

sudo pacman -S vlc alsa-utils pavucontrol --noconfirm

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Installation was successful!"
else
    echo "There was an error during installation."
fi

# Install CONKY packages
echo "Installing conky-related packages."

sudo pacman -S conky lm_sensors pacman-contrib --noconfirm

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Installation was successful!"
else
    echo "There was an error during installation."
fi

# Install FIREWALL
echo "Installing firewall."

sudo pacman -S ufw --noconfirm

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Installation was successful!"
else
    echo "There was an error during installation."
fi

sudo ufw enable
sudo systemctl enable ufw.service

# Install NEOFETCH
echo "Installing neofetch."

sudo pacman -S neofetch --noconfirm

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Installation was successful!"
else
    echo "There was an error during installation."
fi

# Install THEMES
echo "Installing themes."

sudo pacman -S arc-gtk-theme papirus-icon-theme --noconfirm

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Installation was successful!"
else
    echo "There was an error during installation."
fi

# Install MISCELLANEOUS packages
echo "Installing miscellaneous packages."

sudo pacman -S chromium leafpad ristretto galculator gnome-multi-writer obs-studio shotcut thunderbird --noconfirm

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Installation was successful!"
else
    echo "There was an error during installation."
fi

# Install GAMING packages
echo "Installing gaming related packages."

sudo pacman -S flatpak mesa vulkan-radeon vulkan-tools lib32-vulkan-radeon wine wine-gecko wine-mono --noconfirm

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Installation was successful!"
else
    echo "There was an error during installation."
fi