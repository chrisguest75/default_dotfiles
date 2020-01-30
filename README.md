# Default dotfiles
These are my dotfiles that I can copy around to different machines.

## TODO
1. Powerlevel9k installation?
1. Offer a check script to verify prereq installations.
    - brew installations
    - fonts  
1. tmux configs
1. git config 
1. Goto directories
1. vim config?
1. aws-okta aliases for admin and not
1. Show shllvl for when in an awsokta prompt
1. Install tfenv and pipenv and landscape.  
1. linuxbrew.
1. configure iterm2

## Installation
The install creates a set of symlinks for my profiles.  

```
git clone 
./install.sh
```

## How it works
It uses the hostname to determine the name of scripts to run to configure with custom settings. 

The .zshrc is linked to the install location. This connection is made during install.  

Load order:
1. .zshrc
1. ./machines/$(hostname).zsh_config.sh
1. machines/default.sh
1. machines/$(hostname).sh


## Installing powerline fonts

```
https://www.nerdfonts.com/
https://github.com/ryanoasis/nerd-fonts#option-4-homebrew-fonts
```

