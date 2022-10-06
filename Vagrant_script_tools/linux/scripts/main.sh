#!/bin/bash

############################################################################################
# This "main.sh" script runs 5 other bash scripts in order to generate the necessary files #
# to create and package a "Vagrant box" from a virtual machine that we have created with   #
# "VirtualBox". These scripts can be executed individually, the function of "main.sh"      #
# is to simplify the process and create all the necessary files at once.                   #
#                                                                                          #
# Scripts:                                                                                 #
# 1.- create_Vagrantfile.sh                                                                #
# 2.- create_info_json.sh                                                                  #
# 3.- create_vagrant_box.sh                                                                #
# 4.- create_metadata_json.sh                                                              #
# 5.- add_vagrant_box.sh                                                                   #
#                                                                                          #
# https://www.vagrantup.com/docs/boxes/format                                              #
#                                                                                          #
# Author: Juan M. Payán Barea (st4rt.fr0m.scr4tch@gmail.com)                               #
# https://github.com/jpaybar                                                               #
# https://www.linkedin.com/in/juanmanuelpayan/                                             #
#                                                                                          #
############################################################################################

clear

# Vars
GREEN='\033[0;32m'
ORANGE='\033[;33m'
DGREY='\033[1;30m'
RED='\033[0;31m'
NC='\033[0m'
CURRENT_DIR="."
declare -r SCRIPT_NAME=${BASH_SOURCE[0]} > /dev/null 2>&1

# menu
echo
echo -e "${DGREY}#########################################################################################${NC}"
echo
echo -e "${DGREY}This \"main.sh\" script runs 5 other bash scripts in order to generate the necessary files \nto create and package a \"Vagrant box\" from a virtual machine that we have created with \n\"VirtualBox\". These scripts can be executed individually, the function of \"main.sh\"\nis to simplify the process and create all the necessary files at once.${NC}"
echo
echo -e "${DGREY}Scripts:${NC}"
echo -e "${DGREY}========${NC}"
echo -e "${ORANGE}1.- create_Vagrantfile.sh${NC}"
echo -e "${ORANGE}2.- create_info_json.sh${NC}"
echo -e "${ORANGE}3.- create_vagrant_box.sh${NC}"
echo -e "${ORANGE}4.- create_metadata_json.sh${NC}"
echo -e "${ORANGE}5.- add_vagrant_box.sh${NC}"
echo
echo -e "${DGREY}https://www.vagrantup.com/docs/boxes/info${NC}"
echo
echo -e "${NC}=========================================================================================${NC}"
echo -e "${NC}Author:${NC} ${GREEN}Juan M. Payan Barea (st4rt.fr0m.scr4tch@gmail.com)${NC}\nhttps://github.com/jpaybar${NC}"
echo -e "${NC}https://www.linkedin.com/in/juanmanuelpayan/${NC}"
echo -e "${NC}=========================================================================================${NC}"
echo
echo -e "${DGREY}#########################################################################################${NC}"
echo
echo "Press intro to start...."
read intro
clear

# prompt vars
echo -e "${DGREY}Enter the name for the Vagrant Box (Where ${ORANGE}<box_name>${NC} ${DGREY}Must be the name or UUID of the machine from \nthe VirtualBox GUI):${NC}"
read BOX_NAME

echo -e "${DGREY}Enter the version for the Vagrant Box (For example ${ORANGE}1.0${NC} ${DGREY}):${NC}"
read BOX_VERSION

echo

# Creating the Vagrantfile
echo -e "${DGREY}Press enter to run${NC} ${ORANGE}\"create_Vagrantfile.sh\"${NC}${DGREY}....${NC}"
read enter
/bin/bash ./create_Vagrantfile.sh $BOX_NAME $BOX_VERSION

# Creating the info.json file
echo -e "${DGREY}Press enter to run${NC} ${ORANGE}\"create_info_json.sh\"${NC}${DGREY}....${NC}"
read enter
/bin/bash ./create_info_json.sh $BOX_NAME $BOX_VERSION 

# Creating the Vagrant Box file
echo -e "${DGREY}Press enter to run${NC} ${ORANGE}\"create_vagrant_box.sh\"${NC}${DGREY}....${NC}"
read enter
/bin/bash ./create_vagrant_box.sh $BOX_NAME $BOX_VERSION

# Creating the metadata.json file
echo -e "${DGREY}Press enter to run${NC} ${ORANGE}\"create_metadata_json.sh\"${NC}${DGREY}....${NC}"
read enter
/bin/bash ./create_metadata_json.sh $BOX_NAME $BOX_VERSION 

# Adding the Vagrant Box file
echo -e "${DGREY}Press enter to run${NC} ${ORANGE}\"add_vagrant_box.sh\"${NC}${DGREY}....${NC}"
read enter
/bin/bash ./add_vagrant_box.sh $BOX_NAME $BOX_VERSION

# Showing created files
ls -l $CURRENT_DIR/../boxes
echo
echo
