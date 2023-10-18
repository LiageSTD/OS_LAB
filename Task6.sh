#!/bin/bash

max_memory=0
process_name=""
mpid=""

for pid_dir in /proc/*/; do
    pid=$(basename "$pid_dir")

    if [ -d "$pid_dir" ] && [[ "$pid" =~ ^[0-9]+$ ]]; then
        vmrss=$(grep -E 'VmRSS:' "$pid_dir/status" | awk '{print $2}')

        pname=$(grep -E 'Name:' "$pid_dir/status" | awk '{print $2}')

	pid=$(basename $pid_dir)
        if [ -n "$vmrss" ] && [ "$vmrss" -gt "$max_memory" ]; then
            max_memory="$vmrss"
            process_name="$pname"
	    mpid="$pid"
        fi
    fi
done

echo "Процесс, потребляющий больше всего памяти:"
echo "Id процесса: $mpid"
echo "Имя процесса: $process_name"
echo "Размер памяти: $max_memory"

echo "Сравним с выводом команды top:"
echo "Id процесса: $(top -b -n 1 | grep -A 1 "PID" | tail -n 1 | awk '{print $1}')"
echo "Размер памяти: $(top -b -n 1 | grep -A 1 "RES" | tail -n 1 | awk '{print $6}')"
