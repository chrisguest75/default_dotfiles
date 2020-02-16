# README.md

## TODO 
1. Add a local install configuration
1. Virtualbox
1. Fix snaps
1. Gnome desktop features. 
1. Configure visualstudio code.
1. Linux hardening.  

## Prepare
Install role dependencies globally
```sh
ansible-galaxy role list
ansible-galaxy install nickjj.docker
ansible-galaxy install gantsign.oh-my-zsh
```

Install role dependencies locally
```sh
ansible-galaxy install -r requirements.yml -p ./roles 
```


## Install with Ansible
Ensure [machines_inventory.txt](./machines_inventory.txt) file has the correct details.  Select the machine name from the inventory and pass to --limit.  

```sh
ansible-playbook  --user chrisguest -K --limit="chrisguest-W520" -i machines_inventory.txt provision.yml
```

```sh
ansible-playbook  --user chrisguest --extra-vars "ansible_become_pass=<password>" --limit="chrisguest-W520" -i machines_inventory.txt provision.yml
```

## Troubleshooting

1. Snaps are failing to install.
    1. It might require purging snapd '''apt purge snapd'''


```sh
sudo snap install code 
error: too early for operation, device not yet seeded or device model not acknowledged
```