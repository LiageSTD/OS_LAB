#!/bin/bash

iotop -b -n 1 -o > iotop_output.txt

processes=$(grep -E '^  \d+' iotop_output.txt | head -n 3)

while read -r line; do
    pid=$(echo "$line" | awk '{print $1}')
    cmd=$(echo "$line" | awk '{$1=""; print $0}')
    io_data=$(echo "$line" | awk '{print $4}')

    echo "PID=$pid : Command=$cmd : Data_Read=$io_data"
done <<< "$processes"

rm iotop_output.txt
