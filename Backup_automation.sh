#!/bin/bash
################################
# Author: Custyblak
# Date: 31/05/2024
#
# This script backups specified directory path 
# 
# Version: v1
##################################

if [ $# -eq 0 ]; then
    echo "Kindly pass the directory path you want to backup"
    exit 1
fi

bkup_dest_dir="/root/backup"
mkdir -p $bkup_dest_dir
backup_date=$(date +%b-%d-%y)


echo "Starting backup of: $@"

for item in "$@"; do
    sudo tar -Pczf /tmp/$item-$backup_date.tar.gz $item

    if [ $? -eq 0 ]; then
        echo "$item backup successful."
    else    
        echo "$item backup failed."
    fi

    cp /tmp/$item-$backup_date.tar.gz $bkup_dest_dir

    if [ $? -eq 0 ]; then
        echo "$item Backup file transfer, successful."
    else
        echo "$item Backup file transfer, failed."
    fi
done

sudo rm /tmp/*.gz
echo "Backup is done"
    
