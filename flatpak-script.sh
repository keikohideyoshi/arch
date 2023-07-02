#!/bin/bash

# Update system
clear
sudo pacman -Syu --noconfirm

# Install flatpak packages

flatpak install flathub com.valvesoftware.Steam

flatpak install flathub com.usebottles.bottles

flatpak install flathub com.github.tchx84.Flatseal

flatpak install flathub com.spotify.Client