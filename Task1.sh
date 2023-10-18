#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 <number1> <number2> <number3>"
    exit 1
fi
if [ $1 -gt $2 ] && [ $1 -gt $3 ]; then 
    echo "$1 is the maximum"
elif [ $2 -gt $1 ] && [ $2 -gt $3 ]; then
    echo "$2 is the maximum"
else 
    echo "$3 is the maximum"
fi