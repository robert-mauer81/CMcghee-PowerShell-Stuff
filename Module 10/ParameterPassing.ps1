#Param Passing to Remote
#nope

$logname = 'system'
$newest = 5
Invoke-Command -ComputerName LON-DC1 -ScriptBlock{Get-eventlog -logname $logname -Newest $newest}

#yep
$logname = 'system'
$newest = 5
Invoke-Command -ComputerName LON-DC1 -ScriptBlock{Param($A,$B) Get-eventlog -logname $A -Newest $B} -ArgumentList $logname,$newest

#Works however
    $logname = 'System'
    Invoke-Command -ComputerName LON-DC1 -ScriptBlock {Get-Eventlog -logname -newest $Using:logname}



#No Bueno with more than one param
    $logname = 'System'
    $newest = 5
    Invoke-Command -ComputerName LON-DC1 -ScriptBlock {Get-Eventlog -LogName $Using:logname, $using:newest}

#This instead


$Inputs = @{
            'Logname' = 'System'
            'newest' = 5
            }    
    Invoke-Command -ComputerName LON-DC1,LON-SVR1 -ScriptBlock {Get-Eventlog  @Using:inputs} 