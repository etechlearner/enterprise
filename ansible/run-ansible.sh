#!/bin/bash
#
# This script is provided as a convenience wrapper around the ansible
# docker container. Please make sure to review the usage and exposed
# variables below prior to running.
#

VARS_FILE="$1"
INVENTORY="$2"
PLAYBOOK="$3"
USER="$4"

function usage() {
    echo ""
    echo "Usage: ./run-ansible.sh <vars file> <inventory> <playbook> <user to run as>"
    echo ""
    echo -e "Where:"
    echo -e "\t- vars file = variable file to use, under 'vars/'"
    echo -e "\t- inventory = inventory file to use, under 'inventories/'"
    echo -e "\t- playbook = ansible playbook to run, under 'playbooks/'"
    echo -e "\t- user = user to SSH in as"
    echo -e "
As an example, to run the 'playbooks/install.yml' playbook using the
'inventories/prod.inv' inventory with the variables defined under
'vars/myvars.yml' with the 'root' user, issue the command:\n
$ ./run-ansible.sh myvars.yml prod.inv install.yml root"
    echo -e "\nNote, this script assumes the SSH configuration under '~/.ssh' will 
be used to login."
    echo ""
    exit 1
}

test -z ${VARS_FILE} && usage
test -z ${INVENTORY} && usage
test -z ${PLAYBOOK} && usage
test -z ${USER} && usage

docker run \
       --rm -it \
       -v ~/.ssh:/root/.ssh:ro \
       -v $(pwd)/inventories/$INVENTORY:/etc/ansible/hosts:ro \
       -v $(pwd)/roles:/etc/ansible/roles:ro \
       -v $(pwd)/vars:/root/vars:ro \
       -v $(pwd)/playbooks:/root/playbooks \
       quay.io/stoplight/ansible:latest -e @vars/common.yml -e @vars/${VARS_FILE} -u ${USER} playbooks/${PLAYBOOK}
