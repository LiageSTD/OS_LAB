#!/bin/bash

ps -u "liage" | wc -l > processes_1.log
ps -u "liage" -o pid,cmd >> processes_1.log
#$USER
