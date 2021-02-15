# Default dotfiles
These are my dotfiles that I can copy around to different machines.

It works on Ubuntu (debian) and MacOs.  
## TODO
1. detect iterm shell extensions
1. dependence on oh-my-zsh?
1. aws-okta aliases for admin and not
1. linuxbrew.

## Installation
The install creates a set of symlinks for my profiles.  

```sh
# Run a status first to see if you have any existing symlinks for the files about to be replaced
./install.sh --status

# run the installer (you can also use unattended if on an VM/vagrantbox)
./install.sh
./install.sh --unattended

```
## Configure the iterm profiles

1. Goto iterm2 preferences -> preferences.
1. Set the directory to the iterm2 folder in this repo.
1. Click on profiles and import the profiles from json
1. Select powerline as the default. 
1. Ctrl+cmd+P will open a powerline terminal

## Installing the vscode settings.
This ensures that my terminal settings are reflected in the vscode terminal 

1) Load ```code .``` 
1) Open settings and select an option that opens ```settings.json```
1) Copy the contents of the repo ```./vscode/settings.json``` file into the existing copy. 
1) Shutdown and reopen vscode from the iterm terminal to get the ```$ITERM_PROFILE == "Powerline"``` variable. 
## Linux (GUI)
If on a Linux GUI you'll still have to manually change the font to hack fonts in the terminal preferences  

## How it works
It uses the hostname to determine the name of scripts to run to configure with custom settings. 

The .zshrc is linked to the install location. This connection is made during install.  

Load order:
1. .zshrc
1. ./machines/$(hostname)/$(hostname).zsh_config.sh
1. machines/default.sh
1. machines/$(hostname)/$(hostname).sh

## Installing powerline fonts on mac
This is handled by the brew bundle  

```sh
brew tap homebrew/cask-fonts
brew cask install font-hack-nerd-font
```

[Nerdfonts](https://www.nerdfonts.com/)  
[option-4-homebrew-fonts](https://github.com/ryanoasis/nerd-fonts#option-4-homebrew-fonts)

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

