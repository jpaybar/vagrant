#!/bin/bash

###################################################################################
# This script installs the VirtualBox's "guest additions" for a better Virtual    #
# Machine performance according to the steps indicated in the documentation.      #
#                                                                                 #
# https://www.vagrantup.com/docs/providers/virtualbox/boxes                       #
#                                                                                 #
# Author: Juan M. Payán Barea (st4rt.fr0m.scr4tch@gmail.com)                      #
# https://github.com/jpaybar                                                      #
#                                                                                 #
###################################################################################

clear

# vars
GREEN='\033[0;32m'
ORANGE='\033[;33m'
DGREY='\033[1;30m'
RED='\033[0;31m'
NC='\033[0m'
GET_VERSION=`wget http://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT > /dev/null 2>&1`
VERSION=`cat LATEST-STABLE.TXT`

if [ "$EUID" -ne 0 ]
  then 
  echo
  echo -e "${RED}Please, run this script as \"root\"${NC}" 
  echo
  return 
fi

# Menu
echo
echo -e "${DGREY}####################################################################################${NC}"
echo
echo -e "${DGREY}This script installs the VirtualBox's \"guest additions\" for a better Virtual \nMachine performance according to the steps indicated in the documentation.${NC}"
echo
echo -e "${DGREY}https://www.vagrantup.com/docs/boxes/base${NC}"
echo
echo -e "${DGREY}Author: Juan M. Payan Barea (st4rt.fr0m.scr4tch@gmail.com)\nhttps://github.com/jpaybar${NC}"
echo
echo -e "${DGREY}####################################################################################${NC}"
echo

echo "Press intro to run the script"
read intro

echo -e "${GREEN}Updating repositories ....${NC}"
apt-get update > /dev/null 2>&1
echo

echo -e "${ORANGE}Installing the linux kernel headers and the basic developer tools ....${NC}"
apt-get install linux-headers-$(uname -r) build-essential dkms -y > /dev/null 2>&1
echo

echo -e "${GREEN}Downloading the latest version \"${VERSION}\" of VirtualBox's Guest Additions ....${NC}"
echo
wget http://download.virtualbox.org/virtualbox/${VERSION}/VBoxGuestAdditions_${VERSION}.iso

mkdir /media/VBoxGuestAdditions
echo -e "${ORANGE}Creating \"/media/VBoxGuestAdditions\" directory ....${NC}"
echo

mount -o loop,ro VBoxGuestAdditions_${VERSION}.iso /media/VBoxGuestAdditions
echo -e "${GREEN}Mounting \"VBoxGuestAdditions_${VERSION}.iso\" on \"/media/VBoxGuestAdditions\" directory ....${NC}"
echo

echo -e "${ORANGE}Running \"VBoxLinuxAdditions.run\" ....${NC}"
sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run > /dev/null 2>&1
echo

rm VBoxGuestAdditions_${VERSION}.iso LATEST-STABLE.TXT
echo -e "${GREEN}Removing files ....${NC}"
echo

umount /media/VBoxGuestAdditions
echo -e "${ORANGE}Umounting \"/media/VBoxGuestAdditions\" directory ....${NC}"
echo

rmdir /media/VBoxGuestAdditions
echo -e "${GREEN}Deleting mount point directory ....${NC}"
echo

echo -e "${ORANGE}Checking \"Guest Additions\" setup ....${NC}"
echo
lsmod | grep -i vbox
echo