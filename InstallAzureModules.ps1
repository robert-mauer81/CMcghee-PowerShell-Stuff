
$PSVersionTable.PSVersion
Install-Module -Name PowerShellGet -Force
install-module -Name AZ

#similiar
Install-Module MSOnline
#Azure Active Directory PowerShell for Graph
Install-Module AzureAD

#Connececting
Connect-MsolService
Connect-AzureAD

#Subscrition info and Resource group info
Get-AzSubscription
Get-AzResourceGroup