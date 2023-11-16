#!/bin/bash

./Task4_1.sh &
./Task4_2.sh &
./Task4_3.sh &

cpulimit -p $(pgrep "Task4_1.sh") -l 10&

kill $(pgrep "Task4_3.sh")
