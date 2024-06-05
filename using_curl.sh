#!/bin/bash

#####################################
# Author: Custyblak
# Date: 30/05/2024
#
# This script uses curls to get the http response code from a URL. Also, showcasing the ways curl can be used.
#
# Version: v1
#####################################

URL=$1
echo "%{http_code}"

function using_curl {
    response=$(curl -s -w "%{http_code}" $URL)
    
    http1_code=$(tail -n1 <<< "response")

    if [[ $http1_code == 200 ]]; then
        echo "Request worked fine"

    else
        echo "Request failed"
    fi
}

using_curl