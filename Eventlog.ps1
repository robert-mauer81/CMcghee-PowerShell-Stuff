$logname = (Read-host -Prompt "Enter Logname")
$PleaseStop = (Read-host -Prompt "Enter Number")
Get-eventlog -logname $logname -Newest $PleaseStop