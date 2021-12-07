
new-speech 'Enter the logname you wish to query'
$logname= (Read-host)
new-speech 'Enter the number of events you like to review'
$newest =(Read-Host)
Get-EventLog -LogName $logname -Newest $newest