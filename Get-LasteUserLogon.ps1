Write-Host "Enter the name of the Server you wish to query:  " -ForegroundColor White -BackgroundColor Red -NoNewline
$Server = Read-Host
GET-Wmiobject -Class Win32_NetworkLoginProfile -ComputerName $Server | Sort -Property LastLogon -Descending | Select-Object -Property * -First 2 | 
Where-object { $_.LastLogon -match "(\d{14})" } |
Foreach-Object { New-Object PSObject -Property @{ Name = $_.Name; LastLogon = [datetime]::ParseExact($matches[0], "yyyyMMddHHmmss", $null) } }


Write-Host "Enter the name of the Server you wish to query:  " -ForegroundColor White -BackgroundColor Gray -NoNewline
$Server = Read-Host

Get-CimInstance -Namespace Root\cimV2 -Class Win32_NetworkLoginProfile -ComputerName $Server | 

#Sort decending and pick the top one off the sort
Sort -Property LastLogon -Descending  | Select-Object -Property * -First 2 | 

#match 14 digits for datetime from LastLogon
Where-Object { $_.LastLogon -match "(?:\d{14})" } |
Foreach-Object { New-Object PSObject -Property @{ Name = $_.Name; LastLogon = [datetime]::ParseExact($matches[0], "yyyyMMddHHmmss", $null) } }

#$matches

