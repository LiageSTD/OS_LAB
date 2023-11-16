#!/bin/bash

at now+1minute -f "Task1.sh"
tail -n 0 -f ~/report.log &
