#!/bin/bash

###############################################
# Author: Custyblak
# Date: 2/06/2024
# Description: This script deletes specified username from the server
#
# Version: v1
###############################################


# Exit on errors (set -e) is recommended but omitted here for clarity
# Uncomment if desired:
# set -e

# Function to get user confirmation with safety checks
get_confirmation() {
  local prompt="$1"
  local answer

  while true; do
    read -r -p "$prompt (y/N): " answer
    case $answer in
      [Yy])
        return 0  # User confirmed (exit code 0)
        ;;
      [Nn]*)
        echo "Aborting..."
        exit 1  # User canceled (exit code 1)
        ;;
      *)
        echo "Please enter 'y' or 'N'."
        ;;
    esac
  done
}

# Get username to delete (with validation)
read -p "Enter username to delete: " username

# Check if user exists (avoid deleting non-existent users)
if ! id -u "$username" >/dev/null 2>&1; then
  echo "Error: User '$username' does not exist."
  exit 1
fi

# Get confirmation before proceeding
get_confirmation "Are you sure you want to delete user '$username'?"

# Terminate processes owned by the user (safer alternative)
pkill -u "$username"

# Delete user's home directory (consider backups)
# Be VERY CAUTIOUS with this line. Uncomment only if intended.
# rm -rf /home/"$username"

# Delete the user account (requires root)
sudo userdel -r "$username"

echo "User '$username' has been deleted (excluding home directory)."

# Print a reminder about potential data loss (home directory)
echo "**WARNING:** The user's home directory (/home/$username) was not deleted."
echo "**Please ensure you have a backup of any important data before proceeding.**"
