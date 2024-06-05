#!/bin/bash

cpu_load=$(top | awk '/average:/ {print $10}')

if [[ bc <<< ${cpu_load} > 1 ]]; then
    echo "CPU utilization is high: ${cpu_load}"
else
    echo "CPU utilization is normal"
fi

