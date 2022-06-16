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

    while IFS=, read -r extensionid
    do
        echo "Installing $extensionid"
        code --install-extension $extensionid
    done << EOF
hashicorp.terraform
ms-python.python
ms-vsliveshare.vsliveshare
ms-vscode-remote.remote-ssh
ms-vscode-remote.remote-ssh-edit
ms-vscode-remote.remote-containers
oderwat.indent-rainbow
timonwong.shellcheck
exiasr.hadolint
eamodio.gitlens
bbenoist.vagrant
donjayamanne.githistory
ms-azuretools.vscode-docker
ritwickdey.LiveServer
esbenp.prettier-vscode
dbaeumer.vscode-eslint
bierner.markdown-mermaid
esbenp.prettier-vscode
GitHub.codespaces
humao.rest-client
EOF
 
else
    echo "code is not-installed"
fi


