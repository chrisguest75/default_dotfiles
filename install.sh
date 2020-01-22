#!/usr/bin/env zsh
set -euf -o pipefail

# Is there a backup of config
if [[ ! -f ~/.zshrc_original ]]; then 
    # Does zshrc exist?
    if [[ -f ~/.zshrc ]]; then 
        # Is zshrc already a symlink
        if ! readlink ~/.zshrc; then 
            mv ~/.zshrc ~/.zshrc_original
        else
            # shellcheck disable=SC2088
            echo "~/.zshrc is already a symlink"
        fi
    else
        # shellcheck disable=SC2088
        echo "~/.zshrc does not exist"
        # Create symlink to profile
        ln -s /home/vagrant/Code/default_dotfiles/.zshrc ~/.zshrc
    fi
else
    # shellcheck disable=SC2088
    echo "~/.zshrc_original backup file located.  Please rename and try again"
fi

# Copy over my theme
cp chrisguest.zsh-theme "$ZSH/themes"



