#!/bin/bash

cpu_usage=$(top -l 1 -s 0 | grep "CPU usage" | awk -F'[:,%]' '{print $2}' | cut -d "." -f 1)

if ((cpu_usage > 50)); then
    echo 1
else
    echo 0
fi
