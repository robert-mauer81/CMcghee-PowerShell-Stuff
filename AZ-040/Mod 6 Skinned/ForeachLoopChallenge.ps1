#Task 1
#Create an array $numbers and use write-host to display each number in the loop
$numbers = 1, 2, 3, 4, 5, 6

ForEach ($num in $numbers) {
    Write-Host $num
}
#Modify the loop to multiply each number by 6
$numbers = 1, 2, 3, 4, 5, 6
ForEach ($num in $numbers) {
    Write-Host ($num * 6)
}

#Task 2
#Create an array $files that contains the files in E:\Mod07\Labfiles
$files = Get-childitem E:\Mod07\Labfiles

#Write a foreach loop to display only the name property of each file
ForEach ($file in $files) {
    Write-Host $file.Name 
}


#Task 3
#Create new OU
New-ADOrganizationalUnit -Name 'Disabled Users' -Path "DC=Adatum,DC=com"

#Task 4
#Get users in Marketing OU whose name starts with the letter "A
Get-aduser -Filter { Name -like "A*" } -SearchBase "OU=Marketing,DC=Adatum,DC=com" 
#Disable those accounts
Get-aduser -Filter { Name -like "A*" } -SearchBase "OU=Marketing,DC=Adatum,DC=com" | Disable-ADAccount
#Find Annie Conner account and change her department to IT 
Get-Aduser -Filter { Name -eq "Annie Conner" } -Properties Department | Set-aduser -Department "IT"

#Task 5
#Get Only Disabled users in Marketing OU whose Department is Marketing NOT IT
Get-aduser -filter { Department -eq 'Marketing' } -SearchBase "OU=Marketing,DC=Adatum,DC=com" -Properties enabled | Where -FilterScript { $_.enabled -eq $False }
#OR
Get-aduser -filter { Department -eq 'Marketing' -and Enabled -eq $false } -SearchBase "OU=Marketing,DC=Adatum,DC=com" -Properties Department

#Create an array $users using code above

$users = Get-aduser -filter { Department -eq 'Marketing' -and Enabled -eq $false } -SearchBase "OU=Marketing,DC=Adatum,DC=com" 

#Write foreach loop to display a list of only the user Name property of the disabled users
ForEach ($user in $users) {
    IF ($user.enabled -eq $False) 
    { Write-host $user.Name }
}
#Task 6
#Modify foreach loop to send name and department properties to csv file named disabled Marketing users with NoTypeInformation in header row

$users = Get-aduser -filter { Department -eq 'Marketing' -and Enabled -eq $false } -SearchBase "OU=Marketing,DC=Adatum,DC=com" -Properties Department

ForEach ($user in $users) {
    IF ($user.enabled -eq $False) 
    { $user | Select-object -Property Name, Department | export-csv C:\disableusers.csv -Append -NoTypeInformation }
}

#Task 7
# Modify foreach to Move disabled users to OU "Disabled Users".
ForEach ($user in $users) {
    IF ($user.enabled -eq $False) {
        $user | Move-ADObject -TargetPath "OU=Disabled Users,DC=Adatum,DC=com" 
    }
}
#Task 8
Get-Aduser -filter * -searchbase "OU=Disabled Users,DC=Adatum,DC=com" | Move-ADObject -TargetPath "OU=Marketing,DC=Adatum,DC=com"

#Task 9
#Modify foreach by adding  write-host statements to indicate each user that is getting moved during the loop
ForEach ($user in $users) {
    IF ($user.enabled -eq $False) {
        Write-Host "Moving " -NoNewline
        Write-Host $user.Name -NoNewline
        Write-Host " to Disabled Users OU"
        $user | Move-ADObject -TargetPath "OU=Disabled Users,DC=Adatum,DC=com" 
    }
}

