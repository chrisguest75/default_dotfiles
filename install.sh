#!/usr/bin/env zsh
set -euf -o pipefail

readonly SCRIPT_PATH=${0:A}
readonly SCRIPT_DIR=$(dirname "${SCRIPT_PATH}")

echo "SCRIPT_PATH=${SCRIPT_PATH}"
echo "SCRIPT_DIR=${SCRIPT_DIR}"

# Is there a backup of config
if [[ ! -f ~/.zshrc_original ]]; then 
    # Does zshrc exist?
    if [[ -f ~/.zshrc ]]; then 
        # Is zshrc already a symlink
        if ! readlink ~/.zshrc; then 
            mv ~/.zshrc ~/.zshrc_original

            # shellcheck disable=SC2088
            echo "~/.zshrc does not exist"
            # Create symlink to profile
            ln -s ${SCRIPT_DIR}/.zshrc ~/.zshrc
        else
            # shellcheck disable=SC2088
            echo "~/.zshrc is already a symlink"
        fi
    fi
else
    # shellcheck disable=SC2088
    echo "~/.zshrc_original backup file located.  Please rename and try again"
fi

# Copy over my theme
cp ${SCRIPT_DIR}/chrisguest.zsh-theme "/home/${USER}/.oh-my-zsh/themes"



