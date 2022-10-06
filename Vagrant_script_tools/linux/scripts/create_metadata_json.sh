#!/bin/bash

#########################################################################################
# This script creates an alternative "metadata.json" which we can include when creating #
# our base box. This file will contain the minimum configuration (providers) , as well  #
# as the name, version, description, etc... of our Vagrant Box.                         #
#                                                                                       #
# https://www.vagrantup.com/docs/boxes/format                                           #
#                                                                                       #
# Author: Juan M. Payán Barea (st4rt.fr0m.scr4tch@gmail.com)                            #
# https://github.com/jpaybar                                                            #
# https://www.linkedin.com/in/juanmanuelpayan/                                          #
#                                                                                       #
#########################################################################################

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
	echo -e "${DGREY}#############################################################################################${NC}"
	echo
	echo -e "${DGREY}This script creates an alternative \"metadata.json\" which we can include when creating \nour base box. This file will contain the minimum configuration (providers), as well \nas the name, version, description, etc... of our Vagrant Box.${NC}"
	echo
	echo -e "${DGREY}https://www.vagrantup.com/docs/boxes/format${NC}"
	echo
	echo -e "${NC}=============================================================================================${NC}"
	echo -e "${NC}Author:${NC} ${GREEN}Juan M. Payan Barea (st4rt.fr0m.scr4tch@gmail.com)${NC}\nhttps://github.com/jpaybar${NC}"
	echo -e "${NC}https://www.linkedin.com/in/juanmanuelpayan/${NC}"
	echo -e "${NC}=============================================================================================${NC}"
	echo
	echo -e "${ORANGE}Usage: $SCRIPT_NAME <box_name> <box_version>${NC}"
	echo
	echo -e "${RED}Where${NC} ${ORANGE}<box_name>${NC} ${RED}Must be the name or UUID of the machine from the VirtualBox GUI.${NC}"
	echo -e "${RED}A multi-word description must be enclosed in quotes (For example ${ORANGE}\"Ubuntu 20.04 with Apache\"${NC}${RED}).${NC}"
	echo
	echo -e "${DGREY}#############################################################################################${NC}"
	echo
    exit 1
fi

cd $CURRENT_DIR/../boxes

if [ -f $CURRENT_DIR/../boxes/$BOX_NAME-version_$BOX_VERSION.box ]; then
    SHA256SUM=$(/usr/bin/sha256sum $BOX_NAME-version_$BOX_VERSION.box | cut -d' ' -f1)
else
	echo
    echo -e "${RED}The \"$BOX_NAME-version_$BOX_VERSION.box\" does not exist, you must create this \"box\" before execute this script.${NC}"
	echo
    exit 1
fi

echo BOX_NAME=$BOX_NAME
echo BOX_VERSION=$BOX_VERSION
echo SHA256SUM=$SHA256SUM

cat << EOF > $BOX_NAME-version_$BOX_VERSION.json
{
    "name": "$BOX_NAME",
    "description": "This Vagrant Box was created by jpaybar",
    "versions": [{
        "version": "$BOX_VERSION",
        "providers": [{
                "name": "virtualbox",
                "url": "file:///$PWD/$BOX_NAME-version_$BOX_VERSION.box",
                "checksum_type": "sha256",
                "checksum": "$SHA256SUM"
        }]
    }]
}
EOF

echo
echo -e "${GREEN}The \"metadata.json\" file was created as${NC} ${DGREY}\"boxes/$BOX_NAME-version_$BOX_VERSION.json\".${NC}"
echo
echo
