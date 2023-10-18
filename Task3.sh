#!/bin/bash

ps -eo pid,stime --sort=-start | awk 'NR == 2 {print $1}' > processes_3.log
