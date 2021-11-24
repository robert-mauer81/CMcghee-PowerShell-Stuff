$logname = (Read-host -Prompt "Enter Logname")
$newnumber = (Read-host -Prompt "Enter Number")
Get-eventlog -logname $logname -Newest $newnumber