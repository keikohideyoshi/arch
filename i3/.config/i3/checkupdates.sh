#!/bin/bash
# Run the 'checkupdates' command and capture the output
num_updates=$(checkupdates | wc -l)
echo "$num_updates"
