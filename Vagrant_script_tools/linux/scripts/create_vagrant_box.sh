#!/bin/bash

###########################################################################################
# This script packs a Vagrantfile with the initial configuration and a .json information  #
# file ("author", "homepage", "mail", etc...) that we include when creating our base box. #
# As a result we will have a file BOX_NAME-version_BOX_VERSION.box.                       #
#                                                                                         #
# https://www.vagrantup.com/docs/cli/package                                              #
#                                                                                         #
# Author: Juan M. Payán Barea (st4rt.fr0m.scr4tch@gmail.com)                              #
# https://github.com/jpaybar                                                              #
# https://www.linkedin.com/in/juanmanuelpayan/                                            #
#                                                                                         #
###########################################################################################

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
	echo -e "${DGREY}#######################################################################################${NC}"
	echo
	echo -e "${DGREY}This script packs a Vagrantfile with the initial configuration and a .json information \nfile (\"author\", \"homepage\", \"mail\", etc...) that we include when creating our base box. \nAs a result we will have a file BOX_NAME-version_BOX_VERSION.box.${NC}"
	echo
	echo -e "${DGREY}https://www.vagrantup.com/docs/cli/package${NC}"
	echo
	echo -e "${NC}=======================================================================================${NC}"
	echo -e "${NC}Author:${NC} ${GREEN}Juan M. Payan Barea (st4rt.fr0m.scr4tch@gmail.com)${NC}\nhttps://github.com/jpaybar${NC}"
	echo -e "${NC}https://www.linkedin.com/in/juanmanuelpayan/${NC}"
	echo -e "${NC}=======================================================================================${NC}"
	echo
	echo -e "${ORANGE}Usage: $SCRIPT_NAME <box_name> <box_version>${NC}"
	echo
	echo -e "${RED}Where${NC} ${ORANGE}<box_name>${NC} ${RED}Must be the name or UUID of the machine from the VirtualBox GUI.${NC}"
	echo
	echo -e "${DGREY}#######################################################################################${NC}"
	echo
    exit 1
fi

cd $CURRENT_DIR/../boxes

vagrant package                               \
    --base $BOX_NAME                              \
    --output $BOX_NAME-version_$BOX_VERSION.box              \
    --vagrantfile $BOX_NAME-version_$BOX_VERSION.Vagrantfile \
    --include info.json       \
    $BOX_NAME
	
# It should be "--info info.json" flag instead of "--include info.json" but some vagrant version seem not to have this flag
# like my vagrant version 2.2.6 on Ubuntu 20.04.
# So, this option include de info.json but information is not showed when you run the comand:
# vagrant box list -i
# Because info.json is placed into the "include" folder instead of the "root" folder.
	
echo
echo -e "${GREEN}The \"Vagrant Box\" file was created as${NC} ${DGREY}\"boxes/$BOX_NAME-version_$BOX_VERSION.box\".${NC}"
echo
echo
