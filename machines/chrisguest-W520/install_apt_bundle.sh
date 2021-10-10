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

apt-get update 

apt install shellcheck -y
apt install wget -y
apt install htop -y
apt install whiptail -y


apt install htop -y
apt install git -y
# github is installed using linuxbrew
#apt install gh -y
apt install git-extras -y

apt install tmux -y
apt install tmuxinator -y

apt install jq -y
#apt install yq -y

#apt install kubectx -y
#apt install skaffold -y
#apt install kubernetes-cli -y
#apt install kind -y

apt install imagemagick -y

apt install vagrant -y
#apt install gomplate -y

#apt install virtualbox -y
#apt install virtualbox-ext-pack -y   