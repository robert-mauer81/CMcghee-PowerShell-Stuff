# Kanban Board created in GitKraken

# Load function "new-speech" for audible
Import-Module -Name coretools  #it didn't work I need the coretools Module that was built for it.

# Ask user for input
new-speech "Hello, what is your name?" 
$name = Read-Host  
Write-Output "Nice to meet you $name, let's spell some words together!"
#to test, delete Start-Sleep later
Start-Sleep -Seconds 3
New-Speech -text "Spell the following Words Please $name"

#Get-Content -Path .\SampleWords.txt.

#do you have a file that I could use to create the spelling bee?  could you also create an array with in the script, so that it does not rely on an outside file.  
#Curious to hear this work I will create an aray instead for $list and test it out.  
#$list = Get-Content -Path D:\Deleteme\beewords.txt
$list = @("the","cat","run","good","bad")

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