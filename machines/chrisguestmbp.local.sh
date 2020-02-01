

#export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
# export MANPATH="/usr/local/man:$MANPATH"

export PATH=$PATH:/usr/local/share/dotnet

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# NOTE: Have to do this because curl is built into macosx
export PATH="/usr/local/opt/curl/bin:$PATH"

export PATH=$PATH:${PROFILE_SCRIPT_DIR}/shellscripts

source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'

eval "$(pyenv init -)"

export PATH=$PATH:~/Code/Scratch/GDG/Flutter/flutter/bin