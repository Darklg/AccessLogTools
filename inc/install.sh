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
    echo "Error: Could not find logs directory. Please set _LOGSDIR variable in config.sh";
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
    echo "Error: Could not find log file in logs directory. Please set _LOGFILENAME variable in config.sh";
    exit 1;
fi

###################################
## Find columns
###################################

local _SAMPLELINE=$(head -n 1 "${_LOGSDIR}/${_LOGFILENAME}");
local _IPCOLUMN=$(echo "${_SAMPLELINE}" | awk '{for(i=1;i<=NF;i++) if($i ~ /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/) {print i; exit}}');
local _URLCOLUMN=$(echo "${_SAMPLELINE}" | awk '{for(i=1;i<=NF;i++) if($i ~ /"GET|POST|PUT|DELETE|HEAD/) {print i+1; exit}}');
local _STATUSCODECOLUMN="";
for i in {1..20}; do
    if [ "$(echo "${_SAMPLELINE}" | awk -v col="$i" '{print $col}')" -ge 100 ] 2>/dev/null && [ "$(echo "${_SAMPLELINE}" | awk -v col="$i" '{print $col}')" -le 599 ] 2>/dev/null; then
        _STATUSCODECOLUMN="$i";
        break;
    fi
done
if [ -z "${_STATUSCODECOLUMN}" ]; then
    echo "Error: Could not find status code column in log file. Please set _STATUSCODECOLUMN variable in config.sh";
    exit 1;
fi

###################################
## Save config
###################################

# Build config file content
local _CONFIGFILE_CONTENT=$(cat <<EOL
_LOGSDIR="${_LOGSDIR}"
_LOGFILENAME="${_LOGFILENAME}"
_IPCOLUMN=${_IPCOLUMN}
_URLCOLUMN=${_URLCOLUMN}
_STATUSCODECOLUMN=${_STATUSCODECOLUMN}
EOL
);

# Confirm config with user
echo -e "Current configuration:\n"
echo -e "${_CONFIGFILE_CONTENT}\n";
read -p "Press enter to continue...";

# Save config to file
echo -e "#!/bin/bash\n${_CONFIGFILE_CONTENT}" > "${_CONFIGFILE}";
