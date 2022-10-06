#!/bin/bash

#########################################################################################
# This script adds our Vagrant box created using the "metadata.json" file corresponding #
# to the specified name and version. This file will contain the minimum configuration   #
# (providers) , as well as the name, version, description, etc... of our Vagrant Box.   #
#                                                                                       #
# https://www.vagrantup.com/docs/cli                                                    #
#                                                                                       #
# Author: Juan M. Payán Barea (st4rt.fr0m.scr4tch@gmail.com)                            #
# https://github.com/jpaybar                                                            #
# https://www.linkedin.com/in/juanmanuelpayan/                                          #
#                                                                                       #
#########################################################################################

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
	echo -e "${DGREY}######################################################################################${NC}"
	echo
	echo -e "${DGREY}This script adds our Vagrant box created using the \"metadata.json\" file corresponding \nto the specified name and version. This file will contain the minimum configuration \n(providers) , as well as the name, version, description, etc... of our Vagrant Box.${NC}"
	echo
	echo -e "${DGREY}https://www.vagrantup.com/docs/cli${NC}"
	echo
	echo -e "${NC}======================================================================================${NC}"
	echo -e "${NC}Author:${NC} ${GREEN}Juan M. Payan Barea (st4rt.fr0m.scr4tch@gmail.com)${NC}\nhttps://github.com/jpaybar${NC}"
	echo -e "${NC}https://www.linkedin.com/in/juanmanuelpayan/${NC}"
	echo -e "${NC}======================================================================================${NC}"
	echo
	echo -e "${ORANGE}Usage: $SCRIPT_NAME <box_name> <box_version>${NC}"
	echo
	echo -e "${RED}Where${NC} ${ORANGE}<box_name>${NC} ${RED}Must be the name or UUID of the machine from the VirtualBox GUI.${NC}"
	echo
	echo -e "${DGREY}######################################################################################${NC}"
	echo
    exit 1
fi

cd $CURRENT_DIR/../boxes
vagrant box add -c $BOX_NAME-version_$BOX_VERSION.json
echo
echo

