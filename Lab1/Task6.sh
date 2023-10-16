#!/bin/bash

grep '\] (WW)' /var/log/anaconda/X.log | sed 's/(WW)/Warning:/' > full.log
grep '\] (II)' /var/log/anaconda/X.log | sed 's/(II)/Information:/' >> full.log