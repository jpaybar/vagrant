<#
.DESCRIPTION
This script packs a Vagrantfile with the initial configuration, creating our base box.

.PARAMETER BOX_NAME
BOX_NAME, Where <BOX_NAME> must be the name or UUID of the machine from the VirtualBox GUI.

.PARAMETER BOX_VERSION
BOX_VERSION, Where <BOX_VERSION> is the version of our Vagrant Box.

.EXAMPLE
PS> .\create_vagrant_box.ps1 -BOX_NAME ubuntu2004 -BOX_VERSION 1.0

.EXAMPLE
PS> .\create_vagrant_box.ps1 ubuntu2004 1.0

.SYNOPSIS
This script packs a Vagrantfile with the initial configuration and a .json information  
file ("author", "homepage", "mail", etc...) that we include when creating our base box. 
As a result we will have a file BOX_NAME-version_BOX_VERSION.box.

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
	Write-Host  "This script packs a Vagrantfile with the initial configuration and a .json information  
file (`"author`", `"homepage`", `"mail`", etc...) that we include when creating our base box. 
As a result we will have a file BOX_NAME-version_BOX_VERSION.box." -ForegroundColor DarkGray
	Write-Host
	Write-Host "https://www.vagrantup.com/docs/cli/package" -ForegroundColor DarkGray
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

vagrant package                               `
    --base $BOX_NAME                              `
    --output $BOX_NAME-version_$BOX_VERSION.box              `
    --vagrantfile $BOX_NAME-version_$BOX_VERSION.Vagrantfile `
    --info info.json       `
    $BOX_NAME
	
cd ..\scripts\

Write-Host
Write-Host "The `"Vagrant Box`" file was created as " -ForegroundColor green -nonewline 
Write-Host "`"boxes\$BOX_NAME-version_$BOX_VERSION.box`"." -ForegroundColor DarkGray
Write-Host
Write-Host