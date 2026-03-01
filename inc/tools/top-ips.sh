#!/bin/bash

echo "# TOP IP ADDRESSES";

# Extract IP addresses from the access log and display the top 20 most frequent ones
awk -v ip_col="${_IPCOLUMN}" '{print $ip_col}' "${_LOGFILE}" | sort | uniq -c | sort -rn | head -n 20;
