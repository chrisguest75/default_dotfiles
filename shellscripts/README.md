# SHELL SCRIPTS

Here are some example shellscripts.

## container_versions

Print out the versions of containers on a GCP container registry.  
Setup gcloud sdk tooling and add a configuration for your user.  

```sh
gcloud projects list
```

```sh
container_versions --project=steady-run-207619
```

## Install settings

```sh
# list extensions
vscode-configure-profiles --profile=experiment --list  

# install extensions
vscode-configure-profiles --profile=experiment --install

# get the alias to copy to the zsh profile
# machines/${hostname}/chrisguest-MacBook-Pro.sh
vscode-configure-profiles --profile=experiment --alias

# sync settings.json using vscode diff
vscode-configure-profiles --profile=experiment --sync-settings
```

## Open workspaces

```sh
# list workspaces
vscode-workspaces --profile=default --list 

# filter list of workspaces
vscode-workspaces --profile=default --list --workspace=dotfiles

# start editing workspace
vscode-workspaces --profile=work --start --workspace=dotfile
```