#!/bin/bash

# Check if lm_sensors package is installed
if ! command -v sensors &> /dev/null; then
    echo "lm_sensors package not found. Please install it first."
    exit 1
fi

# Get GPU temperature in Celsius using sensors
gpu_fan=$(sensors | grep 'fan1' | cut -c 14-21)

echo "${gpu_fan}"
