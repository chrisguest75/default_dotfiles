# README.md

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
