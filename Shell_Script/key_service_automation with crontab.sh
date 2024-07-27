#!/bin/bash

########################################
# Author: Custyblak
# Date: 27/05/2024
#
# This script automatically ensures that key services like firewalls are always up and running. 
# Using the crontab, the script is automated to run every minute
#
# Version: v1
##########################################

# Follow the purpose of testing, this script will be used to automatically restart the ufw service once stopped.
# NB: Other critical services can be done the same way. Just edit the script with the specific service.


echo "----Status check on UFW service----"
status=$(systemctl status ufw.service | awk '/Active:/ {print $2}')
echo "The service is $status"

if [ $status == "active" ]; then
    echo "Service is running fine"
else
    echo "service is not running"
    sudo systemctl start ufw.service
    systemctl status ufw.service
    
fi
