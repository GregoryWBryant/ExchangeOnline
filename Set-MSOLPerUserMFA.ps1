<#
    Uses the MSOnline which is now deprecate
    Install-Module MSOnline
    Used for enfocing all users to use MFA via Per-User method.
#>

# Connect to Microsoft Online Services
Connect-MsolService

# Import Users from CSV
$Users = Import-Csv -Path "C:\path\to\your\users.csv"

# Define Strong Authentication Requirements
$Requirements = @()  # Create an empty array to hold requirements

# Create a Strong Authentication Requirement Object
$Requirement = [Microsoft.Online.Administration.StrongAuthenticationRequirement]::new()
# Apply to all relying parties (applications)
$Requirement.RelyingParty = "*"
# Set the requirement to be enforced
$Requirement.State = "Enforced"
# Add the requirement to the array
$Requirements += $Requirement

# Process Each User
Foreach ($User in $Users) {
    # Display the user's email for tracking (optional)
    Write-Output "Processing: $($User.Email)" 
    
    # Set Strong Authentication Requirement
    Set-MsolUser -UserPrincipalName $User.Email -StrongAuthenticationRequirements $Requirements
}

# Disconnect from Microsoft Online Services
Disconnect-MsolService 
