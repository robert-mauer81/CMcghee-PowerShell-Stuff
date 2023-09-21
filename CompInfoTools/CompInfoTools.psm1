Function Get-Compinfo {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [String[]]$DnsHost
    )
                               
    PROCESS {
        FOREACH ($Computer in $DnsHost) {
        

            $os = Get-CimInstance -ClassName Win32_operatingsystem -ComputerName $Computer -ErrorAction SilentlyContinue

            #$now = (Get-Date)
            
            $uptime = $os.LocalDateTime - $os.LastBootUpTime 
        
            $cdrive = Get-WMIObject win32_logicaldisk -filter "DeviceID='c:'" -computername $Computer -ErrorAction SilentlyContinue

            $Properties = [ordered]@{'Computername' = $Computer;
                'OS'                                = $os.Caption;
                'LastBootUp'                        = $os.LastBootUpTime;
                'UpTimeHours'                       = $uptime;
                'C:_GB_Free'                        = ($cdrive.FreeSpace / 1GB -as [int])
            }


            $obj = New-Object -TypeName PSObject -Property $properties

            $obj.PSObject.TypeNames.Insert(0, "MyInventory")

            #$FormatEnumerationLimit = -1
            Write-Output $obj 
            $obj | Select-Object -Property computername, os, LastBootUp, UptimeHours, C:_GB_Free | Export-Csv -Path C:\Test.csv -NoTypeInformation -Append
        }

    }
}


Function Get-onlinecomputers {
    [cmdletBinding()]
    Param
    (
        [String[]]$Computers = (get-adcomputer -filter * | Select-object -expandProperty dnshostname) 
    )
    Foreach ($Computer in $Computers) {
        IF (Test-Connection -Computername $Computer -BufferSize 32 -Count 1 -Quiet) {
            $computer 
        }
    }
}

Function Get-onlinecomputersNetPing {
    [cmdletBinding()]
    Param(
        $Computers = (get-adcomputer -filter * | Select-object -ExpandProperty dnshostname)
    )
    $ping = (New-Object System.Net.NetworkInformation.Ping)

    Foreach ($Computer in $Computers) {
        if ($ping.Send($Computer) | Where-Object -FilterScript { $_.Status -eq 'Success' }) {
            $computer
        }
    }

}