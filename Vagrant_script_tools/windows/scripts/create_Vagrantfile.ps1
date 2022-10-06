<#
.DESCRIPTION
This script creates an alternative "Vagrantfile".

.PARAMETER BOX_NAME
BOX_NAME, Where <BOX_NAME> must be the name or UUID of the machine from the VirtualBox GUI.

.PARAMETER BOX_VERSION
BOX_VERSION, Where <BOX_VERSION> is the version of our Vagrant Box.

.EXAMPLE
PS> .\create_Vagrantfile.ps1 -BOX_NAME ubuntu2004 -BOX_VERSION 1.0

.EXAMPLE
PS> .\create_Vagrantfile.ps1 ubuntu2004 1.0

.SYNOPSIS
This script creates an alternative "Vagrantfile" which we can include when creating 
our base box. This file will contain the minimum configuration, as well as the      
name and version of our Vagrant Box.

.NOTES
Juan M. Payan Barea (st4rt.fr0m.scr4tch@gmail.com)

.LINK
https://github.com/jpaybar
https://www.linkedin.com/in/juanmanuelpayan/
https://www.vagrantup.com/docs/
#>

param(
[string] $BOX_NAME, 
[string] $BOX_VERSION
)

# Vars
$0=split-path $PSCommandPath -Leaf
$CURRENT_DIR="."

cls 

# How to run the script
if (!($PSBoundParameters.Count -eq 2))
{    
    Write-Host
	Write-Host "#########################################################################################" -ForegroundColor DarkGray
	Write-Host
	Write-Host  "This script creates an alternative `"Vagrantfile`" which we can include when creating 
our base box. This file will contain the minimum configuration, as well as the      
name and version of our Vagrant Box." -ForegroundColor DarkGray
	Write-Host
	Write-Host "https://www.vagrantup.com/docs/vagrantfile" -ForegroundColor DarkGray
	Write-Host
	Write-Host "========================================================================================="
	Write-Host "Author: " -nonewline
	Write-Host "Juan M. Payan Barea (st4rt.fr0m.scr4tch@gmail.com)" -ForegroundColor green
	Write-Host "https://github.com/jpaybar"
	Write-Host "https://www.linkedin.com/in/juanmanuelpayan/"
	Write-Host "========================================================================================="
	Write-Host
	Write-Host "Usage: .\$0 <box_name> <box_version>" -ForegroundColor DarkYellow
	Write-Host
	Write-Host "Where " -ForegroundColor red -nonewline
	Write-Host "<BOX_NAME> " -ForegroundColor DarkYellow -nonewline 
	Write-Host "Must be the name or UUID of the machine from the VirtualBox GUI." -ForegroundColor red
	Write-Host
	Write-Host "#########################################################################################" -ForegroundColor DarkGray
	Write-Host
	
	exit 1
}

cd $CURRENT_DIR\..\boxes

# Info name/version
Write-Host
Write-Host "BOX_NAME=" -nonewline
Write-Host "$BOX_NAME" -ForegroundColor DarkYellow
Write-Host "BOX_VERSION=" -nonewline
Write-Host "$BOX_VERSION" -ForegroundColor DarkYellow
Write-Host

# Generating file
echo @"
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
"@ | out-file $BOX_NAME-version_$BOX_VERSION.Vagrantfile -Encoding ascii

cd ..\scripts\

Write-Host
Write-Host "The `"Vagrantfile`" file was created as " -ForegroundColor green -nonewline 
Write-Host "`"boxes\$BOX_NAME-version_$BOX_VERSION.Vagrantfile`"." -ForegroundColor DarkGray
Write-Host
Write-Host