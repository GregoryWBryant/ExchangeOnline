# Ensure you have the ExchangeOnlineManagement module installed.
# Install-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline

# Import Users from CSV
$Users = Import-Csv -Path "C:\path\to\your\users.csv"

# CSV Requirements
# The CSV file MUST have the following headers (column names):
#   * Source Email: The existing email address of the user to modify.
#   * Destination Email: The email address where you want to forward emails.

# Process Each User
Foreach ($User in $Users) {
    # Set Mailbox to Deliver and Forward
    # This enables both delivery to the original mailbox and forwarding.
    Set-Mailbox -Identity $User.'Source Email' `
                -DeliverToMailboxAndForward $true `
                -ForwardingSMTPAddress $User.'Destination Email'
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline
