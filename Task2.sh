#!/bin/bash

sequence=""

while true; do
    read input
    if [ "$input" == "q" ]; then 
        break
    else 
        sequence="$sequence$input"
    fi
done
echo "$sequnece"