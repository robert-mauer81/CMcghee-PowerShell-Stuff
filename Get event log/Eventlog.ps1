import-module Microsoft.PowerShell.Management

$logname = (Read-host -Prompt "Enter Logname")
$Newest = (Read-host -Prompt "Enter Number")
Get-EventLog -logname $logname -Newest $Newest

#PS Version 7

#Get-Winevent -logname $logname -MaxEvents $Newest