#Name: FirewallGPO.ps1

#Execute on LON-DC1 domain Controller

#Supported on Powershell 3.0 With Active Directory Module
#Purpose: Create Computer Preferences GPO to disabling Firewall through Registry. 

#This Policy uses the built in Starter GPO "Group Policy Remote Update Firewall Ports" for my own enjoyment. :)
#It also resets the Local NIC

#Written by Christian McGhee chrs.mcghee@gmail.com
#Date 7.22.2015

#Copy SysInternal tools and Reset Local NIC "Ethernet" only, disable Firewall on all Network Profiles on LON-DC1

robocopy D:\PsTools C:\PsTools
Restart-NetAdapter -Name "Ethernet"
Start-Sleep -Seconds 5
Clear-DNSClientCache -AsJob
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False

#Create New GPO to deal with the firewall on Client devices 

New-GPStarterGPO "Create Starter" -Comment "This creates the necessary Starter Policies Folder"
New-GPO -StarterGpoName "Group Policy Remote Update Firewall Ports" -Name "Client Firewall Off Preference" -Domain Adatum.com | New-GPLink -target "dc=adatum,dc=com" -Order 1 -Server LON-DC1.adatum.com -LinkEnabled Yes
Set-GPPrefRegistryValue -Name "Client Firewall Off Preference" -Action Update -Context Computer -Key "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" -ValueName EnableFirewall -Type DWord -Value 0
Set-GPPrefRegistryValue -Name "Client Firewall Off Preference" -Action Update -Context Computer -Key "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" -ValueName EnableFirewall -Type DWord -Value 0
Set-GPPrefRegistryValue -Name "Client Firewall Off Preference" -Action Update -Context Computer -Key "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" -ValueName EnableFirewall -Type DWord -Value 0

Write-Host "You need to restart the Client devices 2 times for the GPO to disable the firewalls"

