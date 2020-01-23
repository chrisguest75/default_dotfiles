
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

source /usr/local/share/zsh/site-functions/aws_zsh_completer.sh

source ~/Code/my_global_scripts/shell_type_load

# The next line updates PATH for the Google Cloud SDK.
if [ -f "/Users/${USER}/google-cloud-sdk/path.zsh.inc" ]; then . "/Users/${USER}/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "/Users/${USER}/google-cloud-sdk/completion.zsh.inc" ]; then . "/Users/${USER}/google-cloud-sdk/completion.zsh.inc"; fi
export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="$PATH:$HOME/Code/my_global_scripts"
export PATH="/usr/local/sbin:$PATH"
export PATH="$(go env GOPATH)/bin:$PATH"

export GOPATH=/Users/cguest/Code/conde/gopath

