#!/bin/bash

free_memory=$(memory_pressure | grep "System-wide memory free percentage" | awk -F '[:%]' '{print $2}')

if ((free_memory < 30)); then
    echo 1
else
    echo 0
fi
