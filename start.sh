#!/bin/bash

function accessLogTools {
    local _VERSION="0.1.0";
    local _SOURCEDIR=$(realpath $( dirname "${BASH_SOURCE[0]}" ));

    echo "###################################";
    echo "# Access log tools v ${_VERSION}";
    echo -e "###################################\n";

    # Load config
    local _CONFIGFILE="${_SOURCEDIR}/config.sh";
    if [ ! -f "${_CONFIGFILE}" ]; then
        . "${_SOURCEDIR}/inc/install.sh";
    fi
    . "${_CONFIGFILE}";
    local _LOGFILE="${_LOGSDIR}/${_LOGFILENAME}";

    . "${_SOURCEDIR}/inc/checks.sh";


    # Alert

    # Load a function if it exists for the given command
    local _COMMAND="$1";
    local _FUNCTIONFILE="${_SOURCEDIR}/inc/tools/${_COMMAND}.sh";
    if [ -f "${_FUNCTIONFILE}" ]; then
        . "${_FUNCTIONFILE}";
    else
        echo "Error: Command '${_COMMAND}' not found. Use 'help' for a list of available commands.";
        return 1;
    fi

}


accessLogTools "$@";
