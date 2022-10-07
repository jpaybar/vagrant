<#
.DESCRIPTION
This script adds a VirtualBox VM from the command line interface.

.PARAMETER VM_NAME
VM_NAME, Where <VM_NAME> will be the name of the machine in the VirtualBox GUI.

.EXAMPLE
PS> .\Add_VirtualBoxVM_CLI.ps1 -VM_NAME ubuntu2004 

.EXAMPLE
PS> .\Add_VirtualBoxVM_CLI.ps1 ubuntu2004 

.SYNOPSIS
This script adds a VirtualBox VM from the command line interface
with the necessary configuration to install a basic OS (Vagrant Box), 
according to the official documentation:

https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/vboxmanage-intro.html
https://www.vagrantup.com/docs/boxes/base

.NOTES
Juan M. Payan Barea (st4rt.fr0m.scr4tch@gmail.com)

.LINK
https://github.com/jpaybar
https://www.linkedin.com/in/juanmanuelpayan/
#>

param(
[string] $VM_NAME
)

# Vars
$0=split-path $PSCommandPath -Leaf
$VM_FOLDER="$HOME\VirtualBox VMs"
$ISO_URL="http://archive.ubuntu.com/ubuntu/dists/focal-updates/main/installer-amd64/current/legacy-images/netboot/mini.iso"
$ISO_NAME=Split-Path $ISO_URL -Leaf
$OSTYPE="Ubuntu_64"
$HDD_SIZE="81920"
$RAM="512"
$VRAM="16"

cls

# How to run the script
if (!($PSBoundParameters.Count -eq 1))
{    
    Write-Host
	Write-Host "#########################################################################################" -ForegroundColor DarkGray
	Write-Host
	Write-Host  "This script adds a VirtualBox VM from the command line interface
with the necessary configuration to install a basic OS (Vagrant Box), 
according to the official documentation:" -ForegroundColor DarkGray
	Write-Host
	Write-Host "https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/vboxmanage-intro.html" -ForegroundColor DarkGray
	Write-Host "https://www.vagrantup.com/docs/boxes/base" -ForegroundColor DarkGray
	Write-Host
	Write-Host "========================================================================================="
	Write-Host "Author: " -nonewline
	Write-Host "Juan M. Payan Barea (st4rt.fr0m.scr4tch@gmail.com)" -ForegroundColor green
	Write-Host "https://github.com/jpaybar"
	Write-Host "https://www.linkedin.com/in/juanmanuelpayan/"
	Write-Host "========================================================================================="
	Write-Host
	Write-Host "Usage: .\$0 <VM_NAME>" -ForegroundColor DarkYellow
	Write-Host
	Write-Host "Where " -ForegroundColor red -nonewline
	Write-Host "<VM_NAME> " -ForegroundColor DarkYellow -nonewline 
	Write-Host "will be the name of the machine in the VirtualBox GUI." -ForegroundColor red
	Write-Host
	Write-Host "#########################################################################################" -ForegroundColor DarkGray
	Write-Host
	
	exit 1
}

# Check if the VM already exists in VirtualBox
if(VBoxManage.exe list vms | Select-String -pattern $VM_NAME\b){
	Write-Host
	Write-Host "The VM called " -ForegroundColor red -nonewline
	Write-Host "$VM_NAME " -ForegroundColor DarkYellow -nonewline 
	Write-Host "already exists in VirtualBox!!...." -ForegroundColor red 
	Write-Host
	Write-Host "Please, choose another name (NOT case censitive)...." -ForegroundColor blue 
	Write-Host
	exit 1
}

# If the installation iso file does not exist, download it
if(!(Test-Path -Path $PWD\$ISO_NAME)){
	Write-Host "Downloading iso file...." -ForegroundColor Green
	Invoke-WebRequest -Uri $ISO_URL -OutFile $ISO_NAME
}

### Create the virtual machine ###
#================================#
# VBoxManage list ostypes | Select-String ubuntu (Filter OS type info)

# Create VM
VBoxManage createvm --name $VM_NAME --ostype $OSTYPE --register

### Create a virtual hard disk and storage devices for the VM ###
#===============================================================#
# Create HDD 80GB
VBoxManage createhd --filename $VM_FOLDER\$VM_NAME\$VM_NAME.vdi --size $HDD_SIZE
# Create SATA controller
VBoxManage storagectl $VM_NAME --name "SATA Controller" --add sata --controller IntelAHCI
# Attach HDD to SATA controller
VBoxManage storageattach $VM_NAME --storagectl "SATA Controller" --port 0 --device 0 `
--type hdd --medium $VM_FOLDER\$VM_NAME\$VM_NAME.vdi
# Create IDE controller
VBoxManage storagectl $VM_NAME --name "IDE Controller" --add ide
# Attach DVD to IDE controller
VBoxManage storageattach $VM_NAME --storagectl "IDE Controller" --port 0 --device 0 `
--type dvddrive --medium $PWD\$ISO_NAME

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

