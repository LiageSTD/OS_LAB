#!/bin/bash

while true
do
  read line
  case $line in
    "+")
      kill -USR1 $(pgrep "Task6_p.sh")
      ;;
    "*")
      kill -USR2 $(pgrep "Task6_p.sh")
      ;;
    TERM)
      kill -SIGTERM $(pgrep "Task6_p.sh")
      exit
      ;;
    *)
      :
      ;;
  esac
done
