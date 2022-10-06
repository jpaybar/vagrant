#!/bin/bash

########################################################################################
# This script creates an optional "info.json" which we can include when creating our   #
# base box. This file will contain information like "author", "homepage", "mail", etc. #
#                                                                                      #
# https://www.vagrantup.com/docs/boxes/info                                            #
#                                                                                      #
# Author: Juan M. Payán Barea (st4rt.fr0m.scr4tch@gmail.com)                           #
# https://github.com/jpaybar                                                           #
# https://www.linkedin.com/in/juanmanuelpayan/                                         #
#                                                                                      #
########################################################################################

clear

# vars
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
	echo -e "${DGREY}#########################################################################################${NC}"
	echo
	echo -e "${DGREY}This script creates an optional \"info.json\" which we can include when creating \nour base box. This file will contain information like \"author\", \"homepage\", \"mail\", etc.${NC}"
	echo
	echo -e "${DGREY}https://www.vagrantup.com/docs/boxes/info${NC}"
	echo
	echo -e "${NC}=========================================================================================${NC}"
	echo -e "${NC}Author:${NC} ${GREEN}Juan M. Payan Barea (st4rt.fr0m.scr4tch@gmail.com)${NC}\nhttps://github.com/jpaybar${NC}"
	echo -e "${NC}https://www.linkedin.com/in/juanmanuelpayan/${NC}"
	echo -e "${NC}=========================================================================================${NC}"
	echo
	echo -e "${ORANGE}Usage: $SCRIPT_NAME <box_name> <box_version>${NC}"
	echo
	echo -e "${RED}Where${NC} ${ORANGE}<box_name>${NC} ${RED}Must be the name or UUID of the machine from the VirtualBox GUI.${NC}"
	echo
	echo -e "${DGREY}#########################################################################################${NC}"
	echo
    exit 1
fi

# Getting info
echo -e "${GREEN}Enter your name:${NC}"
read AUTHOR
echo -e "${ORANGE}Enter your homepage:${NC}"
read HOMEPAGE
echo -e "${GREEN}Enter your mail:${NC}"
read MAIL
echo

cd $CURRENT_DIR/../boxes

# info
echo -e "${DGREY}================= Info =================${NC}"
echo -e AUTHOR="${DGREY}$AUTHOR${NC}"
echo -e HOMEPAGE="${DGREY}$HOMEPAGE${NC}"
echo -e MAIL="${DGREY}$MAIL${NC}"
echo -e BOX_NAME="${DGREY}$BOX_NAME${NC}"
echo -e BOX_VERSION="${DGREY}$BOX_VERSION${NC}"
echo -e "${DGREY}========================================${NC}"

# Generating file
cat << EOF > $BOX_NAME-info_$BOX_VERSION.json
{
  "author": "$AUTHOR",
  "homepage": "$HOMEPAGE",
  "mail": "$MAIL"
}
EOF

echo
echo -e "${GREEN}The \"info.json\" file was created as${NC} ${DGREY}\"boxes/$BOX_NAME-info_$BOX_VERSION.json\".${NC}"
echo
echo
