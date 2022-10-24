# Default dotfiles

These are my dotfiles that I can copy around to different machines.

It works on Ubuntu (debian) and MacOs.  

## TODO

1. detect iterm shell extensions
1. dependence on oh-my-zsh?
1. aws-okta aliases for admin and not
1. linuxbrew.
1. default snaps to install
1. install oh-my-bash
1. switch mac over to using serial numbers

## Prepare machine to run install

### iSh

On a fresh iSh installation.

- [ ] Ensure app has been granted network rights and run `apk update` 
- [ ] Open terminal run `apk add git curl`  
- [ ] Create an sshkey, follow [08_ssh](https://github.com/chrisguest75/sysadmin_examples/blob/master/08_ssh/README.md)
- [ ] `git clone git@github.com:chrisguest75/default_dotfiles.git` or `git clone https://github.com/chrisguest75/default_dotfiles.git`  
- [ ] Create new config in `./git` and `./machines` folder for `"$MACHINE_NAME"`
- [ ] Install zsh and bash `apk add zsh bash`  
- [ ] Change login shell to /bin/zsh in `vi /etc/passwd`

### MacOSX

On a fresh MacOSX Catalina/Big Sur machine.
NOTE: I'll automate these steps at some point.  

- [ ] Open terminal run `git` and install xcode.  
- [ ] Create Code directory in home `mkdir -p ~/Code && cd ~/Code`  
- [ ] Create an sshkey, follow [08_ssh](https://github.com/chrisguest75/sysadmin_examples/blob/master/08_ssh/README.md)
- [ ] `git clone git@github.com:chrisguest75/default_dotfiles.git` or `git clone https://github.com/chrisguest75/default_dotfiles.git`  
- [ ] Machine names (used to locate config)
    ```sh
    defaults read /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName
	sudo scutil --get ComputerName 
    sudo scutil --get LocalHostName
    sudo scutil --get HostName 

    # change them
    export <MACHINE_NAME>
	sudo scutil --set ComputerName "$MACHINE_NAME"
    sudo scutil --set LocalHostName "$MACHINE_NAME"
    sudo scutil --set HostName "$MACHINE_NAME"
    ```
- [ ] Create new config in `./git` and `./machines` folder for `"$MACHINE_NAME"`
- [ ] Install `brew` from [https://brew.sh/](https://brew.sh/)  
- [ ] Install `zsh`  
- [ ] Install `oh-my-zsh` from [https://ohmyz.sh/](https://ohmyz.sh/)
- [ ] Install `oh-my-bash` from [https://ohmybash.nntoan.com/](https://ohmybash.nntoan.com/)  
- [ ] GNU tools on macosx
    ```sh
    brew install coreutils
    ```
- [ ] Install `default_dotfiles` 
    ```sh
    export MACHINE_NAME=<machinename>
    ./install.sh --status
    ```

### Final manual configuration

- [ ] Import the profile into iterm2 manually
- [ ] Use Spotlight to run and provide permissions to: 
    * docker
    * iterm2 import preferences
    * chrome 
    * spectacle permissions
    * vscode settings below
    * keepassx permissions
    * zoom screenshare permissions
- [ ] Credentials db
- [ ] Upload ssh key to github
- [ ] Add `Code` directory to finder
- [ ] Install OneNote 
- [ ] Install macosx defaults 
- [ ] Provision a VM using using vagrant [ref](https://github.com/chrisguest75/vagrant_machines)  
- [ ] `gh auth login`

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
1. Select powerline as the default
1. Ctrl+cmd+P will open a powerline terminal

## Installing the vscode settings

This ensures that my terminal settings are reflected in the vscode terminal 

1) Load `code .`
1) Open settings and select an option that opens `settings.json`.  Also located `~/Library/Application Support/Code/User/settings.json`
1) Copy the contents of the repo `./vscode/settings.json` file into the existing copy.
1) Shutdown and reopen vscode from the iterm terminal to get the `$ITERM_PROFILE == "Powerline"` variable.

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

## Installing using Ansible

[./ansible/README.md](./ansible/README.md)


## Other Software

* [NVM](https://github.com/nvm-sh/nvm)
* [Docker-Compose](https://docs.docker.com/compose/install/)

## Resources

* Example `defaults` on macosx [here](https://gist.github.com/bradp/bea76b16d3325f5c47d4)
* Example `defaults` on macosx [here](https://gist.github.com/dannysmith/9369950)

* Copy enable/disable extensions settings to another workspace [here](https://stackoverflow.com/questions/58765230/copy-enable-disable-extensions-settings-to-another-workspace)  
* Can you “force” VSCode extensions on your team’s PC’s? [here](https://www.waldo.be/2021/09/17/how-to-force-vscode-extensions-on-your-teams-pcs/)  
