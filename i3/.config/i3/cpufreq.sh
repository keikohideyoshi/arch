#!/bin/bash

# Check if /proc/cpuinfo file exists
if [ ! -f /proc/cpuinfo ]; then
  echo "Error: /proc/cpuinfo file not found. This script requires a Linux-based system."
  exit 1
fi

# Get current CPU frequency
frequency=$(grep -m 1 "cpu MHz" /proc/cpuinfo | awk '{print $4}')

if [ -z "$frequency" ]; then
  echo "Error: Unable to retrieve CPU frequency."
  exit 1
fi

echo "$frequency MHz"
