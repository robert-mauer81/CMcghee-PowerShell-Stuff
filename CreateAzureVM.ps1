$cred = Get-Credential
[string]$MyVM = TestVM1
[string]$RGName = VMRG0829
[string]$Location = EastUs

#Create Resource Group for VM
New-AzResourceGroup -ResourceGroupName $RGName -Location $location

$vmParams = @{
    ResourceGroupName = $RGName
    Name = $MyVm
    Location = $Location
    ImageName = 'Win2016Datacenter'
    PublicIpAddressName = 'TestPublicIp'
    Credential = $cred
    OpenPorts = 3389
   }

   #create the VM
   New-AzVM @vmParams
#Connect to VM
   Get-AzPublicIpAddress -ResourceGroupName $RGName | Select-Object IpAddress
   mstsc /v:<publicIpAddress>

   #Change size
   Get-AzVMSize -Location $Location
   Get-AzVMSize -ResourceGroupName $RGName -VMName $MyVM

   $vm = Get-AzVM -ResourceGroupName $RGName -VMName $MyVM
$vm.HardwareProfile.VmSize = "Standard_DS3_v2"
Update-AzVM -VM $vm -ResourceGroupName $RGName

#Start-Stop VM
Stop-AzVM -ResourceGroupName $RGName -Name $MyVM -Force
Start-AzVM -ResourceGroupName $RGName -Name $MyVm
#Remove RG
Remove-AzResourceGroup -Name $RGName -Force

