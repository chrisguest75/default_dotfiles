
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH="/usr/local/sbin:$PATH"
# NOTE: Have to do this because curl is built into macosx
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH=$PATH:${PROFILE_SCRIPT_DIR}/shellscripts

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

source /usr/local/share/zsh/site-functions/aws_zsh_completer.sh

# TODO: Dynamically build these aliases.  
alias code="echo 'use code@default, code@experiment or code@work'"
alias code@experiment="/usr/local/bin/code --extensions-dir \"${HOME}/Code/default_dotfiles/vscode/experiment/profile/extensions\" --user-data-dir \"${HOME}/Code/default_dotfiles/vscode/experiment/profile/userdata\""
alias code@work="/usr/local/bin/code --extensions-dir \"${HOME}/Code/default_dotfiles/vscode/work/profile/extensions\" --user-data-dir \"${HOME}/Code/default_dotfiles/vscode/work/profile/userdata\""
alias code@default="/usr/local/bin/code --extensions-dir \"${HOME}/Code/default_dotfiles/vscode/default/profile/extensions\" --user-data-dir \"${HOME}/Code/default_dotfiles/vscode/default/profile/userdata\""

eval "$(pyenv init -)"

