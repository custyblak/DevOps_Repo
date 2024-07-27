#!/bin/bash

#############################################
# Author: Custyblak
# Date: 25/05/2024
#
# This script notifies the respective Github repository admin of new issues
#
# Version: v1
##############################################

#  Github API Url 
API_URL="https://api.github.com"


# Export your Github authentication
USERNAME=$username
TOKEN=$token

# Define arguments that will be called later in the scripts
REPO_OWNER=$1
REPO_NAME=$2


# Define a function to authenticate against the Github API URL
function auth {
  local endpoint="$1"
  local url="${API_URL}/${endpoint}"
  curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# This functions checks for issues within the issue section of the repository and pulls the title and body of the issues 
function check_issue {
  local url="repos/${REPO_OWNER}/${REPO_NAME}/issues"
  issue_data=$(auth "$url")

# Process issue_data with jq 
  title=$(echo "$issue_data" | jq -r '.[].title')
  body=$(echo "$issue_data" | jq -r '.[].body')
  
  new_issues=$("${title}:${body}")  
}

# This checks if the new_issue variable is empty or not. And if not empty, it prints out the issues.
function alert_admin {
  if [[ ! -z "$new_issues" ]]; then
    message="Hi Admin, new issue(s) in the repository - $new_issues"
    echo "$message" 
  else
    echo "No new issue updated"
  fi
}

check_issue
alert_admin  





