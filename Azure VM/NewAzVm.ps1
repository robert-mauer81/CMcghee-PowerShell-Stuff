
Connect-AzAccount 

$cred = Get-Credential

$vmParams = @{
    ResourceGroupName = '2016Servers'
    Name = 'TestVM'
    Location = 'South Central US'
    ImageName = 'Win2016Datacenter'
    PublicIpAddressName = 'TestVMPublicIp'
    Credential = $cred
    OpenPorts = 3389
    PublicIpSku = 'Standard'
   }

   New-AzVM @vmParams