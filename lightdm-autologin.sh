#!/bin/bash

# Update system
clear
sudo pacman -Syu --noconfirm

sudo pacman -S sed --noconfirm

# Uncomment autologin settings in lightdm.conf
sudo sed -i 's/#autologin-user=/autologin-user=drszigetib/' /etc/lightdm/lightdm.conf
sudo sed -i 's/#autologin-user-timeout=0/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf
sudo sed -i 's/#autologin-guest=false/autologin-guest=false/' /etc/lightdm/lightdm.conf

# Create autologin group if it doesn't exist
#getent group autologin >/dev/null || groupadd autologin

# Add user to autologin group
#usermod -a -G autologin drszigetib

