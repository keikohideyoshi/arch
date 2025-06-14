#!/bin/bash

# Update system
clear
sudo pacman -Syu --noconfirm

sudo pacman -S 7zip bash-completion blueberry bluez bluez-utils chromium deepin-gtk-theme dkms dmenu featherpad firefox flameshot flatpak galculator git gnome-multi-writer gst-libav gst-plugin-pipewire gst-plugins-bad gvfs hunspell-hu hyphen-hu i3lock i3status i3-wm inxi iw iwd jq jre-openjdk kitty lib32-vulkan-radeon libreoffice-fresh libreoffice-fresh-hu lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings lutris lxappearance nano netctl networkmanager network-manager-applet nitrogen ntfs-3g obs-studio pacman-contrib papirus-icon-theme pipewire-alsa pipewire-jack pipewire-pulse plocate polybar python-pywal qbittorrent ristretto rofi shotcut speedtest-cli steam strawberry terminator thunar thunar-volman ttf-font-awesome udisks2 ufw unrar unzip virtualbox virtualbox-guest-iso virtualbox-host-modules-arch vlc vulkan-radeon vulkan-tools wine wine-gecko wine-mono wireplumber zip --noconfirm

yay -S arc-gtk-theme heroic-games-launcher neofetch onlyoffice-bin pinta rtl88x2bu-dkms-git spotify spotube-bin ttf-ms-fonts


