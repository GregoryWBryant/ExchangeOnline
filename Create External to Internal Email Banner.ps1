<#
.Synopsis
   Creates a rule to tag any emails coming from outside your Organization.
.NOTES
   Requires ExchangePowershell Module, run Install-Module -Name ExchangeOnlineManagement if it is not already installed.
.LINKS
    New-TransportRule   
        https://learn.microsoft.com/en-us/powershell/module/exchange/new-transportrule
        
#>

#Sets HTML code and text that will be Prepended to incoming messages.
$Text = "<table border=0 cellspacing=0 cellpadding=0 align='left' width='100%'>
    <tr>
      <td style='background:#F8D92A;padding:5pt 2pt 5pt 2pt'></td>
      <td width='100%' cellpadding='7px 6px 7px 15px' style='background:#F8D92A;padding:5pt 4pt 5pt 12pt;word-wrap:break-word'>
        <div style='color:#222222;'>
          <span style='color:#222; font-weight:bold;'>Caution:</span>
          This is an external from someone outsite your company, if you do not know the person please be careful. Reach out to the Support Desk with any concerns.
        </div>
      </td>
    </tr>
  </table>
  <br />
"

Connect-ExchangeOnline

#Creates Mail Rule to apply to External to Internal messages.
New-TransportRule -Name "External Email Banner" `
    -Priority 0 `
    -SenderAddressLocation HeaderOrEnvelope `
    -FromScope NotInOrganization `
    -SentToScope InOrganization `
    -ApplyHtmlDisclaimerLocation Prepend `
    -ApplyHtmlDisclaimerText $Text `
    -ApplyHtmlDisclaimerFallbackAction Wrap