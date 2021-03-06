<#PSScriptInfo
.VERSION 1.0.0
.AUTHOR ShellGibson
.DESCRIPTION Gather device hash from local machine and automatically upload it to Autopilot
.TAGS Exchange Online Archive
.LICENSEURI
.PROJECTURI https://github.com/ShellGibson/exo-mailbox-archiver/edit/main/EXOMailboxArchiver.ps1
#>
# Requires -Module ExchangeOnlineManagement 

Write-Host "
         	* OPTIONS *          
[1] Enable archive for all mailboxes        
[2] Disable archive for all mailboxes       
" -ForegroundColor Yellow

$Options = Read-Host

# Check ExchangeOnlineManagement is installed.
Write-Output "Checking ExchangeOnlineManagement is installed..."
$IsInstalled = Get-InstalledModule -Name ExchangeOnlineManagement

if ($IsInstalled.Name -eq "ExchangeOnlineManagement") {Write-Host "ExchangeOnlineManagement is installed." -ForegroundColor Green}

else {
    Write-Host "ExchangeOnlineManagement isn't installed..." -ForegroundColor Red
    Install-Module -Name ExchangeOnlineManagement
}

# Get PS Session and Connect to Exchange Online.
$GetSessions = Get-PSSession | Select-Object -Property State, Name
$IsConnected = (@($GetSessions) -like '@{State=Opened; Name=ExchangeOnlineInternalSession*').Count -gt 0
if ($IsConnected -ne "True") {
    Connect-ExchangeOnline
}



$Results = Get-Mailbox -ResultSize unlimited 
$Alias = Write-Output $Results.Alias

# Script
switch ($Options) {
    1 {
        foreach ($i in $Alias){
            Enable-Mailbox -Identity $i -Archive -Confirm:$False | Out-Null
        }}

    2 { 
        foreach ($i in $Alias){
            Disable-Mailbox -Identity $i -Archive -Confirm:$False | Out-Null
        }

    }
}

Get-Mailbox -Archive
