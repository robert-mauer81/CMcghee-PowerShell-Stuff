install-Module AzureAD -force
Connect-AzureAD

install-Module MsOnline -force
Connect-MsolService



Get-AzureAduser -All $true
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAd.Model.PasswordProfile
$PasswordProfile.Password = "ThisIsAPa55w.rd!"
$verifiedDomain = (Get-AzureADTenantDetail).VerifiedDomains[0].Name
New-AzureADUser -DisplayName "Donald Watson" -UserPrincipalName Donald@$verifiedDomain `
    -AccountEnabled $true -PasswordProfile $PasswordProfile -MailNickName Donald

$user = Get-AzureADUser -ObjectID Donald@$verifiedDomain
$role = Get-AzureADDirectoryRole | Where { $_.displayName -eq 'Global Administrator' }
Add-AzureADDirectoryRoleMember -ObjectId $role.ObjectId -RefObjectId $user.ObjectID
Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId

Connect-MsolService

New-MsolUser -DisplayName "Tim Peters" -FirstName "Tim" -LastName "Peters" -UserPrincipalName "Tim@M365x56210031.onmicrosoft.com"
get-Msoluser -UserPrincipalName "Tim@M365x56210031.onmicrosoft.com"

#exhangeonline
Install-Module ExchangeOnlineManagement

Connect-ExchangeOnline
#get mail boxes
Get-EXOMailbox

#sharpnt online
Install-Module -Name Microsoft.Online.SharePoint.PowerShell
Connect-SPOService -Url https://M365x56210031-admin.sharepoint.com
#List sites
Get-SPOSite
New-SPOSite -Url https://M365x56210031.sharepoint.com/sites/Sales -Owner Donald@M365x56210031.onmicrosoft.com -StorageQuota 256 -Template EHS#1

$Teams
Install-Module MicrosoftTeams
Connect-MicrosoftTeams

Get-team
New-Team -DisplayName "PowerShell Team" -MailNickName "PSTeam"
$team = Get-Team -DisplayName "PowerShell Team"
$team | FL

Add-TeamUser -GroupId $team.GroupId -User Donald@M365x56210031.onmicrosoft.com -Role Member
