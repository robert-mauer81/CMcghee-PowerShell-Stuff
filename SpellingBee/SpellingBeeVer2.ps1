# Kanban Board created in GitKrakenfollow
# edits added by Robert-Mauer81 

# Load function "new-speech" for audible
Import-Module -Name CoreTools -force

# Ask user for input
new-speech "Hello, what is your name?" 
$name = Read-Host  "type your name here"
Write-Output "Nice to meet you $name, let's spell some words together!"
New-speech "nice to meet you $name, let'spell some words together!"

#Curious to hear this work I will create an aray instead for $list and test it out. It works with the array 
#$list = Get-Content -Path D:\Deleteme\beewords.txt
$list = @("the","cat","run","good","bad")

#For Each loop
foreach ($word in $list) {
   

    new-speech "please spell $word"
    $userinput = Read-host -Prompt "Type the spelling of the word $word here"
        IF($word -match $userinput ){
        New-speech "correct"
        Write-host "Correct!"}
         ELSE{Write-Host "Try Again!"
         New-Speech "Try Again"}
} 
#worked it out for the array, more work can be done to make it run randomely, make multipule difficulty levels, or to make it, one incorrect answer prompt the user again. 
#Replace the above IF...ELSE logic with a DO...UNTIL Loop I think may work to prompt until the $userinput is spelled correctly
#lesson 2 Module 8