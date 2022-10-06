#!/bin/bash

#######################################################################################
# This script creates an alternative "Vagrantfile" which we can include when creating #
# our base box. This file will contain the minimum configuration, as well as the      #
# name and version of our Vagrant Box.                                                #
#                                                                                     #
# https://www.vagrantup.com/docs/vagrantfile                                          #
#                                                                                     #
# Author: Juan M. Payán Barea (st4rt.fr0m.scr4tch@gmail.com)                          #
# https://github.com/jpaybar                                                          #
# https://www.linkedin.com/in/juanmanuelpayan/                                        #
#                                                                                     #
#######################################################################################

clear

# Vars
GREEN='\033[0;32m'
ORANGE='\033[;33m'
DGREY='\033[1;30m'
RED='\033[0;31m'
NC='\033[0m'
CURRENT_DIR="."
BOX_NAME=$1
BOX_VERSION=$2
declare -r SCRIPT_NAME=${BASH_SOURCE[0]} > /dev/null 2>&1

# How to run the script
if [ $# -ne 2 ]; then
	echo
	echo -e "${DGREY}####################################################################################${NC}"
	echo
	echo -e "${DGREY}This script creates an alternative Vagrantfile which we can include when creating \nour base box. This file will contain the minimum configuration, as well as name \nand version of our Vagrant Box.${NC}"
	echo
	echo -e "${DGREY}https://www.vagrantup.com/docs/vagrantfile${NC}"
	echo
	echo -e "${NC}====================================================================================${NC}"
	echo -e "${NC}Author:${NC} ${GREEN}Juan M. Payan Barea (st4rt.fr0m.scr4tch@gmail.com)${NC}\nhttps://github.com/jpaybar${NC}"
	echo -e "${NC}https://www.linkedin.com/in/juanmanuelpayan/${NC}"
	echo -e "${NC}====================================================================================${NC}"
	echo
	echo -e "${ORANGE}Usage: $SCRIPT_NAME <box_name> <box_version>${NC}"
	echo
	echo -e "${RED}Where${NC} ${ORANGE}<box_name>${NC} ${RED}Must be the name or UUID of the machine from the VirtualBox GUI.${NC}"
	echo
	echo -e "${DGREY}####################################################################################${NC}"
	echo
    exit 1
fi

cd $CURRENT_DIR/../boxes

# Info name/version
echo
echo -e BOX_NAME="${ORANGE}$BOX_NAME${NC}"
echo -e BOX_VERSION="${ORANGE}$BOX_VERSION${NC}"
echo

# Create the Vagrantfile
cat << EOF > $BOX_NAME-version_$BOX_VERSION.Vagrantfile
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  
  ### General setup ###
  config.vm.box = "${BOX_NAME}"
  config.vm.box_version = "${BOX_VERSION}"
  config.vm.synced_folder ".", "/vagrant"
  config.vm.box_check_update = false

  ### SSH setup ###
  config.ssh.username = "vagrant"
  #config.ssh.password = "vagrant"
  #=== In case you create your own keypair instead of Vagrant's insecure keypairs ===#
  #config.ssh.private_key_path = File.join(File.expand_path(File.dirname(__FILE__)), "vagrant.id_rsa")

end
EOF

echo
echo -e "${GREEN}The Vagrantfile was created as${NC} ${DGREY}\"boxes/$BOX_NAME-version_$BOX_VERSION.Vagrantfile\".${NC}"
echo
echo

