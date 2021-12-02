$logname = (Read-host -Prompt "Enter Logname")
$Newest = (Read-host -Prompt "Enter Number")
Get-eventlog -logname $logname -Newest $Newest