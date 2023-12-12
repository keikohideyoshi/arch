#!/bin/bash

# Check if lm_sensors package is installed
if ! command -v sensors &> /dev/null; then
    echo "lm_sensors package not found. Please install it first."
    exit 1
fi

# Get CPU temperature in Celsius using sensors
cpu_temp=$(sensors | grep 'Core 0' | cut -c 17-22)

# Check if the temperature is obtained successfully
if [[ -z "$cpu_temp" ]]; then
    echo "Failed to get CPU temperature. Make sure sensors are properly configured."
    exit 1
fi

echo "${cpu_temp}"
