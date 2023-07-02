#!/bin/bash
echo "Enter the name of the package you want to install from AUR:"
read package_name
git clone https://aur.archlinux.org/"$package_name".git
cd "$package_name"
makepkg -si
cd ..
rm -rf "$package_name"