#!/bin/bash

###################################
## Get IP Column
###################################

function accesslogtools_get_ip_column() {
    echo "${1}" | awk '{for(i=1;i<=NF;i++) if($i ~ /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/) {print i; exit}}'
}

###################################
## Get URL Column
###################################

function accesslogtools_get_url_column() {
    echo "${1}" | awk '{for(i=1;i<=NF;i++) if($i ~ /"GET|POST|PUT|DELETE|HEAD/) {print i+1; exit}}'
}

###################################
## Get User Agent Column
###################################

function accesslogtools_get_user_agent_column() {
    echo "${1}" | awk '{for(i=1;i<=NF;i++) if($i ~ /"Mozilla|curl|Wget|Python|Java|Go-http-client/) {print i; exit}}'
}

###################################
## Get status code column
###################################

function accesslogtools_get_status_code_column() {
    local _STATUSCODECOLUMN="";
    for i in {1..20}; do
        if [ "$(echo "${1}" | awk -v col="$i" '{print $col}')" -ge 100 ] 2>/dev/null && [ "$(echo "${1}" | awk -v col="$i" '{print $col}')" -le 599 ] 2>/dev/null; then
            _STATUSCODECOLUMN="$i";
            break;
        fi
    done
    if [ -z "${_STATUSCODECOLUMN}" ]; then
        echo "Error: Could not find status code column in log file.";
        exit 1;
    fi

    echo "${_STATUSCODECOLUMN}";
}
