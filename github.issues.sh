#!/bin/bash

#####################################################
# Author: Custyblak
# Date: 23/05/2024
# 
# This scripts updates the admins of a repository when new issues have been updated
# Version: v1
################################################

# Define variables

Admin_email=$1
USERNAME=$2
PASSWORD=$3
Repo_URL="https://api.github.com/repos/$2/DevOps_Repo/"

# Check for issues within the repository using the cURL command
function check_issues(){
	issue_data=$(curl $Repo_URL/issues | jq '.[]')

}

function alert_admin(){
	if [[ ! -z "$new_issue" ]]; then
		message="Hi Admin, $new_issue new issues in the repository."
		echo "$message" | mail -s "New Issues Reported" $1	
	fi
}

# Call the functions

check_issues
alert_admin

echo"Enter your username: $2"
echo"Enter your email: $1
