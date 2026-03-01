#!/bin/bash

echo "# TOP 404 ERRORS";

# Extract 404 errors from the access log and display them in a readable format
awk -v status_col="${_STATUSCODECOLUMN}" -v url_col="${_URLCOLUMN}" '$status_col == 404 {print $url_col}' "${_LOGFILE}" | sort | uniq -c | sort -rn | head -n 20;

