<#
.DESCRIPTION
This "main.ps1" script runs 5 other powershell scripts in order to generate the necessary files 
to create and package a "Vagrant box".

.PARAMETER BOX_NAME
BOX_NAME, Where <BOX_NAME> must be the name or UUID of the machine from the VirtualBox GUI.

.PARAMETER BOX_VERSION
BOX_VERSION, Where <BOX_VERSION> is the version of our Vagrant Box.

.EXAMPLE
PS> .\main.ps1 -BOX_NAME ubuntu2004 -BOX_VERSION 1.0

.EXAMPLE
PS> .\main.ps1 ubuntu2004 1.0

.SYNOPSIS
This "main.ps1" script runs 5 other powershell scripts in order to generate the necessary files 
to create and package a "Vagrant box" from a virtual machine that we have created with   
"VirtualBox". These scripts can be executed individually, the function of "main.ps1"      
is to simplify the process and create all the necessary files at once.                   
                                                                                          
Scripts:                                                                                 
1.- create_Vagrantfile.ps1                                                                
2.- create_info_json.ps1                                                                  
3.- create_vagrant_box.ps1                                                                
4.- create_metadata_json.ps1                                                              
5.- add_vagrant_box.ps1

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

# menu
Write-Host
Write-Host "#########################################################################################" -ForegroundColor DarkGray
Write-Host
Write-Host "This `"main.ps1`" script runs 5 other powershell scripts in order to generate the necessary" -ForegroundColor DarkGray
Write-Host "files to create and package a `"Vagrant box`" from a virtual machine that we have created" -ForegroundColor DarkGray
Write-Host "with `"VirtualBox`". These scripts can be executed individually, the function of `"main.ps1`"" -ForegroundColor DarkGray
Write-Host "is to simplify the process and create all the necessary files at once." -ForegroundColor DarkGray
Write-Host
Write-Host "Scripts:" -ForegroundColor DarkGray
Write-Host "========" -ForegroundColor DarkGray
Write-Host "1.- create_Vagrantfile.sh" -ForegroundColor DarkYellow
Write-Host "2.- create_info_json.sh" -ForegroundColor DarkYellow
Write-Host "3.- create_vagrant_box.sh" -ForegroundColor DarkYellow
Write-Host "4.- create_metadata_json.sh" -ForegroundColor DarkYellow
Write-Host "5.- add_vagrant_box.sh" -ForegroundColor DarkYellow
Write-Host
Write-Host "https://www.vagrantup.com/docs/boxes" -ForegroundColor DarkGray
Write-Host
Write-Host "========================================================================================="
Write-Host "Author: " -nonewline
Write-Host "Juan M. Payan Barea (st4rt.fr0m.scr4tch@gmail.com)" -ForegroundColor green
Write-Host "https://github.com/jpaybar"
Write-Host "https://www.linkedin.com/in/juanmanuelpayan/"
Write-Host "========================================================================================="
Write-Host
Write-Host "#########################################################################################" -ForegroundColor DarkGray
Write-Host
Write-Host "Press intro to start...."
Read-Host intro

# prompt vars
Write-Host "Enter the name for the Vagrant Box (Where " -nonewline -ForegroundColor DarkGray
Write-Host "<box_name> " -nonewline -ForegroundColor DarkYellow 
Write-Host "Must be the name or UUID of the " -ForegroundColor DarkGray
Write-Host "machine from the VirtualBox GUI):" -ForegroundColor DarkGray
$BOX_NAME=Read-Host

Write-Host "Enter the version for the Vagrant Box (For example " -nonewline -ForegroundColor DarkGray 
Write-Host "1.0" -nonewline -ForegroundColor DarkYellow
Write-Host "):" -ForegroundColor DarkGray
$BOX_VERSION=Read-Host

Write-Host

# Creating the Vagrantfile
Write-Host "Press enter to run " -nonewline -ForegroundColor DarkGray 
Write-Host "`"create_Vagrantfile.ps1`" " -nonewline -ForegroundColor DarkYellow
Write-Host "...." -ForegroundColor DarkGray
Read-Host intro
.\create_Vagrantfile.ps1 $BOX_NAME $BOX_VERSION

# Creating the info.json file
Write-Host "Press enter to run " -nonewline -ForegroundColor DarkGray 
Write-Host "`"create_info_json.ps1`" " -nonewline -ForegroundColor DarkYellow
Write-Host "...." -ForegroundColor DarkGray
Read-Host intro
.\create_info_json.ps1 $BOX_NAME $BOX_VERSION

# Creating the Vagrant Box file
Write-Host "Press enter to run " -nonewline -ForegroundColor DarkGray 
Write-Host "`"create_vagrant_box.ps1`" " -nonewline -ForegroundColor DarkYellow
Write-Host "...." -ForegroundColor DarkGray
Read-Host intro
.\create_vagrant_box.ps1 $BOX_NAME $BOX_VERSION

# Creating the metadata.json file
Write-Host "Press enter to run " -nonewline -ForegroundColor DarkGray 
Write-Host "`"create_metadata_json.ps1`" " -nonewline -ForegroundColor DarkYellow
Write-Host "...." -ForegroundColor DarkGray
Read-Host intro
.\create_metadata_json.ps1 $BOX_NAME $BOX_VERSION

# Adding the Vagrant Box file
Write-Host "Press enter to run " -nonewline -ForegroundColor DarkGray 
Write-Host "`"add_vagrant_box.ps1`" " -nonewline -ForegroundColor DarkYellow
Write-Host "...." -ForegroundColor DarkGray
Read-Host intro
.\add_vagrant_box.ps1 $BOX_NAME $BOX_VERSION

# Showing created files
Get-ChildItem $CURRENT_DIR\..\boxes
Write-Host
Write-Host
