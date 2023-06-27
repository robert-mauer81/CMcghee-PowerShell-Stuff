Write-Host "Enter the name of the Server you wish to query:  " -ForegroundColor White -BackgroundColor Red -NoNewline
$Server = Read-Host
GET-Wmiobject -Class Win32_NetworkLoginProfile -ComputerName $Server | Sort -Property LastLogon -Descending | Select-Object -Property * -First 2 | 
Wher-object { $_.LastLogon -match "(\d{14})" } |
Foreach-Object { New-Object PSObject -Property @{ Name = $_.Name; LastLogon = [datetime]::ParseExact($matches[0], "yyyyMMddHHmmss", $null) } }