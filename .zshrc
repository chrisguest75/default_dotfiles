# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

readonly PROFILE_SYMLINK_ZSHRC=$(readlink ~/.zshrc)
readonly PROFILE_SCRIPT_DIR=$(dirname "${PROFILE_SYMLINK_ZSHRC}")

OSNAME="$(uname -s)"
case "${OSNAME}" in
    Linux*)     readonly OSTYPE=LINUX;;
    Darwin*)    readonly OSTYPE=MAC;;
    CYGWIN*)    readonly OSTYPE=CYGWIN;;
    MINGW*)     readonly OSTYPE=MINGW;;
    *)          readonly OSTYPE="UNKNOWN:${OSNAME}"
esac
case "${OSTYPE}" in
    LINUX)     
        export OH_MY_ZSH_CONFIG="/home/$USER/.oh-my-zsh"
        export INSTALL_HOSTNAME=$(hostname)
    ;;
    MAC)    
        export OH_MY_ZSH_CONFIG="/Users/$USER/.oh-my-zsh"
        export INSTALL_HOSTNAME=$(scutil --get LocalHostName)
    ;;
    *)
        echo "${OSNAME} NOT RECOGNISED"        
        export OH_MY_ZSH_CONFIG="/home/$USER/.oh-my-zsh"
        export INSTALL_HOSTNAME=$(hostname)
    ;;
esac

export ZSH=${OH_MY_ZSH_CONFIG}
export ZSH_DISABLE_COMPFIX=true
ZSH_THEME="robbyrussell"

if [[ -f "${PROFILE_SCRIPT_DIR}/machines/${INSTALL_HOSTNAME}.zsh_config.sh" ]]; then 
    source "${PROFILE_SCRIPT_DIR}/machines/${INSTALL_HOSTNAME}.zsh_config.sh"
    MACHINE_CUSTOM_CONFIGURATION="${PROFILE_SCRIPT_DIR}/machines/${INSTALL_HOSTNAME}.sh"
else
    source "${PROFILE_SCRIPT_DIR}/machines/default.zsh_config.sh"
    MACHINE_CUSTOM_CONFIGURATION="${PROFILE_SCRIPT_DIR}/machines/default.sh"
fi

source $ZSH/oh-my-zsh.sh

# default aliases for all installations
source "${PROFILE_SCRIPT_DIR}/machines/all.sh"
# custom final configuration for a machine
source "${MACHINE_CUSTOM_CONFIGURATION}"
