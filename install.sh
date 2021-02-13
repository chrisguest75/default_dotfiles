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

#**************************************
#*
#**************************************

function backup_and_linkfile() {
    local sourcefile=$1
    local targetfile=$2
    echo "Installing ${targetfile} linking to ${sourcefile}"
    echo "***************************"    
    echo "Existing backups"
    find $(dirname "$targetfile") -maxdepth 1 -type f -name "$(basename $targetfile)*" 
    echo "***************************"    

    # Does file exist?
    if [[ -f ${targetfile} ]]; then 
        # Is zshrc already a symlink
        if ! readlink ${targetfile}; then 
            local datebackup="${targetfile}_backup$(date +'%H%M%S-%m_%d_%Y')"
            echo "${targetfile} moved to ${datebackup}"
            mv ${targetfile} "${datebackup}"

            # shellcheck disable=SC2088
            echo "Linking ${targetfile}"
            # Create symlink to profile
            ln -sf ${sourcefile} ${targetfile}
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
        ln -sf ${sourcefile} ${targetfile}
        echo "${targetfile} -> $(readlink ${targetfile})"
    fi
}


UNATTENDED=false
TIMEOUT=100
for i in "$@"
do
    case $i in
    --unattended)     
        readonly UNATTENDED=true
        readonly TIMEOUT=1
    ;;
    --status) 
        ls -la ~/.zshrc
        ls -la ~/.vimrc
        ls -la ~/.tmux.conf
        ls -la ~/.gitconfig
        exit 0
    ;;    
esac 
done



# Detect the OS type
OSNAME="$(uname -s)"
case "${OSNAME}" in
    Linux*)     readonly OSTYPE=LINUX;;
    Darwin*)    readonly OSTYPE=MAC;;
    CYGWIN*)    readonly OSTYPE=CYGWIN;;
    MINGW*)     readonly OSTYPE=MINGW;;
    *)          readonly OSTYPE="UNKNOWN:${OSNAME}"
esac

echo "OSTYPE:      ${OSTYPE}"
echo "SCRIPT_NAME: ${SCRIPT_NAME}"
echo "SCRIPT_PATH: ${SCRIPT_PATH}"
echo "SCRIPT_DIR:  ${SCRIPT_DIR}"
echo "UNATTENDED:  ${UNATTENDED}"
echo "USER:        $(whoami)"

case "${OSTYPE}" in
    LINUX)     
        export OH_MY_ZSH_CONFIG="/home/$USER/.oh-my-zsh"
        echo "lsb_release: $(lsb_release -a)"
        echo "Hostname: $(hostname)"

        export INSTALL_HOSTNAME=$(hostname)
        INSTALL_FONT=true
    ;;
    MAC)    
        export OH_MY_ZSH_CONFIG="/Users/$USER/.oh-my-zsh"
        echo "productName: $(sw_vers -productName)"
        echo "productVersion: $(sw_vers -productVersion)"
        echo "buildVersion: $(sw_vers -buildVersion)"
        echo "Hostname (VPN): $(scutil --get HostName)"
        echo "LocalHostName: $(scutil --get LocalHostName)"
        export INSTALL_HOSTNAME=$(scutil --get LocalHostName)
        INSTALL_FONT=false
    ;;
    CYGWIN)
    ;;
    MINGW)
    ;;
    *)
    ;;
esac

export BASE_MACHINE_DIR="${SCRIPT_DIR}/machines/${INSTALL_HOSTNAME}"
export DEFAULT_MACHINE_DIR="${SCRIPT_DIR}/machines/default"

if [[ -f "${BASE_MACHINE_DIR}/${INSTALL_HOSTNAME}.env" ]]; then 
    echo "Sourcing ${BASE_MACHINE_DIR}/${INSTALL_HOSTNAME}.env"
    source "${BASE_MACHINE_DIR}/${INSTALL_HOSTNAME}.env"
else    
    echo "Machine specific env profile configuration at '${BASE_MACHINE_DIR}/${INSTALL_HOSTNAME}.env' could not be found"
    echo "Falling back to ${DEFAULT_MACHINE_DIR}/default.env"
    echo ""
    echo "**********************************************************"    
    read -t ${TIMEOUT} -p "Would you like to install the defaults? Y/n " yescontinue
    if [ "$UNATTENDED" == true  ] || [ "$yescontinue" == ""  ] || [ "$yescontinue" == "Y"  ] || [ "$yescontinue" == "y"  ]  ; then    
        echo "Sourcing ${DEFAULT_MACHINE_DIR}/default.env"
        source "${DEFAULT_MACHINE_DIR}/default.env"

        # set hostname to default
        INSTALL_HOSTNAME="default"
    else
        echo ""
        echo "**********************************************************"    
        echo "Skipping default configuration installation"
        exit 1
    fi
fi

#**************************************
#* Start
#**************************************
export BASE_MACHINE_DIR="${SCRIPT_DIR}/machines/${INSTALL_HOSTNAME}"

case "${OSTYPE}" in
    LINUX)  
        echo ""
        echo "**********************************************************"    
        read -t ${TIMEOUT} -p "Would you like to install the Apt bundle (sudo password required)? Y/n " yescontinue
        if [ "$UNATTENDED" == true  ] || [ "$yescontinue" == ""  ] || [ "$yescontinue" == "Y"  ] || [ "$yescontinue" == "y"  ]  ; then
            pushd ${BASE_MACHINE_DIR}
            sudo bash -c ./install_apt_bundle.sh     
            popd
        else
            echo "Skipping the apt install"
        fi  
    ;;
    MAC)    
        echo ""
        echo "**********************************************************"    
        read -t ${TIMEOUT} -p "Would you like to install the Brew bundle? Y/n " yescontinue
        if [ "$UNATTENDED" == true  ] || [ "$yescontinue" == ""  ] || [ "$yescontinue" == "Y"  ] || [ "$yescontinue" == "y"  ]  ; then
            pushd ${BASE_MACHINE_DIR}
            brew bundle install
            popd
        else
            echo "Skipping the brew install"
        fi
    ;;
    *)
    ;;
esac

echo ""
echo "**********************************************************"    
echo "Git Config"
echo "**********************************************************"    
if [[ -f "${SCRIPT_DIR}/git/${INSTALL_HOSTNAME}/.gitconfig" ]]; then 
    backup_and_linkfile ${SCRIPT_DIR}/git/${INSTALL_HOSTNAME}/.gitconfig ~/.gitconfig
    git config --global --list  
else
    echo "Skipping .gitconfig as ${SCRIPT_DIR}/git/${INSTALL_HOSTNAME}/.gitconfig does not exist"
fi

echo ""
echo "**********************************************************"    
echo "Tmux"
echo "**********************************************************"    
backup_and_linkfile ${SCRIPT_DIR}/tmux/.tmux.conf ~/.tmux.conf

echo ""
echo "**********************************************************"    
echo ".zshrc"
echo "**********************************************************"    
backup_and_linkfile ${SCRIPT_DIR}/.zshrc ~/.zshrc

echo ""
echo "**********************************************************"    
echo "Powerlevel9k"
echo "**********************************************************"    
if [ -d "${ZSH}/custom/themes/powerlevel9k" ]; then 
    pushd ${ZSH}/custom/themes/powerlevel9k && git pull && popd 
else
    git clone https://github.com/bhilburn/powerlevel9k.git ${ZSH}/custom/themes/powerlevel9k
fi

echo ""
echo "**********************************************************"    
read -t ${TIMEOUT} -p "Would you like to install the extensions for vscode? Y/n " yescontinue
if [ "$UNATTENDED" == true  ] || [ "$yescontinue" == ""  ] || [ "$yescontinue" == "Y"  ] || [ "$yescontinue" == "y"  ]  ; then
    pushd ./vscode
    ./install_extensions.sh     
    echo "****************************"    
    echo " code extensions"
    echo "****************************"      
    ./list_extensions.sh  
    popd
else
    echo "Skipping the code extensions install"
fi

echo ""
echo "**********************************************************"    
echo "Hack NerdFonts Linux"
echo "**********************************************************"  
if [[ ${INSTALL_FONT} == true ]]; then 
    if [[ ${OSTYPE} == "LINUX" ]]; then 
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
    echo "Skipping installing Hack NerdFonts"
fi

echo ""
echo "**********************************************************"    
echo "Installation complete"
echo "**********************************************************"    

# echo "Installing vimrc - requires vim.plug"
# if [[ -f ~/.vim/autoload/plug.vim ]]; then 
#     backup_and_linkfile ${SCRIPT_DIR}/vimrc/.vimrc ~/.vimrc
# else
#     echo "** Please install vim-plug https://github.com/junegunn/vim-plug **"
# fi

# # Copy over my theme
# echo "Copying chrisguest.zsh-theme"
# cp ${SCRIPT_DIR}/chrisguest.zsh-theme "${ZSH}/custom/themes"





#https://code.visualstudio.com/docs/getstarted/settings
#cat "$HOME/Library/Application Support/Code/User/settings.json"



# Update this script to be more interactive.  

# Determine OS
# Check host name
# Load in env to configure defaults
# Split out vagrant machines
# Install vscode extensions
# Brew bundle

# [oh-my-zsh] Insecure completion-dependent directories detected:
# drwxrwxr-x   7 cguest  admin  224 11 Feb 20:44 /usr/local/share/zsh
# drwxrwxr-x  16 cguest  admin  512 12 Feb 09:49 /usr/local/share/zsh/site-functions

# [oh-my-zsh] For safety, we will not load completions from these directories until
# [oh-my-zsh] you fix their permissions and ownership and restart zsh.
# [oh-my-zsh] See the above list for directories with group or other writability.

# [oh-my-zsh] To fix your permissions you can do so by disabling
# [oh-my-zsh] the write permission of "group" and "others" and making sure that the
# [oh-my-zsh] owner of these directories is either root or your current user.
# [oh-my-zsh] The following command may help:
# [oh-my-zsh]     compaudit | xargs chmod g-w,o-w

# [oh-my-zsh] If the above didn't help or you want to skip the verification of
# [oh-my-zsh] insecure directories you can set the variable ZSH_DISABLE_COMPFIX to
# [oh-my-zsh] "true" before oh-my-zsh is sourced in your zshrc file.


