
<#
Add-Type -AssemblyName System.Windows.Forms

 

# Create a form
$form = New-Object Windows.Forms.Form
$form.Text = "Connor's Great Day Motivator"
$form.Size = New-Object Drawing.Size(600, 200)

 

# Create a label
$label = New-Object Windows.Forms.Label
$label.Text = "Are you ready to have a great day?"
$label.Location = New-Object Drawing.Point(200, 30)
$label.Width = 300
$form.Controls.Add($label)

 

# Create the first button
$Button1 = New-Object System.Windows.Forms.Button
$Button1.Text = "Yes I am"
$Button1.Location = New-Object System.Drawing.Point(50, 100)

 

# Create the second button
$Button2 = New-Object System.Windows.Forms.Button
$Button2.Text = "No I am not"
$Button2.Location = New-Object System.Drawing.Point(450, 100)

 

# Define an event handler for the button click event
$button1.Add_Click({
        $label.Text = "Well, let's have a great day!"
    })
# Define an event handler for the button click event
$button2.Add_Click({

        $label.Text = "Fix that attitude and let's have a great day!"

 

    })

 

$form.Controls.Add($button1)
$form.Controls.Add($button2)

 

# Show the form
$form.ShowDialog()

 

# Dispose of the form when done
$form.Dispose()
#>

#NOTHER ONE to Look At

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
$FirstNameText= New-Object Windows.Forms.TextBox
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
$OULabel.Size = New-Object System.Drawing.Size(110, 20)
$OULabel.Text = "Organizational Unit"
$Form.Controls.Add($OULabel)

#Create Drop-down box for Organizational Unit
$OUListText = New-Object system.Windows.Forms.ComboBox
$OUListText.Location = New-Object Drawing.Point(120, 220)
$OUListText.Size = New-Object System.Drawing.Size(200, 20)

# Add the items in the dropdown list
$oulist = Get-ADOrganizationalUnit -Filter{Name -ne 'Domain Controllers'} | Select-Object -Property Name,DistinguishedName
$oulist | ForEach-Object {[void] $OUListText.Items.Add($_.Name)}
# Select the default value
$OUListText.SelectedIndex = 0
$Form.Controls.Add($OUListText)
$Hash = @{}

#This seems to work I think you had the proporties twisted 
#$oulist = Get-ADOrganizationalUnit -Filter{Name -ne 'Domain Controllers'} | Select-Object -Property Name,DistinguishedName
#$oulist | ForEach-Object {
#    [void] $OUListText.Items.Add($_.DistinguishedName)
#}
# Select the default value
#$OUListText.SelectedIndex = 0
#$Form.Controls.Add($OUListText)

#Activate form ans set focus on it
$Form.Add_Shown({ $FirstNameText.Select() })
#Display the form in Windows
$result = $Form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK){
    IF(Get-ADUser -Filter { SamAccountName -eq $Username }) {
        #If user does exist, give a warning and keep on going
        Write-Warning "A user account with username $Username already exist in Active Directory."
    }
ELSE
{ Write-host $OU
    [string]$Password = $PasswordText.Text | ConvertTo-SecureString -AsPlainText -force 
    [string]$DisplayName = $FirstNameText.text + " " + $lastnameText.text
    [string]$UPN = $FirstNameText.text + "." + $lastnameText.text+ "@" + "Adatum.com"
    [string]$Username = $FirstNameText.text+ "." + $lastnameText.text
    [string]$Firstname = $FirstNameText.text
    [string]$Lastname = $lastnameText.text
    [string]$OU = $hash[0]
    [string]$email = $UPN
    [string]$jobtitle = $JobTitleText.text
    [string]$department = $DepartmentText.text

    #New-Aduser -Name:$DisplayName -Samaccountname:$Username -UserPrincipleName:$UPN -GivenName:$Firstname -Surname:$Lastname `
    #-Enabled:$true -DisplayName:$DisplayName -Path:$oulist.
<#
    [string]$Password 
    [string]$DisplayName
    [string]$UPN 
    [string]$Username 
    [string]$Firstname 
    [string]$Lastname 
    [string]$OU
    [string]$email
    [string]$jobtitle
    [string]$department
#>   
}}