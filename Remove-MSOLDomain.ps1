<#
    Uses the MSOnline which is now deprecate
    Install-Module MSOnline
    Used for cleaning up users email and aliases to be able to remove Domain from 365.
    
#>

# Connect to Microsoft Online Services
Connect-MsolService

# Connect to Exchange Online
Connect-ExchangeOnline

# Define Domains
$DomainToRemove = "contoso2.com"
$DomainToReplaceWith = "contoso.com"

# Get MSOL Users with the Specified Domain
$MSOLUsers = Get-MSOLUser | Where-Object { $_.UserPrincipalName –like ("*" + $DomainToRemove) }

# Update UPNs in MSOL
foreach ($MSOLUser in $MSOLUsers) {
    # Get full UPN
    $UserPrincipalName = (Get-MsolUser -ObjectId $MSOLUser.ObjectId).UserPrincipalName
     # Output current UPN
    Write-Output "Current UPN: $UserPrincipalName"
    # Construct new UPN
    $Split = $UserPrincipalName -split "@"   
    $NewUPN = ($Split[0] + "@" + $DomainToReplaceWith)
    # Output change
    Write-Output "New UPN: $NewUPN"
    
    Set-MsolUserPrincipalName -UserPrincipalName $UserPrincipalName -NewUserPrincipalName $NewUPN
}

# Get Exchange Mailboxes
$ExchangeUsers = Get-Mailbox

# Update Email Addresses in Exchange
foreach ($ExchangeUser in $ExchangeUsers) {
    $Alias = ($ExchangeUser.Alias + "@" + $DomainToRemove)
    $NewWindowsLiveID = ($ExchangeUser.Alias + "@" + $DomainToReplaceWith)

    Set-Mailbox $ExchangeUser -MicrosoftOnlineServicesID $NewWindowsLiveID
    Set-Mailbox $ExchangeUser -EmailAddresses @{Remove=$Alias}
}

# Disconnect from Microsoft Online Services
Disconnect-MsolService

# Disconnect from Exchange Online
Disconnect-ExchangeOnline
