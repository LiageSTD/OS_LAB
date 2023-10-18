#!/bin/bash

tempfile=$(mktemp)

for pid_dir in /proc/*/; do
    pid=$(basename "$pid_dir")

    if [ -d "$pid_dir" ] && [[ "$pid" =~ ^[0-9]+$ ]]; then

        ppid=$(grep -E 'PPid:' "$pid_dir/status" | awk '{print $2}')

        sum_exec_runtime=$(grep -E 'sum_exec_runtime' "$pid_dir/sched" | awk '{print $3}')

        nr_switches=$(grep -E 'nr_switches' "$pid_dir/sched" | awk '{print $3}')

        if [ -n "$sum_exec_runtime" ] && [ -n "$nr_switches" ] && [ "$nr_switches" -ne 0 ]; then
            ART=$(echo "scale=2; $sum_exec_runtime / $nr_switches" | bc)
        else
            ART=0.00
        fi

        echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$ART" >> "$tempfile"
    fi
done

sort -t '=' -k3 -n "$tempfile" > processes_4.log

rm "$tempfile"
