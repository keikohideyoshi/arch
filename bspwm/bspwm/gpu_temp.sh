#!/bin/bash

# Check if lm_sensors package is installed
if ! command -v sensors &> /dev/null; then
    echo "lm_sensors package not found. Please install it first."
    exit 1
fi

# Get GPU temperature in Celsius using sensors
gpu_temp=$(sensors | grep 'edge' | cut -c 16-19)

# Check if the temperature is obtained successfully
if [[ -z "$gpu_temp" ]]; then
    echo "Failed to get CPU temperature. Make sure sensors are properly configured."
    exit 1
fi

echo "${gpu_temp}°C"
