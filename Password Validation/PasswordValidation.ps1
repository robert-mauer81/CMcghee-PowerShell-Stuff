
#Emilys code
# Check to make sure password meets requirements 

Function Validate-Password {
    Param ( [string]$Password ) 

    #check if password has at lwast 12 characters 
    If ($Password.length -lt 12) {
        Write-host "Password must have at least 12 characters! Yours has $($Password.Length) characters."
        return $false
    }
    #check if password has at least one uppercase letter
    If (-not $Password -match 'A-Z') {
        Write-host "Password must contain at least one uppercase letter!"
        return $false
    }
    #check if password has at least one special character
    If ($Password -notmatch '[!@#$%^&*]') {
        Write-host "Password must contain at least one special character!"
        return $false
    }
    #check if password has at least one number
    If ($Password -notmatch '[0-9]') {
        Write-host "Password must contain at least one number!"
        return $false
    }
    Else 
    { Return $true }
}
#Checks that all password requirements have been met and nofify user that password has been validated
while ($true) {
    $Password = Read-Host "Create a password. It should be at least 12 characters in length, at least 1 special character, at least 1 uppercase letter, and 2 numbers."
    IF (ValidatePassword -Password $Password) {
        Clear-host
        Write-Host "Your Password has been validated!"
        break
    }
}
   