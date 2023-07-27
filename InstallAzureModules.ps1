
$PSVersionTable.PSVersion
Set-Executionpolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name PowerShellGet -Force
install-module -Name AZ -force

#similiar
Install-Module MSOnline -force
#Azure Active Directory PowerShell for Graph
Install-Module AzureAD -Force

#Connececting
Connect-MsolService
#Connect-AzureAD 
Connect-AzAccount

#Subscrition info and Resource group info
Get-AzSubscription
Get-AzResourceGroup

get-command -Module Az
