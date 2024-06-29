<#
.Synopsis
   Creates Anti-Spam Inbound Policy and updated Microsoft's default policy
.NOTES
   Requires ExchangePowershell Module, run Install-Module -Name ExchangeOnlineManagement if it is not already installed.
.Links
    Set-QuarantinePolicy   
        https://learn.microsoft.com/en-us/powershell/module/exchange/set-quarantinepolicy
    New-QuarantinePolicy
        https://learn.microsoft.com/en-us/powershell/module/exchange/new-quarantinepolicy
    New-HostedContentFilterPolicy
        https://learn.microsoft.com/en-us/powershell/module/exchange/new-hostedcontentfilterpolicy
    New-HostedContentFilterRule
        https://learn.microsoft.com/en-us/powershell/module/exchange/new-hostedcontentfilterrule
    Set-HostedContentFilterPolicy
        https://learn.microsoft.com/en-us/powershell/module/exchange/set-hostedcontentfilterpolicy
        
#>

Connect-ExchangeOnline

#Update with Domains you want to be Allowed
$AllowedSenderDomains = ("GoodDomain.net","GoodDomain.com")
#Update with users you want to be Allowed
$AllowedSenders = "Good@GoodDomain.com"
#Update with Domains you want to be Blocked
$BlockedSenderDomains = "BadDomain.com"
#Update with users you want to be Blcked
$BlockedSenders = ("Bad@BadDomain.net","Worse@WorseDomain.com")
#Update with your Domains you wish to Protect
$Domains = ("Contoso.net","Contoso.com")

#Updates the default notifcation frequency, modified to desired number of days.
Set-QuarantinePolicy -Identity 'DefaultGlobalTag' -EndUserSpamNotificationFrequencyInDays 3

#EndUserQuarantinePermissionsValue 27 gives users limited rights to Quarantine messages, and ENSEnabled enables notifications. We will use this to apply to our Content Filter Policy
New-QuarantinePolicy -Name "NotificationsEnabled" `
    -EndUserQuarantinePermissionsValue 27 `
    -QuarantineRetentionDays 30 `
    -ESNEnabled $true

#Creates a new Inbound Policy
New-HostedContentFilterPolicy -Name "Default Inbound Spam" `
    -AllowedSenderDomains $AllowedSenderDomains `
    -AllowedSenders $AllowedSenders `
    -BlockedSenderDomains $BlockedSenderDomains `
    -BlockedSenders $BlockedSenders `
    -BulkSpamAction MoveToJmf `
    -BulkQuarantineTag "NotificationsEnabled" `
    -BulkThreshold 6 `
    -EnableEndUserSpamNotifications $true `
    -HighConfidencePhishAction Quarantine `
    -HighConfidencePhishQuarantineTag "NotificationsEnabled" `
    -HighConfidenceSpamAction Quarantine `
    -HighConfidenceSpamQuarantineTag "NotificationsEnabled" `
    -IncreaseScoreWithBizOrInfoUrls On `
    -IncreaseScoreWithImageLinks On `
    -IncreaseScoreWithNumericIps On `
    -IncreaseScoreWithRedirectToOtherPort On `
    -InlineSafetyTipsEnabled $true `
    -MarkAsSpamEmbedTagsInHtml On `
    -MarkAsSpamEmptyMessages On `
    -MarkAsSpamJavaScriptInHtml On `
    -PhishSpamAction Quarantine `
    -PhishQuarantineTag "NotificationsEnabled" `
    -QuarantineRetentionPeriod 30 `
    -SpamAction Quarantine `
    -SpamQuarantineTag "NotificationsEnabled" `
    -SpamZapEnabled $true `
    -EndUserSpamNotificationFrequency 3

#Completes the polciy by making it a rule and setting it to Priority 0
New-HostedContentFilterRule -Name "Default Inbound Spam" -Priority 0 -HostedContentFilterPolicy "Default Inbound Spam" -RecipientDomainIs $Domains

#This updates Microsoft's prebuilt policy.
Set-HostedContentFilterPolicy -Identity "Default" `
    -AllowedSenderDomains $AllowedSenderDomains `
    -AllowedSenders $AllowedSenders `
    -BlockedSenderDomains $BlockedSenderDomains `
    -BlockedSenders $BlockedSenders `
    -BulkSpamAction MoveToJmf `
    -BulkQuarantineTag "NotificationsEnabled" `
    -BulkThreshold 6 `
    -EnableEndUserSpamNotifications $true `
    -HighConfidencePhishAction Quarantine `
    -HighConfidencePhishQuarantineTag "NotificationsEnabled" `
    -HighConfidenceSpamAction Quarantine `
    -HighConfidenceSpamQuarantineTag "NotificationsEnabled" `
    -IncreaseScoreWithBizOrInfoUrls On `
    -IncreaseScoreWithImageLinks On `
    -IncreaseScoreWithNumericIps On `
    -IncreaseScoreWithRedirectToOtherPort On `
    -InlineSafetyTipsEnabled $true `
    -MarkAsSpamEmbedTagsInHtml On `
    -MarkAsSpamEmptyMessages On `
    -MarkAsSpamJavaScriptInHtml On `
    -PhishSpamAction Quarantine `
    -PhishQuarantineTag "NotificationsEnabled" `
    -QuarantineRetentionPeriod 30 `
    -SpamAction Quarantine `
    -SpamQuarantineTag "NotificationsEnabled" `
    -SpamZapEnabled $true
