#!/bin/bash

#########################################################################################
# This script adds a VirtualBox VM from the command line interface                      #
# with the necessary configuration to install a basic OS (Vagrant Box),                 #
# according to the official documentation:                                              #
#                                                                                       #
# https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/vboxmanage-intro.html   #
# https://www.vagrantup.com/docs/boxes/base                                             #
#                                                                                       #
# Author: Juan M. Payán Barea (st4rt.fr0m.scr4tch@gmail.com)                            #
# https://github.com/jpaybar                                                            #
# https://www.linkedin.com/in/juanmanuelpayan/                                          #
#                                                                                       #
#########################################################################################

# Vars
declare -r SCRIPT_NAME=${BASH_SOURCE[0]} > /dev/null 2>&1
GREEN='\033[0;32m'
ORANGE='\033[;33m'
DGREY='\033[1;30m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'
VM_NAME=$1
VM_FOLDER="$HOME/VirtualBox VMs" # ls "$VM_FOLDER" (You need to put the variable in quotes)
ISO_URL="http://archive.ubuntu.com/ubuntu/dists/focal-updates/main/installer-amd64/current/legacy-images/netboot/mini.iso"
ISO_NAME=`echo ${ISO_URL##*/}`
OSTYPE="Ubuntu_64"
HDD_SIZE="81920"
RAM="512"
VRAM="16"

clear

# How to run the script
if [ $# -ne 1 ]; then
	echo
	echo -e "${DGREY}#############################################################################################${NC}"
	echo
	echo -e "${DGREY}This script adds a VirtualBox VM from the command line interface with just the necessary \nconfiguration to install a basic OS (Vagrant Box), according to the official documentation:${NC}"
	echo
	echo -e "${DGREY}https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/vboxmanage-intro.html${NC}"
	echo -e "${DGREY}https://www.vagrantup.com/docs/boxes/base${NC}"
	echo
	echo -e "${NC}=============================================================================================${NC}"
	echo -e "${NC}Author:${NC} ${GREEN}Juan M. Payan Barea (st4rt.fr0m.scr4tch@gmail.com)${NC}\nhttps://github.com/jpaybar${NC}"
	echo -e "${NC}https://www.linkedin.com/in/juanmanuelpayan/${NC}"
	echo -e "${NC}=============================================================================================${NC}"
	echo
	echo -e "${ORANGE}Usage: $SCRIPT_NAME <VM_NAME>${NC}"
	echo
	echo -e "${RED}Where${NC} ${ORANGE}<VM_NAME>${NC} ${RED}will be the name of the machine in the VirtualBox GUI.${NC}"
	echo
	echo -e "${DGREY}#############################################################################################${NC}"
	echo
    exit 1
fi

# Check if the VM already exists in VirtualBox
if [ `vboxmanage list vms | grep -w $VM_NAME | head -n1 | cut -d " " -f1` ]; then
	echo
	echo -e "${RED}The VM called ${NC} ${ORANGE}$VM_NAME ${NC} ${RED}already exists in VirtualBox!!.....${NC}"
	echo
	echo -e "${BLUE}Please, choose another name (Case Sensitive)....${NC}"
	echo
	exit 1
fi

if [ ! -f $PWD/$ISO_NAME ]; then
	wget $ISO_URL -O $ISO_NAME
fi

### Create the virtual machine ###
#================================#
# VBoxManage list ostypes | grep -i debian (Filter OS type info)

# Create VM
VBoxManage createvm --name $VM_NAME --ostype $OSTYPE --register

### Create a virtual hard disk and storage devices for the VM ###
#===============================================================#
# Create HDD 80GB
VBoxManage createmedium disk --filename "$VM_FOLDER"/$VM_NAME/$VM_NAME.vdi --size $HDD_SIZE
# Create SATA controller
VBoxManage storagectl $VM_NAME --name "SATA Controller" --add sata --controller IntelAHCI
# Attach HDD to SATA controller
VBoxManage storageattach $VM_NAME --storagectl "SATA Controller" --port 0 --device 0 \
--type hdd --medium "$VM_FOLDER"/$VM_NAME/$VM_NAME.vdi
# Create IDE controller
VBoxManage storagectl $VM_NAME --name "IDE Controller" --add ide
# Attach DVD to IDE controller
VBoxManage storageattach $VM_NAME --storagectl "IDE Controller" --port 0 --device 0 \
--type dvddrive --medium $PWD/$ISO_NAME

### Configure some settings for the VM ###
#========================================#
# Enable I/O APIC for the motherboard
VBoxManage modifyvm $VM_NAME --ioapic on
# Configure the boot device order
VBoxManage modifyvm $VM_NAME --boot1 dvd --boot2 disk --boot3 none --boot4 none
# Allocate 1024 MB of RAM and 16 MB of video RAM
VBoxManage modifyvm $VM_NAME --memory $RAM --vram $VRAM
# Adding NAT Rule SSH Port Forwarding
VBoxManage modifyvm $VM_NAME --natpf1 "SSH,tcp,127.0.0.1,2222,,22"
# Disable audio
VBoxManage modifyvm $VM_NAME --audio none

VBoxManage startvm $VM_NAME

