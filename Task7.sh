#!/bin/bash

for pid in $(ps -eo pid=)
do
        if ! [[ -d "/proc/$pid/" ]]
        then
                continue
        fi
        readed=$(grep -s "read_bytes:" /proc/$pid/io | awk '{print $2}')
        echo "$pid:$readed"
done > tmp.txt
sleep 60s
for line in $(cat tmp.txt)
do
        pid=$(echo "$line" | cut -d: -f1)
        cmd=$(ps -o cmd fp $pid | tail -1)
        start=$(echo "$line" | cut -d: -f2)
        if ! [[ -d "/proc/$pid/" ]]
        then
                continue
        fi
        end=$(grep -s "read_bytes:" /proc/$pid/io | awk '{print $2}')
        dist=$(($end - $start))
        echo "$pid:$cmd:$dist"
done | sort -t ':' -k3 -n -r | head -3
rm "tmp.txt"
