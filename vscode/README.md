# VSCODE

TODO:

* Check the .gitignore settings. https://github.com/git/git/blob/master/Documentation/git-check-ignore.txt

## Install settings

```sh
# list extensions
./vscode-configure-profiles.sh --profile=experiment --list  

# install extensions
./vscode-configure-profiles.sh --profile=experiment --install

# get the alias to copy to the zsh profile
# machines/${hostname}/chrisguest-MacBook-Pro.sh
./vscode-configure-profiles.sh --profile=experiment --alias

# sync settings.json using vscode diff
./vscode-configure-profiles.sh --profile=experiment --sync-settings
```

## Open workspaces

```sh
# list workspaces
./vscode-workspaces.sh --profile=default --list 

# filter list of workspaces
./vscode-workspaces.sh --profile=default --list --workspace=dotfiles

# start editing workspace
./vscode-workspaces.sh --profile=work --start --workspace=dotfile
```

## Info

This ensures that my terminal settings are reflected in the vscode terminal  

* Load `code .`
* Open settings and select an option that opens `settings.json`.  Also located `~/Library/Application Support/Code/User/settings.json`
* Copy the contents of the repo `./vscode/settings.json` file into the existing copy.
* Shutdown and reopen vscode from the iterm terminal to get the `$ITERM_PROFILE == "Powerline"` variable.

## Resources

* How to Create Code Profiles in VSCode [here](https://www.freecodecamp.org/news/how-to-create-code-profiles-in-vscode/)
* VSCode PRO-TIP: Code Profiles (multi-environment development) [here](https://sulmanweb.com/vscode-pro-tip-code-profiles-multi-environment-development/)
* Visual Studio Code Profiles [here](https://blog.theisleoffavalon.com/visual-studio-code-profiles/)
