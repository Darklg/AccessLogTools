#!/bin/bash

echo "# TOP 404 ERRORS";

# Extract 404 errors from the access log and display them in a readable format
awk '$9 == 404 {print $1, $7}' "${_LOGFILE}" | sort | uniq -c | sort -rn | head -n 20;
