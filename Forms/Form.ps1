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