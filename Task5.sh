#!/bin/bash

tempfile=$(mktemp)

declare -A parent_art_sum

declare -A parent_child_count

for pid_dir in /proc/*/; do
    pid=$(basename "$pid_dir")

    if [ -d "$pid_dir" ] && [[ "$pid" =~ ^[0-9]+$ ]]; then
        ppid=$(grep -E '^PPid:' "$pid_dir/status" | awk '{print $2}')

        sum_exec_runtime=$(grep -E '^sum_exec_runtime' "$pid_dir/sched" | awk '{print $3}')
        
        nr_switches=$(grep -E '^nr_switches' "$pid_dir/sched" | awk '{print $3}')

        if [ -n "$sum_exec_runtime" ] && [ -n "$nr_switches" ] && [ "$nr_switches" -ne 0 ]; then
            ART=$(echo "scale=2; $sum_exec_runtime / $nr_switches" | bc)
        else
            ART=0.00
        fi

        echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$ART" >> "$tempfile"

        parent_art_sum["$ppid"]=$(echo "${parent_art_sum[$ppid]} + $ART" | bc)
        parent_child_count["$ppid"]=$((parent_child_count["$ppid"] + 1))
    fi
done

sort -t '=' -k5 -n "$tempfile" > sorted_results.txt

while IFS= read -r line; do
    ppid=$(echo "$line" | awk -F'=' '{print $4}')
    if [ -n "${parent_child_count[$ppid]}" ]; then
        avg_art=$(echo "scale=2; ${parent_art_sum[$ppid]} / ${parent_child_count[$ppid]}" | bc)
        echo "Average_Running_Children_of_ParentID=$ppid is $avg_art" >> sorted_results_with_avg.txt
    fi
    echo "$line" >> sorted_results_with_avg.txt
done < sorted_results.txt

cat sorted_results_with_avg.txt

rm "$tempfile" sorted_results.txt sorted_results_with_avg.txt
