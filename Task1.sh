#!/bin/bash

Td=$(date '+%d.%m.%y_%H:%M:%S')
mkdir ~/test && echo "catalog was created" >> ~/report.log && touch ~/test/"$Td"
ping -c 1 www.net_nikogo.ru || echo "err $Td - server is not responding" >> ~/report.log
