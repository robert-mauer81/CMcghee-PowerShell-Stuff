Connect-AzureAD

Get-AzureADUser
#Create Azure User and add to a Global admin Role
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "Pa55w.rd2024"
New-AzureADUser -DisplayName "Noreen Riggs" -UserPrincipalName Noreen@M365x29835684.onmicrosoft.com -AccountEnabled $true -PasswordProfile $PasswordProfile -MailNickName Noreen

Get-AzureAduser -All $true
Get-AzureADUser -ObjectId Noreen@M365x29835684.onmicrosoft.com

#Adduser to a Role
$user = Get-AzureADUser -ObjectID Noreen@M365x29835684.onmicrosoft.com
$role = Get-AzureADDirectoryRole | Where { $_.displayName -eq 'Global Administrator' }
Add-AzureADDirectoryRoleMember -ObjectId $role.ObjectId -RefObjectId $user.ObjectID
    
#Add user to a role with MSOL
Connect-MsolService
Add-MsolRoleMember -RoleMemberEmailAddress Noreen@M365x29835684.onmicrosoft.com -RoleName 'User Administrator'

#create user and assign license
New-AzureADUser -DisplayName "Allan Yoo" -UserPrincipalName Allan@M365x29835684.onmicrosoft.com -AccountEnabled $true -PasswordProfile $PasswordProfile -MailNickName Allan
#remember location property must be set
Set-AzureADUser -ObjectId Allan@M365x29835684.onmicrosoft.com -UsageLocation US
Get-AzureADSubscribedSku | select skupartnumber, skuid | FT
$SkuId = (Get-AzureADSubscribedSku | Where SkuPartNumber -eq "ENTERPRISEPREMIUM").SkuID
$License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$License.SkuId = $SkuId
$LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$LicensesToAssign.AddLicenses = $License
Set-AzureADUserLicense -ObjectId Allan@M365x29835684.onmicrosoft.com -AssignedLicenses $LicensesToAssign


#Create user with MSonline
New-MsolUser -DisplayName "Sammy Buzikashvilli" -FirstName "Sammy" -LastName "Buzikashvilli" -UserPrincipalName Sammy@M365x29835684.onmicrosoft.com -Password "Pa55w.rd"

Get-msoluser -UserPrincipalName Sammy@M365x29835684.onmicrosoft.com
Get-Msoluser -All

#New Azure group
New-AzureADGroup -DisplayName "PSCA12" -MailEnabled $true -SecurityEnabled $true -MailNickname PSCA12
Get-AzureADGroup 

New-MsolGroup -DisplayName "Team Typo" 
Get-MsolGroup


#MSgraph 
Install-Module Microsoft.Graph 
Get-InstalledModule Microsoft.Graph

# Using interactive authentication for users, groups, teamsettings, RoleManagement.
Connect-MgGraph -Scopes "User.ReadWrite.All", "Application.ReadWrite.All", "Sites.ReadWrite.All", "Directory.ReadWrite.All", "Group.ReadWrite.All", "RoleManagement.ReadWrite.Directory"

Get-MgUser
#get Verified domain
$verifiedDomain = (Get-MgOrganization).VerifiedDomains[0].Name

#password profile
$PasswordProfile = @{  
    "Password"                      = "Pa55w0rd2024";  
    "ForceChangePasswordNextSignIn" = $true  
}  

New-MgUser -DisplayName "Edward The Hurtman Hurtado" -UserPrincipalName "Hurt@$verifiedDomain" -AccountEnabled -PasswordProfile $PasswordProfile -MailNickName "Hurt"

#Add to a role
$user = Get-MgUser -UserId "Hurt@$verifiedDomain"
$role = Get-MgDirectoryRole | Where { $_.displayName -eq 'Global Administrator' }

$OdataId = "https://graph.microsoft.com/v1.0/directoryObjects/" + $user.id  
New-MgDirectoryRoleMemberByRef -DirectoryRoleId $role.id -OdataId $OdataId    

#Check it
Get-MgDirectoryRoleMember -DirectoryRoleId $role.id
