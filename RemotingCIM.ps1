#list WMI namespaces
    Get-WmiObject -Namespace root -List -Recurse | Select -Unique __NAMESPACE

#List classes in Root\CimV2
    Get-WmiObject -Namespace root\cimv2 -List | Sort Name
    Get-CimClass -Namespace root\CIMv2 | Sort CimClassName

#Qury an instance of a class
    Get-WmiObject  -Namespace root\CimV2 -Class Win32_LogicalDisk
    Get-CimInstance -ClassName Win32_LogicalDisk

    Get-CimInstance -ClassName Win32_OfflineFilesHealth

    Get-ciminstance -ClassName Win32_NetworkLoginProfile | select Caption,LastLogon

    Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"
    Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType = 3"

    Get-WmiObject -Query "SELECT * FROM Win32_LogicalDisk WHERE DriveType = 3"
    Get-CimInstance -Query "SELECT * FROM Win32_LogicalDisk WHERE DriveType = 3"

#Remote
     Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName LON-DC1 
#WMI Alternate Credential
     Get-WmiObject -ComputerName LON-DC1 -Credential ADATUM\Administrator -Class Win32_BIOS

#Create A sesion for remote
    $sess = New-CimSession -ComputerName LON-DC1
    Get-CimSession
#Send a CIM query to session
    Get-CimInstance -CimSession $sess -ClassName Win32_OperatingSystem
#Remove session
    Get-CimSession | Remove-CimSession
#One to many session
    $sess = New-CimSession -ComputerName LON-DC1,LON-CL1
    Get-CimInstance -CimSession $sess -ClassName Win32_OperatingSystem

    Get-CimSession | Remove-CimSession
#Modify Session with options

    $opt = New-CimSessionOption -Protocol Dcom 
    $sess = New-CimSession -ComputerName LON-DC1 -SessionOption $opt
    Get-CimInstance -ClassName Win32_BIOS -CimSession $sess

    Get-CimSession | Remove-Cimsession

#Discover Methods available for WMI
    Get-WmiObject -Class Win32_Service | Get-Member
#discover methods CIM is different
    Get-CimClass -Class Win32_Service | Select-Object -ExpandProperty CimClassMethods

#invoke method WMI
    Get-WmiObject -Class Win32_OperatingSystem | Invoke-WmiMethod -Name Win32Shutdown -Argument 0
 
    Invoke-WmiMethod -Class Win32_OperatingSystem -Name Win32Shutdown -Argument 0

#Cimmethod 
    Invoke-CimMethod -ComputerName LON-CL1 -Class Win32_Process -MethodName Create -Argument @{CommandLine='Notepad.exe'}
#and kill
    Get-CimInstance -ClassName Win32_Process -Filter "Name='notepad.exe'" -Computername LON-CL1 | Invoke-CimMethod -MethodName Terminate