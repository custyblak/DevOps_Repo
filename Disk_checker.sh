#!/bin/bash

#####################################
# Author: <Author's Name>
# Date: <Date of script creation>
#
# This script notifies the admin once the disk utilization exceeds 80%
# Version: v1
#####################################

echo "Linux server disk usage"

disk_size=$(df -h | grep /dev/sda3 | awk  '{print $5}' | cut -d '%' -f1) 

if [[ "$disk_size"  -ge 80 ]]; then
    echo "Disk utilization is at ${disk_size}%. Kindly plan expanding disk or deleting old storage"
else    
    echo "For now, more room for data"
fi
