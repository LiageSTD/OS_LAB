#!/bin/bash

current=$(pwd)

home_directory=$HOME

if [ $current == $home_directory ]; then 
    echo "U're in home dir: $home_directory"
else 
    echo "U should be in home dir - $home_directory"
    exit 1
fi