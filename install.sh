#!/usr/bin/env zsh
set -euf -o pipefail

readonly SCRIPT_PATH=${0:A}
readonly SCRIPT_DIR=$(dirname "${SCRIPT_PATH}")

echo "SCRIPT_PATH=${SCRIPT_PATH}"
echo "SCRIPT_DIR=${SCRIPT_DIR}"

if [[ -d "/Users/$USER/.oh-my-zsh" ]]; then 
    echo "Mac"
    export ZSH="/Users/$USER/.oh-my-zsh"
else
    echo "Linux"
    export ZSH="/home/$USER/.oh-my-zsh"
fi

#**************************************
#*
#**************************************

backup_and_linkfile() {
    local sourcefile=$1
    local targetfile=$2
    echo "Install ${targetfile}"
    if [[ ! -f ${targetfile}_backup ]]; then 
        # Does zshrc exist?
        if [[ -f ${targetfile} ]]; then 
            # Is zshrc already a symlink
            if ! readlink ${targetfile}; then 
                echo "${targetfile} moved to ${targetfile}_backup"
                mv ${targetfile} ${targetfile}_backup

                # shellcheck disable=SC2088
                echo "Linking ${targetfile}"
                # Create symlink to profile
                ln -s ${sourcefile} ${targetfile}
                echo "${targetfile} -> $(readlink ${targetfile})"
            else
                # shellcheck disable=SC2088
                echo "${targetfile} is already a symlink"
            fi
        else
            echo "${targetfile} does not exist"
            # shellcheck disable=SC2088
            echo "Linking ${targetfile}"
            # Create symlink to profile
            ln -s ${sourcefile} ${targetfile}
            echo "${targetfile} -> $(readlink ${targetfile})"
        fi
    else
        # shellcheck disable=SC2088
        echo "${targetfile}_backup backup file located.  Please rename and try again"
    fi
}

#**************************************
#* Start
#**************************************

backup_and_linkfile ${SCRIPT_DIR}/.zshrc ~/.zshrc
backup_and_linkfile ${SCRIPT_DIR}/git/$(hostname)/.gitconfig ~/.gitconfig
backup_and_linkfile ${SCRIPT_DIR}/tmux/.tmux_conf ~/.tmux_conf

# Copy over my theme
echo "Copying chrisguest.zsh-theme"
cp ${SCRIPT_DIR}/chrisguest.zsh-theme "${ZSH}/custom/themes"

echo "Installing powerlevel"
if [ -d "${ZSH}/custom/themes/powerlevel9k" ]; then 
    pushd ${ZSH}/custom/themes/powerlevel9k && git pull && popd 
else
    git clone https://github.com/bhilburn/powerlevel9k.git ${ZSH}/custom/themes/powerlevel9k
fi

# sudo apt install fontconfig
# git clone https://github.com/gabrielelana/awesome-terminal-fonts.git ../

# mkdir ~/.fonts
# cp ./build/* ~/.fonts
# fc-cache -fv ~/.fonts

# source ~/.fonts/*.sh

