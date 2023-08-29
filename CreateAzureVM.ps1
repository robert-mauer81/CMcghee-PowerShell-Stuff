$cred = Get-Credential
$MyVM = TestVM1
$RGName = VMRG0829

#Create Resource Group for VM
New-AzResourceGroup -ResourceGroupName $RGName -Location "EastUs"

$vmParams = @{
    ResourceGroupName = 'myResourceGroup'
    Name = $MyVm
    Location = 'eastus'
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
   Get-AzVMSize -Location "EastUS"
   Get-AzVMSize -ResourceGroupName $RGName -VMName $MyVM

   $vm = Get-AzVM -ResourceGroupName $RGName -VMName $MyVM
$vm.HardwareProfile.VmSize = "Standard_DS3_v2"
Update-AzVM -VM $vm -ResourceGroupName $RGName

#Start-Stop VM
Stop-AzVM -ResourceGroupName $RGName -Name $MyVM -Force
Start-AzVM -ResourceGroupName $RGName -Name $MyVm
#Remove RG
Remove-AzResourceGroup -Name $RGName -Force

