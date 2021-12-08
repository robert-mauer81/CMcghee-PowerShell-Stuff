# Kanban Board created in GitKraken

# Load function "new-speech" for audible
Import-Module -Name coretools

# Ask user for input
new-speech "Hello, what is your name?" 
$name = Read-Host "Hello, what is your name?" 
Write-Output "Nice to meet you $name, let's spell some words together!"
#to test, delete Start-Sleep later
Start-Sleep -Seconds 5


Get-Content -Path .\SampleWords.txt.

$list = Get-Content -Path .\SampleWords.txt

#For Each loop
foreach ($word in $list) {
   
    new-speech $word
    Read-host -Prompt "Spell"

    #if -eq $true | Write-host "Correct!"
    #if -eq $false| Write-Host "Try Again!"
} 

($list).ForEach({


    }
)