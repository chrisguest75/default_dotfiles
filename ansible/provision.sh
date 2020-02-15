#!/bin/bash
#Use !/bin/bash -x  for debugging 

echo Arguments:
echo "$1"
echo "$2"
echo "$3"
echo "$4"
# echo "$5"
# echo "$6"
# echo "$7"
# echo "$8"
# echo "$9"
ansible-galaxy install -r requirements.yml -p ./roles

#export INVENTORY_IP_TYPE=internal;
export ANSIBLE_HOST_KEY_CHECKING=False; 
ansible-playbook -vvv --limit="$1" -i machines_inventory.txt provision.yml 
#ansible ${GROUP} -i ${INVENTORY} -m shell -become=sudo -a 'apt autoremove -y'
