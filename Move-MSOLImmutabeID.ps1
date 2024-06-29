<#
    Uses the MSOnline which is now deprecate
    Install-Module MSOnline
    This script is designed to handle situations where Azure AD Connect creates a duplicate user instead of matching to an existing cloud account.
#>

# Connect to Microsoft Online Services
Connect-MsolService

# Define User Principal Names (UPNs)
$UPN1 = "john@contoso2.com"
$UPN2 = "john@contoso.com"

# Get the User Object by UPN1
$User = Get-MsolUser -UserPrincipalName $UPN1

# Retrieve and Store the Immutable ID (Important for Re-linking)
$ImmutableId = $User.ImmutableId

# Forcefully Remove the User by UPN1
Remove-MsolUser -UserPrincipalName $UPN1 -Force

# Permanently Delete from Recycle Bin
Remove-MsolUser -UserPrincipalName $UPN1 -RemoveFromRecycleBin -Force

# Re-link the Immutable ID to the New UPN
Set-MsolUser -UserPrincipalName $UPN2 -ImmutableId $ImmutableId

# Disconnect from MSOnline
Disconnect-MsolService