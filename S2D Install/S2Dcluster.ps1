
#https://learn.microsoft.com/en-us/windows-server/storage/storage-spaces/deploy-storage-spaces-direct

# Fill in these variables with your values
$ServerList = "Server01", "Server02", "Server03", "Server04"
$ClusterName = "S2DCluster"
#Install Roles
Install-WindowsFeature -ComputerName $ServerList  -Name "Hyper-V", "Failover-Clustering", "Data-Center-Bridging", "RSAT-Clustering-PowerShell", "Hyper-V-PowerShell", "FS-FileServer"

# Install Features - Admin Tools
$ServerList = $ServerList
$FeatureList = "Hyper-V", "Failover-Clustering", "Data-Center-Bridging", "RSAT-Clustering-PowerShell", "Hyper-V-PowerShell", "FS-FileServer"
Invoke-Command ($ServerList) {
    Install-WindowsFeature -Name $Using:Featurelist
}
#Create Cluster
New-Cluster -Name $ClusterName -Node $serverlist -NoStorage -staticipaddress 172.16.0.55

# CLean disk -NOTE WELL!! This will delete everything except the OS drive! Move any Data that needs moving first

Invoke-Command ($ServerList) {
    Update-StorageProviderCache
    Get-StoragePool | ? IsPrimordial -eq $false | Set-StoragePool -IsReadOnly:$false -ErrorAction SilentlyContinue
    Get-StoragePool | ? IsPrimordial -eq $false | Get-VirtualDisk | Remove-VirtualDisk -Confirm:$false -ErrorAction SilentlyContinue
    Get-StoragePool | ? IsPrimordial -eq $false | Remove-StoragePool -Confirm:$false -ErrorAction SilentlyContinue
    Get-PhysicalDisk | Reset-PhysicalDisk -ErrorAction SilentlyContinue
    Get-Disk | ? Number -ne $null | ? IsBoot -ne $true | ? IsSystem -ne $true | ? PartitionStyle -ne RAW | % {
        $_ | Set-Disk -isoffline:$false
        $_ | Set-Disk -isreadonly:$false
        $_ | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false
        $_ | Set-Disk -isreadonly:$true
        $_ | Set-Disk -isoffline:$true
    }
    Get-Disk | Where-Object Number -Ne $Null | Where IsBoot -Ne $True | Where-Object IsSystem -Ne $True | Where PartitionStyle -Eq RAW | Group -NoElement -Property FriendlyName
} | Sort-Object -Property PsComputerName, Count

#Install Roles
Install-WindowsFeature -ComputerName $ServerList  -Name "Hyper-V", "Failover-Clustering", "Data-Center-Bridging", "RSAT-Clustering-PowerShell", "Hyper-V-PowerShell", "FS-FileServer"

# Install Features - Admin Tools
$ServerList = $ServerList
$FeatureList = "Hyper-V", "Failover-Clustering", "Data-Center-Bridging", "RSAT-Clustering-PowerShell", "Hyper-V-PowerShell", "FS-FileServer"
Invoke-Command ($ServerList) {
    Install-WindowsFeature -Name $Using:Featurelist
}

#Configure a file share witness then enable S2D
#Enable-ClusterStorageSpacesDirect -PoolFriendlyName 'S2DPool'