#!/bin/bash

function accessLogTools {
    local _VERSION="0.2.2";
    local _SOURCEDIR=$(realpath $( dirname "${BASH_SOURCE[0]}" ));
    local _LOGFILEARG="";

    echo "###################################";
    echo "# Access log tools v ${_VERSION}";
    echo -e "###################################\n";

    # Detect arguments
    for arg in "$@"; do
        case "$arg" in
            --logfile=*)
                _LOGFILEARG="${arg#*=}"
                if [ ! -f "${_LOGFILEARG}" ]; then
                    echo "Error: Log file specified in --logfile does not exist.";
                    return 0;
                fi
                ;;
        esac
    done

    # Auto-detect values
    . "${_SOURCEDIR}/inc/detect.sh";

    # Load functions
    . "${_SOURCEDIR}/inc/functions.sh";

    # Basic checks
    . "${_SOURCEDIR}/inc/checks.sh";

    # Load a function if it exists for the given command
    local _COMMAND="$1";
    local _FUNCTIONFILE="${_SOURCEDIR}/inc/tools/${_COMMAND}.sh";
    if [ -f "${_FUNCTIONFILE}" ]; then
        . "${_FUNCTIONFILE}";
    else
        . "${_SOURCEDIR}/inc/tools/help.sh";
    fi

    . "${_SOURCEDIR}/inc/stop.sh";
}

accessLogTools "$@";
