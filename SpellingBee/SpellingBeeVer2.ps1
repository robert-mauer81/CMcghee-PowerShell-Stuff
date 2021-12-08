# Kanban Board created in GitKraken

# Load function "new-speech" for audible
Import-Module -Name coretools

# Ask user for input
new-speech "Hello, what is your name?" 
$name = Read-Host  
Write-Output "Nice to meet you $name, let's spell some words together!"
#to test, delete Start-Sleep later
Start-Sleep -Seconds 3
New-Speech -text "Spell the following Words Please $name"

#Get-Content -Path .\SampleWords.txt.

$list = Get-Content -Path D:\Deleteme\beewords.txt

#For Each loop
foreach ($word in $list) {
   
    new-speech $word
    $userinput = Read-host -Prompt "Type the spelling of the word here"
        IF($word -match $userinput ){
        Write-host "Correct!"}
         ELSE{Write-Host "Try Again!"}
} 

#Replace the above IF...ELSE logic with a DO...UNTIL Loop I think may work to prompt until the $userinput is spelled correctly
#lesson 2 Module 8