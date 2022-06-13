function Get-LoggedOnUser{
     [CmdletBinding()]
          [Alias()]
          Param
          (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({Test-Connection -ComputerName $_ -Quiet -Count 1})]
        [ValidateNotNullOrEmpty()]
        [string[]]$ComputerName 
           )
Try{
  ForEach($computer in $ComputerName){
     $output = @{
     'ComputerName' = $computer;     }#OutputHashTable
     $output.UserName = (Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computer -ErrorAction Stop).Username    
     [PSCustomObject]$output
     }
  }
Catch{
    Write-host 'You must enter a valid computername'
     }
  }

#New Function
function Export-LoggedOnUser{
    [CmdletBinding()]
    [Alias()]
   Param(
        [Parameter(Mandatory=$True)]
        [string]$Path,
        [Parameter(Mandatory=$True)]
        [string[]]$ComputerName
         )
    try{
     $loggedonuser = Get-LoggedOnUser -ComputerName $ComputerName -ErrorAction stop 
     
       }
    catch{
         Write-Host "You need to provide a Computername"
        }
    Try{
     $loggedonuser | Export-Csv -Path $Path -NoTypeInformation -ErrorAction Stop
     }
    Catch{
     Write-Host 'You must enter a valid path'
     } 
 }