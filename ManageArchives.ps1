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

Write-Host "
         	* OPTIONS *          
[1] Enable archive for all mailboxes        
[2] Disable archive for all mailboxes       
" -ForegroundColor Yellow

$Options = Read-Host

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
