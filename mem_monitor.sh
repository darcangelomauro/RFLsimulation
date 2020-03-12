#!/bin/bash

FILENAME=$1_mem_monitor.txt
touch $FILENAME

while true; do
echo $(sstat -n --noconvert -o MaxRSS $1.batch) >> $FILENAME
sleep 120
done
