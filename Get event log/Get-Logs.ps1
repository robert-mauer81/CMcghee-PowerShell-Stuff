$Logname = (Read-host -Prompt "Type in the log name you wish to retreive")
$newest = (Read-Host -Prompt "Enter the number of records you wish to see")
Get-EventLog -LogName $Logname -Newest $newest
