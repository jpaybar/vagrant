<#
.DESCRIPTION
This script creates an optional "info.json".

.PARAMETER BOX_NAME
BOX_NAME, Where <BOX_NAME> must be the name or UUID of the machine from the VirtualBox GUI.

.PARAMETER BOX_VERSION
BOX_VERSION, Where <BOX_VERSION> is the version of our Vagrant Box.

.EXAMPLE
PS> .\create_info_json.ps1 -BOX_NAME ubuntu2004 -BOX_VERSION 1.0

.EXAMPLE
PS> .\create_info_json.ps1 ubuntu2004 1.0

.SYNOPSIS
This script creates an optional "info.json" which we can include when creating our   
base box. This file will contain information like "author", "homepage", "mail", etc.

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
	Write-Host  "This script creates an optional `"info.json`" which we can include when creating `nour base box. This file will contain information like `"author`", `"homepage`", `"mail`", etc." -ForegroundColor DarkGray
	Write-Host
	Write-Host "https://www.vagrantup.com/docs/boxes/info" -ForegroundColor DarkGray
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

# Getting info
Write-Host "Enter your name:" -ForegroundColor green
$AUTHOR=Read-Host
Write-Host "Enter your homepage:" -ForegroundColor DarkYellow
$HOMEPAGE=Read-Host
Write-Host "Enter your mail:" -ForegroundColor green
$MAIL=Read-Host
Write-Host

cd $CURRENT_DIR\..\boxes

# info
Write-Host "================= Info =================" -ForegroundColor DarkGray
Write-Host "AUTHOR=" -nonewline
Write-Host "$AUTHOR" -ForegroundColor DarkGray
Write-Host "HOMEPAGE=" -nonewline
Write-Host "$HOMEPAGE" -ForegroundColor DarkGray
Write-Host "MAIL=" -nonewline
Write-Host "$MAIL" -ForegroundColor DarkGray
Write-Host "BOX_NAME=" -nonewline
Write-Host "$BOX_NAME" -ForegroundColor DarkGray
Write-Host "BOX_VERSION=" -nonewline
Write-Host "$BOX_VERSION" -ForegroundColor DarkGray
Write-Host "================= Info =================" -ForegroundColor DarkGray

# Generating file
echo @"
{
  "author": "$AUTHOR",
  "homepage": "$HOMEPAGE",
  "mail": "$MAIL"
}
"@ | out-file $BOX_NAME-info_$BOX_VERSION.json -Encoding ascii

cd ..\scripts\

Write-Host
Write-Host "The `"info.json`" file was created as " -ForegroundColor green -nonewline 
Write-Host "`"boxes\$BOX_NAME-info_$BOX_VERSION.json`"." -ForegroundColor DarkGray
Write-Host
Write-Host