#!/bin/bash

grep -rEiho --text '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}' /etc/ | sort -u | paste -sd "," > email.lst