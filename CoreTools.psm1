function Set-CorpComputerState {
    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = "High")]
    param(
        [Parameter(Mandatory = $True,
            HelpMessage = 'Computer name to set state for',
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [Alias('hostname')]
        [string[]]$ComputerName,

        [Parameter(Mandatory = $True,
            HelpMessage = 'Action to take: PowerOff, Shutdown, Restart, or Logoff')]
        [ValidateSet('PowerOff', 'Shutdown', 'Restart', 'Logoff')]
        [string]$State,

        [switch]$force
    )
    BEGIN {
        switch ($state) {
            'LogOff' { $_action = 0 }
            'ShutDown' { $_action = 1 }
            'Restart' { $_action = 2 }
            'PowerOff' { $_action = 8 }
        }
        if ($force) { $_action += 4 }
        Write-Verbose "Action value is $_action"
    }
    PROCESS {
        foreach ($computer in $computername) {
            if ($PSCmdlet.ShouldProcess("$computer - action is $_action")) {
                Write-Verbose "Contacting $computer"
                $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer -EnableAllPrivileges
                $return = $os.win32shutdown($_action)
                Write-Verbose "Return value from $computer is $($return.returnvalue)"
            }
        }
    }
}
#This is an edit from the web
Function Get-AdatumOSInfo {
    <#
.SYNOPSIS
Retreives operating system, BIOS, and computer information from one or
more computers.
.DESCRIPTION
This command retrieves specific information from each computer. The
command uses CIM, so it will only work with computers where Windows
Remote Management (WinRM) has been enabled and Windows Management
Framework (WMF) 3.0 or later is installed.
.PARAMETER ComputerName
One or more computer names, as strings. IP addresses are not accepted.
You should only use canonical names from Active Directory. This
parameter accepts pipeline input. Computer names must be in the form
LON-XXYY, where "XX" can be a 2- or 3-character designation, and 
"YY" can be 1 or 2 digits.
.EXAMPLE
 Get-Content names.txt | Get-AdatumOSInfo
This example assumes that names.txt includes one computer name per
line, and will retrieve information from each computer listed.
.EXAMPLE
 Get-AdatumOSInfo -ComputerName LON-DC1
This example retrieves information from one computer.
#>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = 'One or more computer names')]
        [Alias('HostName')]
        [ValidatePattern('LON-\w{2,3}\d{1,2}')]
        [string[]]$ComputerName
    )

    PROCESS {
        foreach ($computer in $ComputerName) {
            Write-Verbose "Connecting to $computer"
            $os = Get-CimInstance -ComputerName $computer -ClassName Win32_OperatingSystem
            $compsys = Get-CimInstance -ComputerName $computer -ClassName Win32_ComputerSystem
            $bios = Get-CimInstance -ComputerName $computer -ClassName Win32_BIOS

            $properties = @{'ComputerName' = $computer;
                'OSVersion'                = $os.caption;
                'SPVersion'                = $os.servicepackmajorversion;
                'BIOSSerial'               = $bios.serialnumber;
                'Manufacturer'             = $compsys.manufacturer;
                'Model'                    = $compsys.model
            }
            $output = New-Object -TypeName PSObject -Property $properties
            Write-Output $output
        }
    }

}

Function Set-AdatumServicePassword {
    <#
.SYNOPSIS
Sets the logon password for a service on one or more computers.
.DESCRIPTION
This command sets the logon password for a service. The
command uses CIM, so it will only work with computers where Windows
Remote Management (WinRM) has been enabled and Windows Management
Framework (WMF) 3.0 or later is installed.
.PARAMETER ComputerName
One or more computer names, as strings. IP addresses are not accepted.
You should only use canonical names from Active Directory. This
parameter accepts pipeline input. Computer names must be in the form
LON-XXYY, where "XX" can be a 2- or 3-character designation, and 
"YY" can be 1 or 2 digits.
.EXAMPLE
 Get-Content names.txt | Set-AdatumServicePassword -ServiceName "BITS" -NewPassword "Pa$$w0rd"
This example assumes that names.txt includes one computer name per
line, and will set the password for the BITS server on each computer listed.
#>
    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'Medium')]
    Param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = 'One or more computer names')]
        [Alias('HostName')]
        [ValidatePattern('LON-\w{2,3}\d{1,2}')]
        [string[]]$ComputerName,

        [Parameter(Mandatory = $True,
            HelpMessage = 'Name of service to set')]
        [string]$ServiceName,

        [Parameter(Mandatory = $True,
            HelpMessage = 'New password')]
        [string]$NewPassword
    )

    PROCESS {
        foreach ($computer in $ComputerName) {
            Write-Verbose "Retrieving $servicename from $computer"
            $service = Get-CimInstance -ClassName Win32_Service -ComputerName $computer -Filter "Name='$servicename'"

            if ($PSCmdlet.ShouldProcess("for $service on $computer")) {
                Write-Verbose "Setting password for $service on $computer"
                $result = $service | Invoke-CimMethod -MethodName Change -Arguments @{'StartPassword' = $NewPassword }
            }

            if ($result -ne 0) {
                Write-Warning "Failed to set password for $service on $computer"
            }

        }
    }
}

function Get-AdatumStyleSheet {
    [CmdletBinding()]
    Param()
    @"
<style>
body {
    font-family:Segoe,Tahoma,Arial,Helvetica;
    font-size:10pt;
    color:#333;
    background-color:#eee;
    margin:10px;
}
th {
    font-weight:bold;
    color:white;
    background-color:#333;
}
</style>
"@
}

function Get-AdatumNetAdapterInfo {
    <#
.SYNOPSIS
Retrieves network adapter and IP address information.
.DESCRIPTION
This command combines information about each network adapter
and all IP addresses bound to it. This uses CIM, so target computers
must have WMF 3.0 or later installed, and WinRM must be enabled.
.PARAMETER ComputerName
One or more computer name. IP addresses are not acceptable. This
parameter does not accept pipeline input.
.EXAMPLE
Get-AdatumNetAdapterInfo -ComputerName LON-DC1,LON-SVR1
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [string[]]$ComputerName
    )
    
    foreach ($computer in $computername) {

        Write-Verbose "Connecting to $computer"
        $session = New-CimSession -ComputerName $computer

        $adapters = Get-NetAdapter -CimSession $session
        foreach ($adapter in $adapters) {
            
            $addresses = Get-NetIPAddress -InterfaceIndex ($adapter.InterfaceIndex) -CimSession $session
            foreach ($address in $addresses) {

                $properties = @{'ComputerName' = $computer;
                    'AdapterName'              = $adapter.Name;
                    'InterfaceIndex'           = $adapter.InterfaceIndex;
                    'IPAddress'                = $address.IPAddress;
                    'AddressFamily'            = $address.AddressFamily
                }
                $output = new-object -TypeName PSObject -Property $properties
                Write-Output $output

            } # addresses
        } # adapeters
    } # computers

    Write-Verbose "Closing session to $computer"
    $session | Remove-CimSession

} # function

function Get-AdatumDiskInfo {
    <#
.SYNOPSIS
Retrieves disk and disk capacity information.
.DESCRIPTION
This command combines information about each fixed disk
including capacity. This uses CIM, so target computers
must have WMF 3.0 or later installed, and WinRM must be enabled.
.PARAMETER ComputerName
One or more computer name. IP addresses are not acceptable. This
parameter does not accept pipeline input.
.EXAMPLE
Get-AdatumDiskInfo -ComputerName LON-DC1,LON-SVR1
#>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [string[]]$computername
    )
    PROCESS {
        foreach ($computer in $computername) {

            $disks = Get-CimInstance -ComputerName $computer -ClassName Win32_LogicalDisk -Filter "DriveType=3"
            foreach ($disk in $disks) {
                $properties = @{'ComputerName' = $computer;
                    'DriveLetter'              = $disk.deviceid;
                    'FreeSpace'                = $disk.freespace;
                    'Size'                     = $disk.size
                }
                $output = New-Object -TypeName PSObject -Property $properties
                Write-Output $output

            } #dsisk
        } #computers
    } #process
} #function