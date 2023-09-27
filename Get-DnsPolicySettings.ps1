##########################################################################################################################################
#### Script:      Get-DNSPolSettings.ps1                                      
                                                
#### Description: This script will pull a config report of all DNS policies configured 

###########################################################################################################################################
# Global Variables #
$Date = Get-Date -Format dd-MM-yyyy
$DNSServers = Import-Csv "PATHTOFILE\DNSServers.csv"
# Cycle through each DNS Server to pull the Query Resolution Policy information #
ForEach($Server in $DNSServers){
    # Put the Query Resolution Policy into a variable #
    $QueryResolutionPolicies = Get-DnsServerQueryResolutionPolicy -ZoneName "contoso.com" -ComputerName $Server.DNSServer | Select-Object *
    # Cycle through each policy to pull relevant information #
    ForEach ($Policy in $QueryResolutionPolicies){
        # Expands the Criteria property which includes Client Subnet and Query Filter information #
        $Criteria = Get-DnsServerQueryResolutionPolicy -ZoneName "contoso.com" -Name $Policy.Name -ComputerName $Server.DNSServer | Select-Object -ExpandProperty Criteria
        # Expands the Content property which includes the ZoneScope information #
        $Content = Get-DnsServerQueryResolutionPolicy -ZoneName "contoso.com" -Name $Policy.Name -ComputerName $Server.DNSServer | Select-Object -ExpandProperty Content
        # Puts the ZoneScope information in to a friendly named variable #
        $ZoneScope = $Content.ScopeName
        # Puts the ZoneName information in to a friendly named variabe #
        $ZoneName = $Policy.ZoneName
        # Gathers Zone Delegation information for the ZoneScope into a variable #
        $ZoneDelegation = Get-DnsServerZoneDelegation -ZoneScope $ZoneScope -Name $ZoneName -ChildZoneName "gslb" -ComputerName $Server.DNSServer
        # Puts the Client Subnet information in to a friendly named variable #
        $ClientSubnet = ($Criteria.Criteria[0]).Trim("EQ,")
        # Pulls the Client Subnet Object into a variable #
        $ClientSubnetObj = Get-DnsServerClientSubnet -Name $ClientSubnet -ComputerName $Server.DNSServer
        # Cycles through each subnet inside the Client Subnet onject and creates a list under the $Subnets variable #
        ForEach($Subnet in $ClientSubnetObj){
            $Subnets = (@($Subnet.IPV4Subnet) -join ", ")
        }
        # Puts the Query Resolution Policy Name property in to a friendly named variable #
        $PolName = $Policy.Name
        # Puts the Query Resolution Policy Action property in to a friendly named variable #
        $Action = $Policy.Action
        # Puts the Query Resolution Policy IsEnabled property in to a friendly named variable #
        $isEnabled = $Policy.IsEnabled
        # Puts the Query Filder information in to a friendly named variable #
        $Filter = ($Criteria.Criteria[1]).Trim("EQ,")
        # Puts the Query Resolution Policy ProcessingOrder property in to a friendly named variable #
        $ProcOrder = $Policy.ProcessingOrder
        # Puts the ChildZoneName property from $ZoneDelegation variable in to a friendly named variable #
        $ChildZoneName = $ZoneDelegation.ChildZoneName[0]
        # Expands the hidden properties of the resource records inside the ZoneScope for the Name Server and the Name Server IP information #
        $RecordData = Get-DnsServerResourceRecord -ZoneName "contoso.com" -ZoneScope $ZoneScope -ComputerName $Server.DNSServer | Where-Object {$_.HostName -ne "@" -and $_.HostName -like "*.gslb"} | Select-Object HostName,RecordType,@{label="IPv4Address";Expression={$_.RecordData | Select-Object -ExpandProperty ipv4address}},@{Label="HostNameAlias";Expression={$_.RecordData | Select-Object -ExpandProperty HostNameAlias}},@{Label="NameServer";Expression={$_.RecordData | Select-Object -ExpandProperty NameServer}}
        $NS1 = ($RecordData.HostName[0]+".contoso.com")
        $NS2 = ($RecordData.HostName[1]+".contoso.com")
        $IP1 = ($RecordData.IPv4Address[0].IPAddressToString)
        $IP2 = ($RecordData.IPv4Address[1].IPAddressToString)
        # Puts the Name Server gathered from the $RecordData variable in to a friendly named variable #
        $NameServers = $NS1+", "+$NS2
        # Puts the Name Server IP gathererd from the $RecordData variable in to a friendly named variable #
        $NameServerIPs = $IP1+", "+$IP2
        # Creates a custom report object #
        $Report = New-Object PSObject
        $Report | Add-Member -MemberType NoteProperty -Name "DNSServer" -Value $Server.DNSServer # Adds the DNS Server from which the information was gathered from #
        $Report | Add-Member -MemberType NoteProperty -Name "PolicyName" -Value $PolName # Add the Query Resolution Policy Name to the report #
        $Report | Add-Member -MemberType NoteProperty -Name "ZoneName" -Value $ZoneName # Adds the Zone Name referenced in the Query Resolution Policy to the report #
        $Report | Add-Member -MemberType NoteProperty -Name "ZoneScope" -Value $ZoneScope # Adds the ZoneScope referenced in the Query Resolution Policy to the report #
        $Report | Add-Member -MemberType NoteProperty -Name "QueryFilter" -Value $Filter # Adds the Query Filter referenced in the Query Resolution Policy to the report #
        $Report | Add-Member -MemberType NoteProperty -Name "Action" -Value $Action # Adds the Action value referenced in the Query Resolution Policy to the report #
        $Report | Add-Member -MemberType NoteProperty -Name "ClientSubnetName" -Value $ClientSubnet # Adds the Client Subnet name referenced in the Query Resolution Property to the report #
        $Report | Add-Member -MemberType NoteProperty -Name "IPv4Subnets" -Value $Subnets # Adds the list of Subnets created from the $ClientSubnetObj variable to the report #
        $Report | Add-Member -MemberType NoteProperty -Name "DelegatedZone" -Value $ChildZoneName # Adds the Delegated Zone information gathered from the $ZoneDelegation variable to the report #
        $Report | Add-Member -MemberType NoteProperty -Name "NameServer(s)" -Value $NameServers # Adds the Name Server gathered from the $RecordData variable to the report #
        $Report | Add-Member -MemberType NoteProperty -Name "NameServerIP" -Value $NameServerIPs # Adds the Name Server IP Address gathererd from the $RecordData variable to the report #
        $Report | Add-Member -MemberType NoteProperty -Name "IsEnabled" -Value $isEnabled # Adds the IsEnabled property referenced in the Query Resolution Policy to the report #
        $Report | Add-Member -MemberType NoteProperty -Name "ProcessingOrder" -Value $ProcOrder # Adds the ProcessingOrder property referenced in the Query Resolution Policy to the report #
        # Exports the CSV report for any and all Query Resolution Policies detected for the internal.cliffordchance.net zone #
        $Report | Export-Csv -Append -NoTypeInformation "PATHTOFILE\DNSPolicyConfigReport_$Date.csv"
    }
}
# Configure E-Mail Settings #
$Recipient = "Christian"
$CC = 
$Sender = "DNSPolicyAlerts@contoso.com"
$SMTP = "exch001.contoso.com"
$Subject = "Daily DNS Policy Config Report for $Date"
$Attachment = "PATHTOFILE\DNSPolicyConfigReport_$Date.csv"
$Body = 
('To Administrator,
 
Attached, please find the DNS Policy Config Report for '+$Date+'. This report contains the DNS policy settings for the Query Resolution Policies that were detected.
 
PLEASE DO NOT REPLY TO THIS EMAIL.
 
Regards,
EUC Engineering')
Send-MailMessage -To christian.mcghee@unitedtraining.com -From $Sender -Subject $Subject -Body $Body -Attachments $Attachment -SmtpServer $SMTP
# Reset ErrorActionPreference #
$ErrorActionPreference = $oldErrorActionPreference
# END #
