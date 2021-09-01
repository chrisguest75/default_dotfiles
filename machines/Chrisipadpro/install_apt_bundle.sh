#!/usr/bin/env bash 
#Use !/bin/bash -x  for debugging 
#set -euf -o pipefail
set -uf -o pipefail

readonly SCRIPT_NAME=$(basename "$0")
readonly SCRIPT_PATH=${0}
# shellcheck disable=SC2034
readonly SCRIPT_DIR=$(realpath $(dirname "$SCRIPT_PATH"))


if [ -n "${DEBUG_ENVIRONMENT-}" ];then 
    # if DEBUG_ENVIRONMENT is set
    env
    export
fi

apk update 
apk add zsh
apk add openssh-client openssh-keygen
apk add bash

apk add mandoc man-pages

apk add shellcheck 

apk add git 
apk add git-extras 

apk add tmux 
apk add tmuxinator 

apk add jq 

apk add curl 
apk add vim

