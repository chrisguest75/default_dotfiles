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
