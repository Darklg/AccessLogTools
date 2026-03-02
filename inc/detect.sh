#!/bin/bash

###################################
## Find logs dir
###################################

local _POTENTIALLOGSDIRS=(
    "/opt/homebrew/var/log/httpd/"
    "/usr/local/var/log/httpd/"
    "$HOME/ik-logs/"
    "/var/log/apache2/"
);

local _LOGSDIR="";
for _POTENTIALLOGSDIR in "${_POTENTIALLOGSDIRS[@]}"; do
    if [ -d "${_POTENTIALLOGSDIR}" ]; then
        _LOGSDIR="${_POTENTIALLOGSDIR}";
        break;
    fi
done
if [ -z "${_LOGSDIR}" ]; then
    echo "Error: Could not find logs directory. Please set --logfilename option.";
    exit 1;
fi

###################################
## Find log file name
###################################

local _POTENTIALLOGFILENAMES=(
    "access.log"
    "access_log"
    "access.log.1"
    "access_log.1"
);
local _LOGFILENAME="";
for _POTENTIALLOGFILENAME in "${_POTENTIALLOGFILENAMES[@]}"; do
    if [ -f "${_LOGSDIR}/${_POTENTIALLOGFILENAME}" ]; then
        _LOGFILENAME="${_POTENTIALLOGFILENAME}";
        break;
    fi
done
if [ -z "${_LOGFILENAME}" ]; then
    echo "Error: Could not find log file in logs directory. Please set --logfilename option.";
    exit 1;
fi

###################################
## Use argument if provided
###################################

if [ -n "${_LOGFILEARG}" ]; then
    if [ -f "${_LOGFILEARG}" ]; then
        _LOGFILENAME=$(basename "${_LOGFILEARG}");
        _LOGSDIR=$(dirname "${_LOGFILEARG}");
    else
        echo "Error: Log file specified in --logfile does not exist.";
        exit 1;
    fi
fi

###################################
## Find columns
###################################

local _SAMPLELINE=$(head -n 1 "${_LOGSDIR}/${_LOGFILENAME}");
local _IPCOLUMN=$(accesslogtools_get_ip_column "${_SAMPLELINE}");
local _URLCOLUMN=$(accesslogtools_get_url_column "${_SAMPLELINE}");
local _STATUSCODECOLUMN=$(accesslogtools_get_status_code_column "${_SAMPLELINE}");

###################################
## Set global variables
###################################

local _LOGFILE="${_LOGSDIR}/${_LOGFILENAME}";
