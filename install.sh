#!/usr/bin/env bash
set -euf -o pipefail

if [[ ! -f ~/.zshrc_original ]]; then 
    mv ~/.zshrc ~/.zshrc_original
else
    echo "~/.zshrc_original backup file located.  Please rename and try again"
fi

# Copy over my theme
cp chrisguest.zsh-theme $ZSH/themes

# Create symlink to profile
ln -s /home/vagrant/Code/default_dotfiles/.zshrc ~/.zshrc


