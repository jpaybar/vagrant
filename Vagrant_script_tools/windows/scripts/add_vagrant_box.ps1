<#
.DESCRIPTION
This script adds our Vagrant box created using the "metadata.json" file.

.PARAMETER BOX_NAME
BOX_NAME, Where <BOX_NAME> must be the name or UUID of the machine from the VirtualBox GUI.

.PARAMETER BOX_VERSION
BOX_VERSION, Where <BOX_VERSION> is the version of our Vagrant Box.

.EXAMPLE
PS> .\add_vagrant_box.ps1 -BOX_NAME ubuntu2004 -BOX_VERSION 1.0

.EXAMPLE
PS> .\add_vagrant_box.ps1 ubuntu2004 1.0

.SYNOPSIS
This script adds our Vagrant box created using the "metadata.json" file corresponding 
to the specified name and version. This file will contain the minimum configuration   
(providers) , as well as the name, version, description, etc... of our Vagrant Box.

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
	Write-Host  "This script adds our Vagrant box created using the `"metadata.json`" file corresponding 
to the specified name and version. This file will contain the minimum configuration   
(providers) , as well as the name, version, description, etc... of our Vagrant Box." -ForegroundColor DarkGray
	Write-Host
	Write-Host "https://www.vagrantup.com/docs/cli" -ForegroundColor DarkGray
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

vagrant box add -c $BOX_NAME-version_$BOX_VERSION.json
Write-Host
Write-Host

cd ..\scripts\