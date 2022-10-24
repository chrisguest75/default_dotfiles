#!/usr/bin/env bash
set -euf -o pipefail

readonly SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_PATH=${0}
# shellcheck disable=SC2034
readonly SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

if [ -n "${DEBUG_ENVIRONMENT-}" ];then 
    # if DEBUG_ENVIRONMENT is set
    env
    export
fi

function check_prerequisites() {
    for i in "$@"
    do
        local dependency=$i

        if [[ ! $(command -v "$dependency") ]]; then
            >&2 echo "$dependency is not-installed"
            exit 1
        fi
    done
}

function help() {
    cat <<- EOF
usage: $SCRIPT_NAME options

OPTIONS:
    -h --help -?               show this help

    -p|--profile=<name>        profile
    -d|--profile-dir=<path>    base path for profiles

    --list                     list extensions
    --install                  install extensions
    --alias                    alias for shell profiles
    --sync-settings            sync settings.json using code diff

Examples:
    $SCRIPT_NAME --help 

    list the extensions in the profile
    $SCRIPT_NAME --profile=default --list

    install the list of extensions for the profile
    $SCRIPT_NAME --profile=default --install

    print out the alias for the profile
    $SCRIPT_NAME --profile=default --alias

    diff the settings in the profile and the defaults
    $SCRIPT_NAME --profile=default --sync-settings

EOF
}

LIST=false
INSTALL=false
ALIAS=false
SYNCSETTINGS=false
PROFILE=
PROFILE_DIR=${SCRIPT_DIR}

for i in "$@"
do
case $i in
    -h|--help)
        help
        exit 0
    ;; 
    --list)
        LIST=true
    ;;     
    --install)
        INSTALL=true
    ;;  
    --alias)
        ALIAS=true
    ;; 
    --sync-settings)
        SYNCSETTINGS=true
    ;;             
    -p=*|--profile=*)
        PROFILE="${i#*=}"
        shift # past argument=value
    ;;     
    -d=*|--profile-dir=*)
        PROFILE_DIR="${i#*=}"
        shift # past argument=value
    ;;     
esac
done    

OSNAME="$(uname -s)"
case "${OSNAME}" in
    Linux*)     readonly OSTYPE=LINUX;;
    Darwin*)    readonly OSTYPE=MAC;;
    CYGWIN*)    readonly OSTYPE=CYGWIN;;
    MINGW*)     readonly OSTYPE=MINGW;;
    *)          readonly OSTYPE="UNKNOWN:${OSNAME}"
esac

_supported=false
case "${OSTYPE}" in
    MAC)    
        _supported=true
    ;;
    LINUX)     
    ;;
    CYGWIN)
    ;;
    MINGW)
    ;;
    *)
    ;;
esac

if [[ $_supported == false ]]; then
    >&2 echo "${OSTYPE} is not-supported"
    exit 1
fi

check_prerequisites jq git code
if [[ -z ${PROFILE} ]]; then 
    >&2 echo "--profile is not set"
    exit 1
else
    if [[ ! -d "${PROFILE_DIR}/${PROFILE}" ]]; then 
        >&2 echo "'${PROFILE}' not found in '${PROFILE_DIR}'"
        exit 1
    fi
fi

if [ $LIST == false ] && [ $INSTALL == false ] && [ $ALIAS == false ] && [ $SYNCSETTINGS == false ]; then
    help
    exit 0
else
    if [[ $ALIAS == true ]]; then
        echo "alias code@${PROFILE}=\"code --extensions-dir \\\"${PROFILE_DIR}/${PROFILE}/profile/extensions\\\" --user-data-dir \\\"${PROFILE_DIR}/${PROFILE}/profile/userdata\\\"\""
    fi

    if [[ $LIST == true ]]; then
        echo "code --extensions-dir \"${PROFILE_DIR}/${PROFILE}/profile/extensions\" --user-data-dir \"${PROFILE_DIR}/${PROFILE}/profile/userdata\" --list-extensions"
        code --extensions-dir "${PROFILE_DIR}/${PROFILE}/profile/extensions" --user-data-dir "${PROFILE_DIR}/${PROFILE}/profile/userdata" --list-extensions
    fi

    if [[ $INSTALL == true ]]; then
        echo "Installing ${PROFILE}/extensions.json"
        if [[ ! -f "${PROFILE_DIR}/${PROFILE}/extensions.json" ]]; then 
            >&2 echo "'${PROFILE_DIR}/${PROFILE}/extensions.json' not found"
            exit 1
        fi

        while IFS=" ", read -r extension 
        do
            echo "Install $extension"
            echo "code --extensions-dir \"${PROFILE_DIR}/${PROFILE}/profile/extensions\" --user-data-dir \"${PROFILE_DIR}/${PROFILE}/profile/userdata\" --install-extension $extension"
            code --extensions-dir "${PROFILE_DIR}/${PROFILE}/profile/extensions" --user-data-dir "${PROFILE_DIR}/${PROFILE}/profile/userdata" --install-extension $extension 
        done < <(jq -c -r '.[]' ${PROFILE_DIR}/${PROFILE}/extensions.json)
    fi

    if [[ $SYNCSETTINGS == true ]]; then
        echo "code --extensions-dir \"${PROFILE_DIR}/${PROFILE}/profile/extensions\" --user-data-dir \"${PROFILE_DIR}/${PROFILE}/profile/userdata\" --diff \"${PROFILE_DIR}/${PROFILE}/profile/userdata/User/settings.json\" \"${PROFILE_DIR}/${PROFILE}/settings.json\""
        code --extensions-dir "${PROFILE_DIR}/${PROFILE}/profile/extensions" --user-data-dir "${PROFILE_DIR}/${PROFILE}/profile/userdata" --diff "${PROFILE_DIR}/${PROFILE}/profile/userdata/User/settings.json" "${PROFILE_DIR}/${PROFILE}/settings.json" 
    fi
fi
