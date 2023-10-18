#!/bin/bash

for pid in $(ps -eo pid=) 
do
        if [[ -d "/proc/$pid/" ]] 
	then
        	echo "$pid:$(grep -s "read_bytes:" /proc/$pid/io | awk '{print $2}')" >> processes_7_temp.txt
	fi
done

sleep 10

for line in $(cat processes_7_temp.txt)
do
        pid=$(echo "$line" | cut -d: -f1)
	cmdline=$(ps -o cmd fp $pid | tail -1)
	before=$(echo "$line" | cut -d: -f2)
	if [[ -d "/proc/$pid/" ]]
        then
	        echo "$pid:$cmdline:$(echo "$(grep -s "read_bytes:" /proc/$pid/io | awk '{print $2}') - $before" | bc -l)" >> processes_7_temp_res.txt
	fi
done

cat processes_7_temp_res.txt | sort -t ':' -k3 -n -r | head -3

rm "processes_7_temp.txt"
rm "processes_7_temp_res.txt"
