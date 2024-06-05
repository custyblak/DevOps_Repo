#!/bin/bash
###########################################
# Author: Custyblak
# Date: 28/05/2024
# 
# This script to automate the installation of multiple software packages at once.
# Version: v1
###########################################


# Check if any software names are provided as arguments

if [ $# -eq 0 ]; then
    echo "Enter at least on the commandline the name of one software package"
    exit 1
fi

# Check if the script is running with root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "Command should be ran as root or as sudo user"
    exit 2
fi
# Loop through each software name provided as arguments
for softwares in $@; do
    # Check if the software is already installed using 'which'
    if which $softwares &> /dev/null; then
        echo "${softwares} is already installed"
    else
        # Install the software
        echo "Installing the ${softwares} software............."
        apt install $softwares -y &> /dev/null

        # Check the exit code of the 'apt install' command
        if [ $? -eq 0 ]; then
            echo "${softwares} successfully installed"
        else
            echo "Unable to install ${softwares}"
        fi

    fi
done





