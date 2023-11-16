#!/bin/bash

num=1

function p() {
  let num=$num+2
  echo $num
}

function m() {
  let num=$num*2
  echo $num
}

function t() {
  echo "Ответ - $num"
  exit
}

trap 'p' USR1
trap 'm' USR2
trap 't' SIGTERM

while true
do
  sleep 1
done

