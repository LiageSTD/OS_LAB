#!/bin/bash

max_memory=0
process_name=""

for pid_dir in /proc/*/; do
    pid=$(basename "$pid_dir")

    if [ -d "$pid_dir" ] && [[ "$pid" =~ ^[0-9]+$ ]]; then
        vmrss=$(grep -E '^VmRSS:' "$pid_dir/status" | awk '{print $2}')

        pname=$(grep -E '^Name:' "$pid_dir/status" | awk '{print $2}')

        if [ -n "$vmrss" ] && [ "$vmrss" -gt "$max_memory" ]; then
            max_memory="$vmrss"
            process_name="$pname"
        fi
    fi
done

echo "Процесс, потребляющий больше всего памяти:"
echo "Имя процесса: $process_name"
echo "Размер резидентной памяти (VmRSS): $max_memory KB"

echo "Сравним с выводом команды top:"
top -o %MEM -n 1 | head -n 12 | tail -n 1
