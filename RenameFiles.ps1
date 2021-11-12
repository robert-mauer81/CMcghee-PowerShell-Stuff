#create list of files in array and rename txt to ps1
#Consider adding variable for A and B

$files = Get-ChildItem -Path E:\mod08\democode\ -Exclude computers.txt -ErrorAction SilentlyContinue
foreach ($file in $files) {
    $newfile = $file.Name.Replace("txt", "ps1")  #replace "A" with "B"
    
    Rename-Item $file $newFile
}
