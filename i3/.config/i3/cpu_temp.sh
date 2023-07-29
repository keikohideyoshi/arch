#!/bin/bash

# Check if lm_sensors package is installed
if ! command -v sensors &> /dev/null; then
    echo "lm_sensors package not found. Please install it first."
    exit 1
fi

# Get CPU temperature in Celsius using sensors
cpu_temp=$(sensors | grep '^temp1' | tail -n 1 | awk '{print $2}' | cut -c 2-8)

# Check if the temperature is obtained successfully
if [[ -z "$cpu_temp" ]]; then
    echo "Failed to get CPU temperature. Make sure sensors are properly configured."
    exit 1
fi

echo "${cpu_temp}"
