#Task 1 Create an array and  foreach loops to display and multiply numbers
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

#Task 2 Create an array of files and a foreach loop to display file names in a list
#Create an array $files that contains the files in E:\Mod07\Labfiles
$files = Get-childitem E:\Mod07\Labfiles

#Write a foreach loop to display only the name property of each file
ForEach ($file in $files) {
    Write-Host $file.Name 
}


#Task 3 Create new OU an OU named Disabled Users
New-ADOrganizationalUnit -Name 'Disabled Users' -Path "DC=Adatum,DC=com"

#Task 4 Create PowerShell statements to retreive user names that start with the letter "A" and disable them.
# Write an additionalstatment to modify department property of Annie Conner to IT department

#Get users in Marketing OU whose name starts with the letter "A
Get-aduser -Filter { Name -like "A*" } -SearchBase "OU=Marketing,DC=Adatum,DC=com" 
#Disable those accounts
Get-aduser -Filter { Name -like "A*" } -SearchBase "OU=Marketing,DC=Adatum,DC=com" | Disable-ADAccount
#Find Annie Conner account and change her department to IT 
Get-Aduser -Filter { Name -eq "Annie Conner" } -Properties Department | Set-aduser -Department "IT"

#Task 5 Get Only Disabled users in Marketing OU whose Department is Marketing and NOT IT and populate an array $users.
#Create a foreach loop to display the user name property in a list.
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
#Task 6 Modify foreach loop to send name and department properties to csv file named disabled Marketing users with NoTypeInformation in header row

$users = Get-aduser -filter { Department -eq 'Marketing' -and Enabled -eq $false } -SearchBase "OU=Marketing,DC=Adatum,DC=com" -Properties Department

ForEach ($user in $users) {
    IF ($user.enabled -eq $False) 
    { $user | Select-object -Property Name, Department | export-csv C:\disableusers.csv -Append -NoTypeInformation }
}


#OR Create an PSOject and export

ForEach ($user in $users) {
    IF ($user.enabled -eq $False) {
        $properties = @{
            'Name'       = $user.Name;
            'Department' = $user.Department        
        }
        
        $obj = New-Object -TypeName PSObject -Property $properties
        $obj.PSObject.TypeNames.Insert(0, "DisabledUser")               #Gives the PSObject a type - view with Get-Member
        Write-Output $obj
        $obj | Select-Object -Property Name, Department | Export-Csv -Path C:\DisabledUsers.csv -NoTypeInformation -Append
    }
}


#Task 7  Modify foreach to Move disabled users to OU "Disabled Users".
ForEach ($user in $users) {
    IF ($user.enabled -eq $False) {
        $user | Move-ADObject -TargetPath "OU=Disabled Users,DC=Adatum,DC=com" 
    }
}
#Task 8 Move the users back to the Marketing OU for testing purposes.
Get-Aduser -filter * -searchbase "OU=Disabled Users,DC=Adatum,DC=com" | Move-ADObject -TargetPath "OU=Marketing,DC=Adatum,DC=com"

#Task 9 Modify foreach by adding  write-host statements to indicate each user that is getting moved during the loop
ForEach ($user in $users) {
    IF ($user.enabled -eq $False) {
        Write-Host "Moving " -NoNewline
        Write-Host $user.Name -NoNewline
        Write-Host " to Disabled Users OU"
        $user | Move-ADObject -TargetPath "OU=Disabled Users,DC=Adatum,DC=com" 
    }
}

#OR
$users = Get-aduser -filter { Department -eq 'Marketing' -and Enabled -eq $false } -SearchBase "OU=Marketing,DC=Adatum,DC=com" -Properties Department


ForEach ($user in $users) {
    IF ($user.enabled -eq $False) {
        Write-Host "Moving $($user.Name) to Disabled Users OU" 
        $user | Move-ADObject -TargetPath "OU=Disabled Users,DC=Adatum,DC=com" 
    }
}
