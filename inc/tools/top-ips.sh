#!/bin/bash

echo "# TOP IP ADDRESSES";

# Extract IP addresses from the access log and display the top 20 most frequent ones
awk '{print $1}' "${_LOGFILE}" | sort | uniq -c | sort -rn | head -n 20;
