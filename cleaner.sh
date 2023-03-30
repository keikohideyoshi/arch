#!/bin/bash
#Clean pacman cache

sudo pacman -Scc --noconfirm

#Remove old packages
sudo paccache -rk 1

#Remove temporary files
sudo rm -rf /tmp/*

#Clean journalctl logs
sudo journalctl --vacuum-size=50M 