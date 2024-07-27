#!/bin/bash
####################################
# Author: 
# Date: 
#
# This script lists out the top 10 file sizes of any specified directory. However, the path to the file has to be passed as a commandline argument.
#
# Version: v1
#####################################

path=$1
du -ah "${path}"| sort -hr | head -n 10 > /tmp/filesize.txt
echo "Top 10 files in ${path}"
cat /tmp/filesize.txt
rm /tmp/filesize.txt

