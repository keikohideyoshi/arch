#!/bin/bash

# Set swappiness

sudo echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.d/99-swappiness.conf