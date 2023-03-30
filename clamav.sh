#!/bin/bash
# Run ClamAV scan
scan_result=$(clamscan -r /home)

# Check if any viruses were found
if echo "$scan_result" | grep -q "Infected files: 0"; then
    message="ClamAV scan completed: no threats found"
else
    message="ClamAV scan completed: threats found"
fi

# Send notification
echo "$message"