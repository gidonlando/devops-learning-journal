#!/usr/bin/env bash

directory="$1"

if [[ -d "$directory" ]]; then
    disk_usage=$(du -sh "$directory")
    status=$?
    echo "$directory exists. Disk Usage:"
    echo "$disk_usage"
else
    echo "Directory does not exist"
fi