<#
.Synopsis
   Creates Anti-Spam Inbound Policy and updated Microsoft's default policy
.NOTES
   Requires ExchangePowershell Module, run Install-Module -Name ExchangeOnlineManagement if it is not already installed.
.LINKS
    Set-HostedOutboundSpamFilterPolicy
        https://learn.microsoft.com/en-us/powershell/module/exchange/set-hostedoutboundspamfilterpolicy
    New-HostedOutboundSpamFilterPolicy
        https://learn.microsoft.com/en-us/powershell/module/exchange/new-hostedoutboundspamfilterpolicy
    New-HostedOutboundSpamFilterRule
        https://learn.microsoft.com/en-us/powershell/module/exchange/new-hostedoutboundspamfilterrule
#>

Connect-ExchangeOnline

#Domains to protect
$Domains = ("Contoso.com","Contoso.net")

#Updates Microsoft's prebuilt policy
Set-HostedOutboundSpamFilterPolicy -Identity default -RecipientLimitExternalPerHour 500 -RecipientLimitInternalPerHour 10000 -RecipientLimitPerDay 10000

#Creates new policy
New-HostedOutboundSpamFilterPolicy -Name "Default Outbound" `
    -RecipientLimitExternalPerHour 500 `
    -RecipientLimitInternalPerHour 10000 `
    -RecipientLimitPerDay 10000 `
    -ActionWhenThresholdReached BlockUser `
    -AutoForwardingMode Off `
    -NotifyOutboundSpam $true `
    -NotifyOutboundSpamRecipients support@heliontechnologies.com

#Completes new Policy by making it a rule and setting it's priority to 0
New-HostedOutboundSpamFilterRule -Name "Default Outbound" -HostedOutboundSpamFilterPolicy "Default Outbound" -SenderDomainIs $Domains -Priority 0