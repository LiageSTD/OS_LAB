#!/bin/bash

if [ -f processes_4.log ]; then
	sum=0.0
	count=0.0
	ppid=""
	while read -r line; do
		curr_ppid=$(echo "$line" | awk -F '[:= ]' '{print $6}')
		curr_art=$(echo "$line" | awk -F '[:= ]' '{print $10}')
#		echo "ppid is $ppid     curr_ppid is $curr_ppid"
		if [ -z "$ppid" ]; then
			ppid="$curr_ppid"
#			count=1.0
#			sum=$(echo "$sum + $curr_art" | bc -l)
#			continue
		fi
		if [ "$ppid" != "$curr_ppid" ]; then
			avg=$(echo "scale=2; $sum / $count" | bc -l)
#			echo "WRITING"
			echo  "Average_Running_Children_of_ParentID= $ppid is $avg" >> processes_5.log
			sum=$curr_art
		#	echo "$curr_ppid      $ppid"
			ppid="$curr_ppid"
			count=1.0
		else
			sum=$(echo "$sum + $curr_art" | bc -l)
			count=$(echo "$count + 1.0" | bc -l)
		fi
	echo "$line" >> processes_5.log
	done < processes_4.log
	avg=$(echo "scale=2; $sum / $count" | bc)
	echo "Average_Running_Children_of_ParentID= $ppid is $avg" >> processes_5.log
else
	echo "There is no processes_4.log in directory"
fi
