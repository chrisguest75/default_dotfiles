#!/usr/bin/env zsh
set -euf -o pipefail

readonly SCRIPT_PATH=${0:A}
readonly SCRIPT_DIR=$(dirname "${SCRIPT_PATH}")

echo "SCRIPT_PATH=${SCRIPT_PATH}"
echo "SCRIPT_DIR=${SCRIPT_DIR}"

if [[ -d "/Users/$USER/.oh-my-zsh" ]]; then 
    export ZSH="/Users/$USER/.oh-my-zsh"
    readonly INSTALL_OS="Mac"

    echo "Hostname (VPN): $(scutil --get HostName)"
    echo "LocalHostName: $(scutil --get LocalHostName)"
else

    export ZSH="/home/$USER/.oh-my-zsh"
    readonly INSTALL_OS="Linux"    
fi
echo "Hostname: $(hostname)"

INSTALL_FONT=true

echo "${INSTALL_OS}"
if [[ -f "${SCRIPT_DIR}/machines/$(hostname).env" ]]; then 
    source "${SCRIPT_DIR}/machines/$(hostname).env"
else
    if [[ -f "${SCRIPT_DIR}/machines/$(hostname).local.env" ]]; then 
        source "${SCRIPT_DIR}/machines/$(hostname).local.env"
    else    
        echo "Machine specific env profile configuration at '${SCRIPT_DIR}/machines/$(hostname).env' or '${SCRIPT_DIR}/machines/$(hostname).local.env' could not be found"
    fi
fi

#**************************************
#*
#**************************************

function backup_and_linkfile() {
    local sourcefile=$1
    local targetfile=$2
    echo "Installing ${targetfile}"
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
backup_and_linkfile ${SCRIPT_DIR}/tmux/.tmux.conf ~/.tmux.conf

echo "Installing vimrc - requires vim.plug"
if [ -d "~/.vim" ]; then 
    backup_and_linkfile ${SCRIPT_DIR}/vimrc/.vimrc ~/.vimrc
else
    echo "** Please install vim-plug https://github.com/junegunn/vim-plug **"
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

if [[ ${INSTALL_FONT} == true ]]; then 
    if [[ ${INSTALL_OS} == "Linux" ]]; then 
        echo "Installing Hack NerdFonts"

        if [ -d "~/.fonts" ]; then 
            wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Hack.zip -O ./downloads/Hack.zip
            unzip ./downloads/Hack.zip -d ./downloads/hack 
            mkdir -p ~/.fonts
            cp ./downloads/hack/* ~/.fonts
            fc-cache -fv ~/.fonts   
        else
            echo "Hack NerdFonts already installed"
        fi
    fi
else
    echo "Skipping installing fonts"
fi
echo "run > 'la ~/'"


#https://code.visualstudio.com/docs/getstarted/settings
#cat "$HOME/Library/Application Support/Code/User/settings.json"
