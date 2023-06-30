<#
.SYNOPSIS
Get-Aduser -filter* -properties *| Get-member does not return every possible attribute of an ADuser object. You need to take parent classes and supplemental classes into account.
Plus you need to look at four different class attributes for each class definition associated with the class.
.DESCRIPTION
This command will retrieve all possible ADUser properties
.LINK
https://www.easy365manager.com/how-to-get-all-active-directory-user-object-attributes/
#>
Import-Module ActiveDirectory
$Loop = $True
$ClassName = "User"
$ClassArray = [System.Collections.ArrayList]@()
$UserAttributes = [System.Collections.ArrayList]@()
# Retrieve the User class and any parent classes
While ($Loop) {
    $Class = Get-ADObject -SearchBase (Get-ADRootDSE).SchemaNamingContext -Filter { ldapDisplayName -Like $ClassName } -Properties AuxiliaryClass, SystemAuxiliaryClass, mayContain, mustContain, systemMayContain, systemMustContain, subClassOf, ldapDisplayName
    If ($Class.ldapDisplayName -eq $Class.subClassOf) {
        $Loop = $False
    }
    $ClassArray.Add($Class)
    $ClassName = $Class.subClassOf
}
# Loop through all the classes and get all auxiliary class attributes and direct attributes
$ClassArray | ForEach-Object {
    # Get Auxiliary class attributes
    $Aux = $_.AuxiliaryClass | Where-Object { Get-ADObject -SearchBase (Get-ADRootDSE).SchemaNamingContext -Filter { ldapDisplayName -like $_ } -Properties mayContain, mustContain, systemMayContain, systemMustContain } |
    Select-Object @{n = "Attributes"; e = { $_.mayContain + $_.mustContain + $_.systemMaycontain + $_.systemMustContain } } |
    Select-Object -ExpandProperty Attributes
    # Get SystemAuxiliary class attributes
    $SysAux = $_.SystemAuxiliaryClass | Where-Object { Get-ADObject -SearchBase (Get-ADRootDSE).SchemaNamingContext -Filter { ldapDisplayName -like $_ } -Properties MayContain, SystemMayContain, systemMustContain } |
    Select-Object @{n = "Attributes"; e = { $_.maycontain + $_.systemmaycontain + $_.systemMustContain } } |
    Select-Object -ExpandProperty Attributes
    # Get direct attributes
    $UserAttributes += $Aux + $SysAux + $_.mayContain + $_.mustContain + $_.systemMayContain + $_.systemMustContain
}
$UserAttributes | Sort-Object | Get-Unique 