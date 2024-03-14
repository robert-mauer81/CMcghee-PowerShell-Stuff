#Task 1
Get-Command -Verb Get -Noun *date
Get-Date | Get-Member
Get-Date | Select-Object -Property DayOfYear
Get-Date | Select-Object -Property DayOfYear | fl

#Task 2 
Get-Command *hotfix*
Get-Hotfix | Get-Member
Get-Hotfix | Select-Object -Property HotFixID, InstalledOn, InstalledBy
Get-Hotfix | Select-Object -Property HotFixID, @{n = 'Days since install'; e = { (New-TimeSpan -Start $PSItem.InstalledOn).Days } }, InstalledBy

#Task 3
Get-Command -Verb Get -noun *Scope*
Get-DHCPServerv4Scope -ComputerName LON-DC1
Get-DHCPServerv4Scope -ComputerName LON-DC1 | Select-Object -Property ScopeId, SubnetMask, Name | fl

#Task 4
Get-Command -Verb Get -Noun *firewall*
Get-NetFirewallRule | GM
Get-NetFirewallRule -Enabled True
Get-NetFirewallRule -Enabled True | Format-Table -wrap
Get-NetFirewallRule -Enabled True | Select-Object -Property DisplayName, Profile, Direction, Action | Sort-Object -Property Profile, DisplayName | Format-Table -GroupBy Profile

#Task 5\
Get-Command -Verb Get -Noun *neighbor*
Help Get-NetNeighbor -ShowWindow
Get-NetNeighbor | Sort-Object -Property State
Get-NetNeighbor | Sort-Object -Property State | Select-Object -Property IPAddress, State | Format-Wide -GroupBy State -AutoSize

#Task 6
Test-NetConnection LON-DC1
Get-DnsClientCache
Get-DnsClientCache | Select-Object Name, Type, TimeToLive | Sort-Object Name | Format-List

#Task 7
Help Get-aduser -Online
Get-ADUser -Filter * | Format-Table
Get-ADUser -Filter * -SearchBase "OU=IT,dc=Adatum,dc=com" -Properties *  | Where-Object -Property city -EQ 'London' | Select-Object Name, Department, City | sort-object Name 
#or probably better
Get-ADUser -Filter * -Properties Department, City | Where-Object { $PSItem.Department -eq 'IT' -and $PSItem.City -eq 'London' } | Select-Object -Property Name, Department, City | Sort Name
#set Office property
Get-ADUser -Filter * -SearchBase "OU=IT,dc=Adatum,dc=com" -Properties *  | Where-Object -Property city -EQ 'London'  | Set-aduser -Office LON-A/100 -WhatIf
#or
Get-ADUser -Filter * -Properties Department, City | Where-Object { $PSItem.Department -eq 'IT' -and $PSItem.City -eq 'London' } | Set-ADUser -Office 'LON-A/1000' -WhatIf

Get-ADUser -Filter * -SearchBase "OU=IT,dc=Adatum,dc=com" -Properties *  | Where-Object -Property city -EQ 'London' | Select-Object Name, Department, City, Office | sort-object Name 

#Task * HTML
help ConvertTo-Html -ShowWindow

Get-ADUser -Filter * -Properties Department, City, Office | 
Where-Object { $PSItem.Department -eq 'IT' -and $PSItem.City -eq 'London' } | 
Sort-Object Name | 
Select-Object -Property Name, Department, City, Office |
ConvertTo-Html -Property Name, Department, City -PreContent Users | 
Out-File E:\UserReport.html

#Or Without Convert
Get-ADUser -Filter * -Properties Department, City, Office | 
Where-Object { $PSItem.Department -eq 'IT' -and $PSItem.City -eq 'London' } | 
Sort-Object Name | 
Select-Object -Property Name, Department, City, Office |
Export-Clixml E:\UserReport.xml

#CSV
Get-ADUser -Filter * -Properties Department, City, Office | 
Where-Object { $PSItem.Department -eq 'IT' -and $PSItem.City -eq 'London' } | 
Sort-Object Name | 
Select-Object -Property Name, Department, City, Office |
Export-Csv E:\UserReport.csv

#Task 9
Get-ADUser -Filter * | Format-Table
Get-ADUser -Filter * -SearchBase "cn=Users,dc=Adatum,dc=com" | Format-Table

#Taks 10
Get-EventLog -LogName Security | 
Where-Object EventID -eq 4624 | Measure-Object | Format-Wide

Get-EventLog -LogName Security | 
Where-Object EventID -eq 4624 | 
Select-Object TimeWritten, EventID, Message

Get-EventLog -LogName Security | 
Where-Object EventID -eq 4624 | 
Select-Object TimeWritten, EventID, Message -Last 10 | Format-List


#Task 11
Get-ChildItem -Path CERT: -Recurse
Get-ChildItem -Path CERT: -Recurse | Get-Member
Get-ChildItem -Path CERT: -Recurse | 
Where-Object HasPrivateKey -eq $False | Select-Object -Property FriendlyName, Issuer | Format-List
#or:
Get-ChildItem -Path CERT: -Recurse | 
Where-Object { $PSItem.HasPrivateKey -eq $False } | Select-Object -Property FriendlyName, Issuer | Format-List
Get-ChildItem -Path CERT: -Recurse | 
Where-Object { $PSItem.HasPrivateKey -eq $False -and $PSItem.NotAfter -gt (Get-Date) -and $PSItem.NotBefore -lt (Get-Date) } | Select-Object -Property NotBefore, NotAfter, FriendlyName, Issuer | Format-Table -wrap



#Task 12
Get-Volume | GM

Get-Volume | Where-Object { $PSItem.SizeRemaining -gt 0 } | fl
Get-Volume | Where-Object { $PSItem.SizeRemaining -gt 0 -and $PSItem.SizeRemaining / $PSItem.Size -lt .99 } | Select-Object DriveLetter, @{n = 'Size'; e = { '{0:N2}' -f ($PSItem.Size / 1MB) } }
Get-Volume | Where-Object { $PSItem.SizeRemaining -gt 0 -and $PSItem.SizeRemaining / $PSItem.Size -lt .1 }



#Task 13
Get-command -Verb get -noun *control*

Get-ControlPanelItem 
Get-ControlPanelItem -Category 'System and Security' | Sort-Object Name
		
#Note: Notice that you do not have to use Where-Object.
	
Get-ControlPanelItem -Category 'System and Security' | Where-Object -FilterScript { -not ($PSItem.Category -notlike '*System and Security*') } | Sort-Object Name
