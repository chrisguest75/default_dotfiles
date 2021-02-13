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

# check code exists
if [[ $(command -v code) ]]; then
    code --install-extension hashicorp.terraform
    code --install-extension ms-python.python
    code --install-extension ms-vsliveshare.vsliveshare
    code --install-extension ms-vscode-remote.remote-ssh
    code --install-extension ms-vscode-remote.remote-ssh-edit
    code --install-extension timonwong.shellcheck
    code --install-extension exiasr.hadolint
    code --install-extension eamodio.gitlens
else
    echo "code is not-installed"
fi


