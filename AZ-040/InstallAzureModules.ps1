$PSVersionTable.PSVersion


#similiar
Install-Module MSOnline -force
Update-Module MSOnline
#Azure Active Directory PowerShell for Graph
Install-Module AzureAD -Force
Update-Module AzureAD


#Connececting
Connect-MsolService
connect-Msonline

Connect-AzureAD 
#Connect-AzAccount

#Subscription info and Resource group info
Get-AzSubscription
Get-AzResourceGroup

Install-Module ExchangeOnlineManagement
UpDate-Module ExchangeOnlineManagement

Connect-ExchangeOnline

Install-Module -Name Microsoft.Online.SharePoint.PowerShell
Update-Module -Name Microsoft.Online.SharePoint.PowerShell
Connect-SPOService -Url https://M365x67585250-admin.sharepoint.com

Install-Module MicrosoftTeams

Connect-MicrosoftTeams
