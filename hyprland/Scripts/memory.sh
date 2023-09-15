#!/bin/bash

# Get the total memory and free memory in kilobytes
total_memory=$(free -k | awk 'NR==2 {print $2}')
free_memory=$(free -k | awk 'NR==2 {print $4}')

# Convert kilobytes to megabytes
total_memory_mb=$((total_memory / 1024))
free_memory_mb=$((free_memory / 1024))

echo "$total_memory_mb MB / $free_memory_mb MB"

