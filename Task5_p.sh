#!/bin/bash

num=1
mode="0"

function ter() {
  kill $(pidof -x "Task5_g.sh")
  exit $1
}

(tail -f pipe) | while true
do
  read line
  case $line in
    "+")
      mode="0"
      ;;
    "*")
      mode="1"
      ;;
    QUIT)
      echo "Ответ: $num"
      kill $(pgrep "Task5_g.sh")
      exit 1
      ;;
    *)
      if [[ $(grep -o "^[-]\{0,1\}[1-9][0-9]\{0,\}$" <<< $line | wc -l) -gt 0 ]]
      then
        if [[ mode -eq 0 ]]
        then
          let num=$num+$line
        else
          let num=$num*$line
        fi
      else
        echo "Ошибка из-за $line"
        kill $(pgrep "Task5_g.sh")
	exit 0
      fi
      ;;
  esac
done
