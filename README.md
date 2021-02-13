# Default dotfiles
These are my dotfiles that I can copy around to different machines.

## TODO
1. apt bundle?
1. detect iterm shell extensions
1. dependence on oh-my-zsh?

1. Install the vscode default configuration
1. Offer a check script to verify prereq installations.
    - brew installations
    - fonts  
1. Goto directories
1. aws-okta aliases for admin and not
1. Install tfenv and pipenv and landscape.  
1. linuxbrew.
1. configure iterm2
1. Configure terminal on linux

## Installation
The install creates a set of symlinks for my profiles.  

```sh
git clone 
./install.sh
```

## Homebrew Apps

```sh
cd ./brew
brew bundle install
```

## How it works
It uses the hostname to determine the name of scripts to run to configure with custom settings. 

The .zshrc is linked to the install location. This connection is made during install.  

Load order:
1. .zshrc
1. ./machines/$(hostname).zsh_config.sh
1. machines/default.sh
1. machines/$(hostname).sh


## Installing powerline fonts on mac

https://www.nerdfonts.com/
https://github.com/ryanoasis/nerd-fonts#option-4-homebrew-fonts

```
brew tap homebrew/cask-fonts
brew cask install font-hack-nerd-font
```

## Linux Terminal 
You'll still have to manually change the font to hack fonts in the terminal preferences  

## Vim
```sh
sudo apt install vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim
:PlugInstall
```

## Tmuxinator
```
https://github.com/tmuxinator/tmuxinator
```


## Installing using Ansible.
[./ansible/README.md](./ansible/README.md)