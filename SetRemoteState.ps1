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