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

    -w|--workspace=<name>      workspace regex         
    -p|--profile=<name>        profile      

    --list                     list workspaces
    --start                    start workspace

Examples:
    $SCRIPT_NAME --help 

    list all the workspaces
    $SCRIPT_NAME --profile=default --list

    list a set of workspaces
    $SCRIPT_NAME --profile=default --list --workspace=\/shell_examples

    start vscode in folder
    $SCRIPT_NAME --profile=default --start --workspace=shell_examples
EOF
}

LIST=false
START=false
WORKSPACE=
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
    --start)
        START=true
    ;;     
    -w=*|--workspace=*)
        WORKSPACE="${i#*=}"
        shift # past argument=value
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

check_prerequisites jq

if [[ -z ${PROFILE} ]]; then 
    >&2 echo "--profile is not set"
    exit 1
else
    if [[ ! -d "${PROFILE_DIR}/${PROFILE}" ]]; then 
        >&2 echo "'${PROFILE}' not found in '${PROFILE_DIR}'"
        exit 1
    fi
fi

if [ $LIST == false ] && [ $START == false ]; then
    help
    exit 0
else
    if [[ $LIST == true ]]; then
        PROJECT="${WORKSPACE}$"
        WORKSPACE_BASE_PATH="${PROFILE_DIR}/${PROFILE}/profile/userdata"

        find "${WORKSPACE_BASE_PATH}" -iname "workspace.json" -exec jq --arg filename {} -c '. | {"folder": .folder, "filename": $filename}' {} \; | jq -s '.' | jq --arg project "${PROJECT}" '.[] | select(.folder != null) | select(.folder | test(".*\( $project )"))' | jq -s .
    fi
    
    if [[ $START == true ]]; then
        if [[ -z ${WORKSPACE} ]]; then 
            >&2 echo "--workspace is not set"
            exit 1
        fi
        PROJECT="${WORKSPACE}$"
        WORKSPACE_BASE_PATH="${PROFILE_DIR}/${PROFILE}/profile/userdata"
        # react_examples (end with '$' means we only want parent directory)

        echo "Searching for '${PROJECT}'..."
        WORKSPACEPATH=$(find "${WORKSPACE_BASE_PATH}" -iname "workspace.json" -exec jq --arg filename {} -c '. | {"folder": .folder, "filename": $filename}' {} \; | jq -s '.' | jq --arg project "${PROJECT}" '.[] | select(.folder != null) | select(.folder | test(".*\( $project )"))' | jq -s -r '.[].folder' | head -n 1)

        #echo "WORKSPACEPATH='${WORKSPACEPATH}'"
        REALWORKSPACEPATH="${WORKSPACEPATH//file:\/\//}" 
        #echo "REALWORKSPACEPATH='${REALWORKSPACEPATH}'"

        if [[ -z ${REALWORKSPACEPATH} ]]; then 
            >&2 echo "workspace '${PROJECT}' does not exist in profile '${PROFILE}'"
            exit 1
        fi

        # need to execute this in bash
        echo "code --extensions-dir \"${PROFILE_DIR}/${PROFILE}/profile/extensions\" --user-data-dir \"${PROFILE_DIR}/${PROFILE}/profile/userdata\" \"${REALWORKSPACEPATH}\""
        code --extensions-dir "${PROFILE_DIR}/${PROFILE}/profile/extensions" --user-data-dir "${PROFILE_DIR}/${PROFILE}/profile/userdata" "${REALWORKSPACEPATH}"
        #"code@${PROFILE}" "${REALWORKSPACEPATH}"
        #./vscode-run-zsh.sh "${PROFILE}" "${REALWORKSPACEPATH}"
    fi
fi
