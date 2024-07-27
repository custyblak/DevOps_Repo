#!/bin/bash

##################################################
# Author: Custyblak
# Date: 28/05/2024
# 
# This script deletes logs files of over 30 days within a specified path or directory
# 
# Version: v1
#################################################

# Specify the path or directory to the files that you want to delete as a commandline argument
path=$1

# Check if the files in that directory exceeds 30days
check_out=$(find "${path}" -mtime +30)
if [[ -z "$check_out" ]]; then
    echo "No file(s) older than 30 day in $path"
else
    echo "These files will be deleted"
    echo $check_out
    # Get the admin confirmation if to proceed with the deletion or not
    read -p "Proceed to delete these files? (y/n): " confirmation
    if [[ "$confirmation" == "y" ]]; then
        rm -f $check_out
        echo "File(s) deleted successfully"
    
    else
        exit

    fi
fi

# NB: The directory path to the files MUST be passed as a commandline argument.