#!/bin/bash

pidstat 1 60 -d | grep -v '^Linux' | grep -v '^# ' | awk '$2 ~ /^[0-9]/' > pidstat_output.txt

processes=$(cat pidstat_output.txt | tail -n +3 | sort -k6 -n -r | head -n 3)

while read -r line; do
    pid=$(echo "$line" | awk '{print $1}')
    cmd=$(echo "$line" | awk '{$1=""; $2=""; print $0}')
    io_data=$(echo "$line" | awk '{print $6}')

    echo "PID=$pid : Command=$cmd : Data_Read=$io_data"
done <<< "$processes"

rm pidstat_output.txt
