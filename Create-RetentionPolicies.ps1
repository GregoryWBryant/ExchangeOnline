<#
    Sets up Retention Policies in Exchange Online and Microsoft Purview Compliance Center.
    You need a proper license for using Connect-IPPSSession (typically E5 or a compliance add-on).
    Some cmdlets may not be available if you lack the required permissions.
#>

# Connect to Exchange Online
Connect-ExchangeOnline

# Connect to Microsoft Purview Compliance Center (requires license)
Connect-IPPSSession

# Create Exchange Legacy Retention Policy tag (5-year move to archive)
New-RetentionPolicyTag -Name "Default 5 year move to archive" `
    -AgeLimitForRetention 1825 `
    -Type All `
    -RetentionAction MoveToArchive `
    -RetentionEnabled $true 

# Update Default MRM Policy (replace 2-year default with the new 5-year tag)
Set-RetentionPolicy -Identity "Default MRM Policy" -RetentionPolicyTagLinks ("5 Year Delete","1 Year Delete","6 Month Delete","Personal 5 year move to archive","1 Month Delete","1 Week Delete","Personal never move to archive" `
,"Personal 1 year move to archive","Default 5 year move to archive","Junk Email","Recoverable Items 14 days move to archive","Never Delete")

# Create 1-year retention policy for Exchange, SharePoint, OneDrive, and M365 Groups
New-RetentionCompliancePolicy -Name "Default 1 Year" `
    -Enabled $true `
    -ExchangeLocation All `
    -ModernGroupLocation All `
    -OneDriveLocation All `
    -SharePointLocation All

# Create 1-year retention policy for Microsoft Teams Channels
New-RetentionCompliancePolicy -Name "Default 1 Year Team Channels" `
    -Enabled $true `
    -TeamsChannelLocation All

# Create 1-year retention policy for Private Microsoft Teams Channels
New-AppRetentionCompliancePolicy -Name "Default 1 Year Private Team Channels" `
    -Enabled $true `
    -Applications "User:MicrosoftTeamsChannelMessages"

# Apply 1-year retention rule to each of the above policies
New-RetentionComplianceRule -Name "Default 1 Year" -Policy "Defaults 1 Year" -RetentionDuration 365 -RetentionComplianceAction Keep -ExpirationDateOption CreationAgeInDays
New-RetentionComplianceRule -Name "Default 1 Year Team Channels" -Policy "Default 1 Year Team Channels" -RetentionDuration 365 -RetentionComplianceAction Keep -ExpirationDateOption CreationAgeInDays
New-AppRetentionComplianceRule -Name "Default 1 Year Private Team Channels" -Policy "Default 1 Year Private Team Channels" -RetentionDuration 365 -RetentionComplianceAction Keep -ExpirationDateOption CreationAgeInDays

# Enable the Private Teams policy for Exchange
Set-AppRetentionCompliancePolicy -Identity "Default 1 Year Private Team Channels" -AddExchangeLocation All

# Disconnects from both ExchangeOnline and IPPSSession
Disconnect-ExchangeOnline