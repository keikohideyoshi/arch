#!/bin/bash

# Update system
clear
sudo pacman -Syu --noconfirm

# Install SOUND packages
clear
echo "Installing sound packages."

sudo pacman -S vlc pulseaudio pulseaudio-alsa --noconfirm

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

sudo pacman -S chromium leafpad ristretto galculator gnome-multi-writer obs-studio shotcut nitrogen python-pywal thunderbird flameshot sed ttf-font-awesome zip unzip p7zip gvfs udisks2 thunar thunar-volman ntfs-3g --noconfirm

sudo systemctl enable fstrim.timer

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Installation was successful!"
else
    echo "There was an error during installation."
fi

# Install GAMING packages
echo "Installing gaming related packages."

sudo pacman -S flatpak wine wine-gecko wine-mono lutris steam --noconfirm

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Installation was successful!"
else
    echo "There was an error during installation."
fi

# Install OFFICE packages
echo "Installing office related packages."

sudo pacman -S libreoffice-fresh libreoffice-fresh-hu hunspell hunspell-hu hyphen hyphen-hu --noconfirm

yay -S ttf-ms-fonts

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Installation was successful!"
else
    echo "There was an error during installation."
fi

# Install WIFI packages
echo "Installing office related packages."

sudo pacman -S iw iwd networkmanager network-manager-applet netctl --noconfirm

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Installation was successful!"
else
    echo "There was an error during installation."
fi

# Install HOME OFFICE packages
echo "Installing office related packages."

sudo pacman -S openconnect remmina freerdp --noconfirm

yay -S vmware-horizon-client

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Installation was successful!"
else
    echo "There was an error during installation."
fi
