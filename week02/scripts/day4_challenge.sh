#!/usr/bin/env bash
 
echo "Current date is:"
date
echo "Current user is:"
whoami
echo "Hostname is:"
hostname
 
if [[ "$#" -eq 0 ]]; then
    echo "You must pass an argument to the script!"
    exit 1
fi
if [[ ! -f "$1" ]]; then
    echo "File $1 does not exist."
    exit 2
fi
file_att=$(ls -l $1)
echo $file_att