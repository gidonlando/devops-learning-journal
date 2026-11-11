#!/usr/bin/env bash

if [[ $1 ]]; then
    echo "there is an argument"
fi
counter=1

while (( counter <= $# )); do
    echo "${!counter}"
    if [[ ! -d "${!counter}" ]]; then
        echo "${!counter} does not exist"
    else
        du -sh "${!counter}" 2>> multi-check-errors.log
    fi
    ((counter++))
done