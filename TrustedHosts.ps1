#Check PS version

$PSVersionTable


#Modify local TrustedHosts



#Set-Item WSMAN:\localhost\Client\TrustedHosts -Value NYC-SRV2

#Get-Item WSMAN:\localhost\Client\TrustedHosts

#Clear-Item WSMAN:\localhost\Client\TrustedHosts

#or Using winrm from elevated command prompt

winrm set winrm/config/client @{TrustedHosts="LON-DC1"}


Enter-PSSession -ComputerName NYC-SRV2 -credential contoso\admin1
Exit-PSSession

#Alternativly

$session = New-PSSession -ComputerName NYC-SRV2 -Credential contoso\Admin1

Get-PSSession

Enter-PSSession -Id <ID#>

Get-PSSession | Remove-PSSession

#or
Invoke-command -session $session -ScriptBlock{Get-EventLog -LogName system -Newest 3}