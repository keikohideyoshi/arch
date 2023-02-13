#!/bin/bash

# Update system
clear
sudo pacman -Syu --noconfirm

# Install flatpak packages

flatpak install flathub com.valvesoftware.Steam

flatpak install flathub com.usebottles.bottles

