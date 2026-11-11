#!/usr/bin/env bash

counter=1

while (( counter <= 5 )); do
    echo "Iteration: $counter"
    ((counter++))
done
