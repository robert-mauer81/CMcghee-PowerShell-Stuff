$logname = (Read-host -Prompt "Entr Logname")
$Number = (Read-host -Prompt "Enter Number")
Get-eventlog -logname $logname -Newest $number