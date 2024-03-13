#Chris Mcghee chrs.mcghee@gmail.com 3-27-2020
#test Fork
#Lets get on board


#Store the data from ADUsers.csv in the $ADUsers array
TRY {
    $ADUsers = Import-csv D:\Bulkusers\bulk_users1.csv 
}
CATCH [System.IO.DirectoryNotFoundException] {
    Write-Host " You fat fingered the directory"
}
CATCH [System.IO.FileNotFoundException] {
    Write-Host " The filename is wrong you Mollusk"
}


#$error[1].Exception.GetType().FullName



#Loop through each row containing user details in the CSV file 
foreach ($User in $ADUsers) {
    #Read user data from each field in each row and assign the data to a variable as below
    [string]$DisplayName = $user.firstname + " " + $User.Lastname
    [string]$UPN = $User.Firstname + "." + $User.Lastname + "@" + $User.Maildomain	
    [string]$Username = $User.username
    [string]$Password = $User.password
    [string]$Firstname = $User.firstname
    [string]$Lastname = $User.lastname
    [string]$OU = $User.ou
    [string]$email = $User.email
    [string]$streetaddress = $User.streetaddress
    [string]$city = $User.city
    [string]$zipcode = $User.zipcode
    [string]$state = $User.state
    [string]$country = $User.countrycode
    [string]$telephone = $User.telephone
    [string]$jobtitle = $User.jobtitle
    [string]$company = $User.company
    [string]$department = $User.department
   

    #Check to see if the user already exists in AD
    if (Get-ADUser -Filter { SamAccountName -eq $Username }) {
        #If user does exist, give a warning and keep on going
        Write-Warning "A user account with username $Username already exist in Active Directory."
    }
    else {
        #User does not exist then proceed to create the new user account
		
        #Account will be created in the OU provided by the $OU variable read from the CSV file
        New-ADUser -Name:$DisplayName  -SamAccountName:$Username -UserPrincipalName:$UPN -GivenName:$Firstname -Surname:$Lastname -Enabled:$True -DisplayName:$DisplayName  -Path:$OU -City:$city -Company:$company -PostalCode:$zipcode -Country:$country -State $state -StreetAddress $streetaddress -OfficePhone $telephone  -EmailAddress:$email -Title:$jobtitle  -Department:$department -AccountPassword:(convertto-securestring $Password -AsPlainText -Force) -ChangePasswordAtLogon:$True            
    }
        
} 
