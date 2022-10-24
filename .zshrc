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
	if [[ $(uname -a | grep "iSH") ]]; then      
            export OH_MY_ZSH_CONFIG="/$USER/.oh-my-zsh"
	else
	    export OH_MY_ZSH_CONFIG="/home/$USER/.oh-my-zsh"
	fi
        export INSTALL_HOSTNAME=$(hostname)
    ;;
    MAC)    
        export OH_MY_ZSH_CONFIG="/Users/$USER/.oh-my-zsh"

        SERIAL=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
        if [[ ${SERIAL} -eq "C02FX6FNMD6P" ]]; then
            export INSTALL_HOSTNAME="chrisguest-MacBook-Pro"
        else
            export INSTALL_HOSTNAME=$(scutil --get LocalHostName)
        fi
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
export BASE_MACHINE_DIR="${PROFILE_SCRIPT_DIR}/machines/${INSTALL_HOSTNAME}"
export DEFAULT_MACHINE_DIR="${PROFILE_SCRIPT_DIR}/machines/default"

if [[ -f "${BASE_MACHINE_DIR}/${INSTALL_HOSTNAME}.zsh_config.sh" ]]; then 
    #echo "Sourcing ${BASE_MACHINE_DIR}/${INSTALL_HOSTNAME}.zsh_config.sh"
    source "${BASE_MACHINE_DIR}/${INSTALL_HOSTNAME}.zsh_config.sh"
    MACHINE_CUSTOM_CONFIGURATION="${BASE_MACHINE_DIR}/${INSTALL_HOSTNAME}.sh"
else   
    source "${DEFAULT_MACHINE_DIR}/default.zsh_config.sh"
    MACHINE_CUSTOM_CONFIGURATION="${DEFAULT_MACHINE_DIR}/default.sh"
fi

source $ZSH/oh-my-zsh.sh

# default aliases for all installations
source "${PROFILE_SCRIPT_DIR}/machines/all.sh"
# custom final configuration for a machine
source "${MACHINE_CUSTOM_CONFIGURATION}"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

