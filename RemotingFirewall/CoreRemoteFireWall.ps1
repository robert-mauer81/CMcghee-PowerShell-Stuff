Write-Host "Enter the name of the remote computer to enable PS Remoting  " -ForegroundColor Yellow -BackgroundColor DarkMagenta -NoNewline
$Computername = Read-Host 

$SessionArgs = @{
    ComputerName  = $computername
    Credential    = Get-Credential -UserName Adatum\Administrator -Message "Enter User Name"
    SessionOption = New-CimSessionOption -Protocol Wsman
}
$MethodArgs = @{
    ClassName  = 'Win32_Process'
    MethodName = 'Create'
    CimSession = New-CimSession @SessionArgs
    Arguments  = @{
        CommandLine = "powershell Start-Process powershell -ArgumentList 'Enable-PSRemoting -Force'"
    }
}
Invoke-CimMethod @MethodArgs

$Session = Get-CimSession

Enable-NetFirewallRule -DisplayName  "Windows Management Instrumentation (DCOM-In)" -CimSession $session 
Enable-NetFirewallRule -DisplayGroup "Remote Event Log Management" -CimSession $session 
Enable-NetFirewallRule -DisplayGroup "Remote Service Management" -CimSession $session 
Enable-NetFirewallRule -DisplayGroup "Remote Volume Management" -CimSession $session 
Enable-NetFirewallRule -DisplayGroup "Remote Scheduled Tasks Management" -CimSession $session 
Enable-NetFirewallRule -DisplayGroup "Windows Defender Firewall Remote Management" -CimSession $session -PassThru

Get-CimSession | Remove-CimSession


