<#
.DESCRIPTION
This script creates an alternative "metadata.json".

.PARAMETER BOX_NAME
BOX_NAME, Where <BOX_NAME> must be the name or UUID of the machine from the VirtualBox GUI.

.PARAMETER BOX_VERSION
BOX_VERSION, Where <BOX_VERSION> is the version of our Vagrant Box.

.EXAMPLE
PS> .\create_metadata_json.ps1 -BOX_NAME ubuntu2004 -BOX_VERSION 1.0

.EXAMPLE
PS> .\create_metadata_json.ps1 ubuntu2004 1.0

.SYNOPSIS
This script creates an alternative "metadata.json" which we can include when creating 
our base box. This file will contain the minimum configuration (providers) , as well  
as the name, version, description, etc... of our Vagrant Box.

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
	Write-Host  "This script creates an alternative `"metadata.json`" which we can include when creating 
our base box. This file will contain the minimum configuration (providers) , as well  
as the name, version, description, etc... of our Vagrant Box." -ForegroundColor DarkGray
	Write-Host
	Write-Host "https://www.vagrantup.com/docs/boxes/format" -ForegroundColor DarkGray
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

# Getting SHA256SUM of our Vagrant Box.
if(Test-Path -Path $CURRENT_DIR\..\boxes\$BOX_NAME-version_$BOX_VERSION.box -PathType Leaf){
   $HASHFILE=(certutil -hashfile $BOX_NAME-version_$BOX_VERSION.box SHA256 > $BOX_NAME-version_$BOX_VERSION.txt)
   $SHA256SUM=(Get-Content $BOX_NAME-version_$BOX_VERSION.txt)[1]
   Remove-Item $BOX_NAME-version_$BOX_VERSION.txt 
}
else{
   Write-Host
   Write-Host "The `"$BOX_NAME-version_$BOX_VERSION.box`" file does not exist, you must create this `"box`" before execute this
script." -ForegroundColor Red
   Write-Host
   exit 1
}

# Info name/version/SHA256SUM
Write-Host BOX_NAME=$BOX_NAME
Write-Host BOX_VERSION=$BOX_VERSION
Write-Host SHA256SUM=$SHA256SUM

# Replacing Windows Path style for Unix Path type.
$PATTERN = '[\\/]'
$UNIX_PWD = $PWD -replace $PATTERN, '/'

# Generating metadata.json file
echo @"
{
    "name": "$BOX_NAME",
    "description": "This Vagrant Box was created by jpaybar, https://github.com/jpaybar",
    "versions": [{
        "version": "$BOX_VERSION",
        "providers": [{
                "name": "virtualbox",
                "url": "file:///$UNIX_PWD/$BOX_NAME-version_$BOX_VERSION.box",
                "checksum_type": "sha256",
                "checksum": "$SHA256SUM"
        }]
    }]
}
"@ | out-file $BOX_NAME-version_$BOX_VERSION.json -Encoding ascii

cd ..\scripts\

Write-Host
Write-Host "The `"metadata.json`" file was created as " -ForegroundColor green -nonewline 
Write-Host "`"boxes\$BOX_NAME-version_$BOX_VERSION.json`"." -ForegroundColor DarkGray
Write-Host
Write-Host