#!/bin/bash

# Alert if log file is not found
if [ ! -f "${_LOGFILE}" ]; then
    echo "/!\ Error: Log file not found at ${_LOGFILE}. Please check your configuration.";
    exit 1;
fi

# Alert if log file is too heavy
if [ "$(wc -c < "${_LOGFILE}")" -gt $((50 * 1024 * 1024)) ]; then
    echo -e "/!\ Warning: Log file weights $(du -h "${_LOGFILE}" | cut -f1). Some commands may be slow.\n";
fi
