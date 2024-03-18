3Test this you Mollusk!!
function Set-CorpComputerState {
    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = "High")]
    param(
        [Parameter(Mandatory = $True,
            HelpMessage = 'Computer name to set state for',
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True)]
        [Alias('hostname')]
        [string[]]$ComputerName,

        [Parameter(Mandatory = $True,
            HelpMessage = 'Action to take: PowerOff, Shutdown, Restart, or Logoff')]
        [ValidateSet('PowerOff', 'Shutdown', 'Restart', 'Logoff')]
        [string]$State,

        [switch]$force
    )
    BEGIN {
        switch ($state) {
            'LogOff' { $_action = 0 }
            'ShutDown' { $_action = 1 }
            'Restart' { $_action = 2 }
            'PowerOff' { $_action = 8 }
        }
        if ($force) { $_action += 4 }
        Write-Verbose "Action value is $_action"
    }
    PROCESS {
        foreach ($computer in $computername) {
            if ($PSCmdlet.ShouldProcess("$computer - action is $_action")) {
                Write-Verbose "Contacting $computer"
                $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer -EnableAllPrivileges
                $return = $os.win32shutdown($_action)
                Write-Verbose "Return value from $computer is $($return.returnvalue)"
            }
        }
    }
}
#This is an edit from the web


Function Set-AdatumServicePassword {
    <#
.SYNOPSIS
Sets the logon password for a service on one or more computers.
.DESCRIPTION
This command sets the logon password for a service. The
command uses CIM, so it will only work with computers where Windows
Remote Management (WinRM) has been enabled and Windows Management
Framework (WMF) 3.0 or later is installed.
.PARAMETER ComputerName
One or more computer names, as strings. IP addresses are not accepted.
You should only use canonical names from Active Directory. This
parameter accepts pipeline input. Computer names must be in the form
LON-XXYY, where "XX" can be a 2- or 3-character designation, and 
"YY" can be 1 or 2 digits.
.EXAMPLE
 Get-Content names.txt | Set-AdatumServicePassword -ServiceName "BITS" -NewPassword "Pa$$w0rd"
This example assumes that names.txt includes one computer name per
line, and will set the password for the BITS server on each computer listed.
#>
    [CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'Medium')]
    Param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = 'One or more computer names')]
        [Alias('HostName')]
        [ValidatePattern('LON-\w{2,3}\d{1,2}')]
        [string[]]$ComputerName,

        [Parameter(Mandatory = $True,
            HelpMessage = 'Name of service to set')]
        [string]$ServiceName,

        [Parameter(Mandatory = $True,
            HelpMessage = 'New password')]
        [securestring]$NewPassword
    )

    PROCESS {
        foreach ($computer in $ComputerName) {
            Write-Verbose "Retrieving $servicename from $computer"
            $service = Get-CimInstance -ClassName Win32_Service -ComputerName $computer -Filter "Name='$servicename'"

            if ($PSCmdlet.ShouldProcess("for $service on $computer")) {
                Write-Verbose "Setting password for $service on $computer"
                $result = $service | Invoke-CimMethod -MethodName Change -Arguments @{'StartPassword' = $NewPassword }
            }

            if ($result -ne 0) {
                Write-Warning "Failed to set password for $service on $computer"
            }

        }
    }
}

function Get-AdatumStyleSheet {
    [CmdletBinding()]
    Param()
    @"
<style>
body {
    font-family:Georgia,Monaco,Arial,Sans-Serif;
    font-size:10pt;
    color:Blue;
    background-color:Linen;
    margin:10px;
}
th {
    font-weight:bold;
    font-size:10pt;
    color:white;
    background-color:Grey;
}
td {
     font-weight:bold;
     font-size:10pt;
    color:Black;
    background-color:Linen;
    }
</style>
"@
}


function Get-AdatumNetAdapterInfo {
    <#
.SYNOPSIS
Retrieves network adapter and IP address information.
.DESCRIPTION
This command combines information about each network adapter
and all IP addresses bound to it. This uses CIM, so target computers
must have WMF 3.0 or later installed, and WinRM must be enabled.
.PARAMETER ComputerName
One or more computer name. IP addresses are not acceptable. This
parameter does not accept pipeline input.
.EXAMPLE
Get-AdatumNetAdapterInfo -ComputerName LON-DC1,LON-SVR1
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [string[]]$ComputerName
    )
    
    foreach ($computer in $computername) {

        Write-Verbose "Connecting to $computer"
        $session = New-CimSession -ComputerName $computer

        $adapters = Get-NetAdapter -CimSession $session
        foreach ($adapter in $adapters) {
            
            $addresses = Get-NetIPAddress -InterfaceIndex ($adapter.InterfaceIndex) -CimSession $session
            foreach ($address in $addresses) {

                $properties = @{'ComputerName' = $computer;
                    'AdapterName'              = $adapter.Name;
                    'InterfaceIndex'           = $adapter.InterfaceIndex;
                    'IPAddress'                = $address.IPAddress;
                    'AddressFamily'            = $address.AddressFamily;
                    'MACaddress'               = $adapter.macaddress
                }
                $output = new-object -TypeName PSObject -Property $properties
                Write-Output $output

            } # addresses
        } # adapeters
    } # computers

    Write-Verbose "Closing session to $computer"
    $session | Remove-CimSession

} # function

function Get-AdatumDiskInfo {
    <#
.SYNOPSIS
Retrieves disk and disk capacity information.
.DESCRIPTION
This command combines information about each fixed disk
including capacity. This uses CIM, so target computers
must have WMF 3.0 or later installed, and WinRM must be enabled.
.PARAMETER ComputerName
One or more computer name. IP addresses are not acceptable. This
parameter does not accept pipeline input.
.EXAMPLE
Get-AdatumDiskInfo -ComputerName LON-DC1,LON-SVR1
#>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [string[]]$computername
    )
    PROCESS {
        foreach ($computer in $computername) {

            $disks = Get-CimInstance -ComputerName $computer -ClassName Win32_LogicalDisk -Filter "DriveType=3"
            foreach ($disk in $disks) {
                $properties = @{'ComputerName' = $computer;
                    'DriveLetter'              = $disk.deviceid;
                    'FreeSpace'                = $disk.freespace;
                    'Size'                     = $disk.size
                }
                $output = New-Object -TypeName PSObject -Property $properties
                Write-Output $output

            } #dsisk
        } #computers
    } #process
} #function

<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function New-Speech {
    Param
    (
        [Parameter(Mandatory = $true, 
            ValueFromPipeline = $true)]
        [string]$text
    )

    #set up .net object for use
    Add-Type -AssemblyName System.Speech 
    $synth = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
    
    # Write-Host $text
    $synth.speak($text)
 
}

Function New-ADUserForm {
    #
    # Load the Windows Forms assembly
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing


    # Create Form

    $form = New-Object Windows.Forms.Form
    $form.Text = "New ADUser Form"
    $Form.Size = New-Object System.Drawing.Size(350, 450)
    $Form.StartPosition = "CenterScreen"
    #Always on top
    $form.Topmost = $true
    #Powershell Icon in title bar
    $Form.Icon = [Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path)
    # Create Buttons

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(75, 350)
    $OKButton.Size = New-Object System.Drawing.Size(75, 23)
    $OKButton.Text = "OK"
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $Form.AcceptButton = $OKButton
    $Form.Controls.Add($OKButton)
 
    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(175, 350)
    $CancelButton.Size = New-Object System.Drawing.Size(75, 23)
    $CancelButton.Text = "Cancel"
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $Form.CancelButton = $CancelButton
    $Form.Controls.Add($CancelButton)

    #Create Label for FirstName
    $FirstNameLabel = New-Object System.Windows.Forms.Label
    $FirstNameLabel.Location = New-Object System.Drawing.Point(10, 20)
    $FirstNameLabel.Size = New-Object System.Drawing.Size(70, 20)
    $FirstNameLabel.Text = "First Name:"
    $Form.Controls.Add($FirstNameLabel)
        
    #Create Input box for Firstname
    $FirstNameText = New-Object Windows.Forms.TextBox
    $FirstNameText.Location = New-Object Drawing.Point(120, 20)
    $FirstNameText.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($FirstNameText)

    #Create Label for Lastname
    $LastNameLabel = New-Object System.Windows.Forms.Label
    $LastNameLabel.Location = New-Object System.Drawing.Point(10, 60)
    $LastNameLabel.Size = New-Object System.Drawing.Size(70, 20)
    $LastNameLabel.Text = "Last Name:"
    $Form.Controls.Add($LastNameLabel)
        
    #Create Input box for Last name
    $LastNameText = New-Object Windows.Forms.TextBox
    $LastNameText.Location = New-Object Drawing.Point(120, 60)
    $LastNameText.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($LastNameText)


    #Create Label for Department
    $DepartmentLabel = New-Object System.Windows.Forms.Label
    $DepartmentLabel.Location = New-Object System.Drawing.Point(10, 100)
    $DepartmentLabel.Size = New-Object System.Drawing.Size(90, 20)
    $DepartmentLabel.Text = "Department:"
    $Form.Controls.Add($DepartmentLabel)
        
    #Create Input box for Department
    $DepartmentText = New-Object Windows.Forms.TextBox
    $DepartmentText.Location = New-Object Drawing.Point(120, 100)
    $DepartmentText.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($DepartmentText)

    #Create Label for Job Title
    $JobTitleLabel = New-Object System.Windows.Forms.Label
    $JobTitleLabel.Location = New-Object System.Drawing.Point(10, 140)
    $JobTitleLabel.Size = New-Object System.Drawing.Size(90, 20)
    $JobTitleLabel.Text = "JobTitle:"
    $Form.Controls.Add($JobTitleLabel)

    #Create Input box for Job Title
    $JobTitleText = New-Object Windows.Forms.TextBox
    $JobTitleText.Location = New-Object Drawing.Point(120, 140)
    $JobTitleText.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($JobTitleText)

    #Create Label for Password
    $PasswordLabel = New-Object System.Windows.Forms.Label
    $PasswordLabel.Location = New-Object System.Drawing.Point(10, 180)
    $PasswordLabel.Size = New-Object System.Drawing.Size(90, 20)
    $PasswordLabel.Text = "Password"
    $Form.Controls.Add($PasswordLabel)

    #Create Input box for Password
    $PasswordText = New-Object Windows.Forms.MaskedTextBox
    $PasswordText.PasswordChar = '*'
    $PasswordText.Location = New-Object Drawing.Point(120, 180)
    $PasswordText.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($PasswordText)



    #Create Label for Organizational Unit
    $OULabel = New-Object System.Windows.Forms.Label
    $OULabel.Location = New-Object System.Drawing.Point(10, 220)
    $OULabel.Size = New-Object System.Drawing.Size(150, 20)
    $OULabel.Text = "Organizational Unit"
    $Form.Controls.Add($OULabel)

    #Create Drop-down box for Organizational Unit
    $OUListText = New-Object system.Windows.Forms.ComboBox
    $OUListText.Location = New-Object Drawing.Point(170, 220)
    $OUListText.Size = New-Object System.Drawing.Size(150, 20)

    # Add the items in the dropdown list
    $oulist = Get-ADOrganizationalUnit -Filter { Name -ne 'Domain Controllers' } | Select-Object -Property Name, DistinguishedName
    $oulist | ForEach-Object { [void] $OUListText.Items.Add($_.Name) }
    $OUListText.SelectedIndex = 0
    $Form.Controls.Add($OUListText)


    #$OUInput.GetType()

    #Activate form ans set focus on it
    $Form.Add_Shown({ $FirstNameText.Select() })
    #Display the form in Windows
    $result = $Form.ShowDialog()


    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {

        #Extract OU distinguished name from a hastable as a reult of user selecting an OU from list
        #Create empty Hash table
        [HashTable]$Hash = @{}
        #Populate $Hash
        $oulist | Foreach { $hash.Add($_.Name, $_.Distinguishedname) }
        [string]$OUvalue = $OUListText.Text
        [String]$OUInput = $hash[$OUvalue]

        [string]$Password = $PasswordText.Text  
        [string]$DisplayName = $FirstNameText.text + " " + $lastnameText.text
        [string]$UPN = $FirstNameText.text + "." + $lastnameText.text + "@" + "Adatum.com"
        [string]$Username = $FirstNameText.text + "." + $lastnameText.text
        [string]$Firstname = $FirstNameText.text
        [string]$Lastname = $lastnameText.text
        [string]$OU = $OUInput
        [string]$email = $UPN
        [string]$jobtitle = $JobTitleText.text
        [string]$department = $DepartmentText.text


        New-Aduser -Name:$DisplayName -Samaccountname:$Username `
            -UserPrincipalName:$UPN -GivenName:$Firstname -Surname:$Lastname `
            -EmailAddress:$email -Department:$department `
            -Enabled:$true -DisplayName:$DisplayName -Path:$OU -Title:$jobtitle `
            -AccountPassword:(ConvertTo-SecureString $Password -AsPlainText -force) -ChangePasswordAtLogon:$false -WhatIf
        
        $Hash.Clear()
    }
}


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
   