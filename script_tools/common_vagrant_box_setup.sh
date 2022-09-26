#!/bin/bash

###################################################################################
# This script adapts a VirtualBox virtual machine for conversion to a Vagrant box #
# according to the steps indicated in the documentation.                          #
# https://www.vagrantup.com/docs/boxes/base                                       #
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

if [ "$EUID" -ne 0 ]
  then 
  echo
  echo -e "${RED}Please, you must be \"root\" to run this script, as its password will be changed to \"vagrant\"${NC}" 
  echo
  return 
fi

# Menu
echo
echo -e "${DGREY}####################################################################################${NC}"
echo
echo -e "${DGREY}This script adapts a VirtualBox virtual machine for conversion to a Vagrant box\naccording to the steps indicated in the documentation:${NC}"
echo
echo -e "${DGREY}https://www.vagrantup.com/docs/boxes/base\nhttps://www.vagrantup.com/docs/providers/virtualbox/boxes${NC}"
echo
echo -e "${DGREY}Author: Juan M. Payan Barea (st4rt.fr0m.scr4tch@gmail.com)\nhttps://github.com/jpaybar${NC}"
echo
echo -e "${DGREY}####################################################################################${NC}"
echo

echo "Press intro to run the script"
read intro 

# Create a info file, Vagrant-built VM creation "date"
date > /etc/vagrant_box_build_time 2>&1
echo -e "${ORANGE}Creating /etc/vagrant_box_build_time Date file....${NC}" 
echo

# Set root Password to "vagrant".
echo -e "vagrant\nvagrant" | passwd > /dev/null 2>&1
echo -e "${GREEN}Setting root Password to vagrant....${NC}"
echo

# Create the "wheel" group if it doesn't exist
/usr/bin/getent group wheel > /dev/null 2>&1 || groupadd wheel > /dev/null 2>&1
echo -e "${ORANGE}Creating the wheel group if it doesn't exist....${NC}" 
echo

# Creates the user "vagrant" if it doesn't exist and if it exists adds it 
# to the group "wheel" and assigns it the password "vagrant"
if [[ `getent passwd vagrant | grep vagrant | cut -f1 -d ':' | tr -d ' '` == vagrant ]];then
	
	usermod -a -G wheel vagrant > /dev/null 2>&1
	echo -e "${GREEN}Adding the user vagrant to the group wheel....${NC}"
	echo
	echo -e "vagrant\nvagrant" | passwd vagrant > /dev/null 2>&1
	echo -e "${GREEN}User/Password --- vagrant/vagrant${NC}"
	echo
	
else
	
	useradd vagrant -G wheel -m -s /bin/bash > /dev/null 2>&1
	echo -e "${GREEN}Creating the user "vagrant"....${NC}"
	echo
	echo -e "vagrant\nvagrant" | passwd vagrant > /dev/null 2>&1
	echo -e "${GREEN}User/Password --- vagrant/vagrant${NC}"
	echo
    
fi

# Adding the user "vagrant" to "sudo"
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant
echo -e "${ORANGE}Adding the user vagrant to sudo without password....${NC}" 
echo

# Installing insecure vagrant keys from:
# https://github.com/hashicorp/vagrant/tree/main/keys
echo -e "${GREEN}Downloading and Installing insecure vagrant key....${NC}"
echo
mkdir -pm 700 /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# Customize the message of the day
echo -e "\n\033[1;34mWelcome to this Vagrant-built VM. Customized by Juan M. Payan Barea.\nhttps://github.com/jpaybar (st4rt.fr0m.scr4tch@gmail.com)\033[0m\n" > /etc/motd
echo -e "${ORANGE}Customizing the message of the day....${NC}" 
echo 

# Create /vagrant directory
echo -e "${GREEN}Creating the \"/vagrant\" directory for sync folders....${NC}"
echo
mkdir -pm 777 /vagrant

# Assigns the vagrant user the /vagrant folder
echo -e "${ORANGE}Assigning the user \"vagrant\" as the owner of the folder \"/vagrant\"....${NC}" 
echo
chown -R vagrant:vagrant /vagrant
