$computer = $env:COMPUTERNAME
$namespace = "ROOT\CIMV2"
$classname = "Win32_ComputerSystem"

Write-Output "====================================="
Write-Output "COMPUTER : $computer "
Write-Output "CLASS    : $classname "
Write-Output "====================================="

Get-CimInstance -Class $classname -ComputerName $computer -Namespace $namespace |
Select-Object * -ExcludeProperty PSComputerName, Scope, Path, Options, ClassPath, Properties, SystemProperties, Qualifiers, Site, Container |
Format-List -Property [a-z]*
