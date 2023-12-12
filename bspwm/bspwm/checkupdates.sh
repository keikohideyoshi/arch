#!/bin/bash
# Run the 'checkupdates' command and capture the output
sleep 10
num_updates=$(checkupdates | wc -l)
echo "$num_updates"
