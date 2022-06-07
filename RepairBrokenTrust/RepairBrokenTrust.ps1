#Modify local TrustedHosts

#Set-Item WSMAN:\localhost\Client\TrustedHosts -Value <remote hostname>
#Get-Item WSMAN:\localhost\Client\TrustedHosts
#Clear-Item WSMAN:\localhost\Client\TrustedHosts

$DomainController = '<dc servername>'
$DomainCredential = '<admin username>'
$ComputerName = '<remote computer>'
$localcredential = '<localuseronremotecomputer>'
$password = ConvertTo-SecureString "<remoteuserpassword>" -AsPlainText -Force
#Create user credential object minimizing prompt
$pscred1 = New-object System.Management.Automation.PSCredential -ArgumentList ($localcredential, $password)

#Parameter block / hash table to pass arguments to remote PS command Test-ComputerSecureChannel
$testcomputersecurechannelParams = @{
    'Server'     = $DomainController
    'Credential' = $DomainCredential
    'Repair'     = $true
    'Verbose'    = $true
}
Invoke-Command -ComputerName $Computername -Credential $pscred1 -ScriptBlock { Test-ComputerSecureChannel @using:testcomputersecurechannelParams }