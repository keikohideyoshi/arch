#!/bin/bash
while true; do
    cpu_usage=$(top -bn 1 | awk '/%Cpu/{print $2}' | cut -d. -f1)
    echo "$cpu_usage%"
    sleep 1
done
