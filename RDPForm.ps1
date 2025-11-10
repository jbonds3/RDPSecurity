$subScriptpath = [System.IO.Path]::Combine($PSScriptRoot, 'RDPFunctions.ps1')

#---To Do, explain dot operator in code before calling variable
. $subScriptpath

#Add Forms and Drawing .NET classes to PS Session
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


#Get Admin Privilleges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -WindowStyle Hidden; exit}


#RDP Form
$rdpForm = New-Object System.Windows.Forms.Form

#RDP Form
$rdpForm.Text = "RDP Security"
$rdpForm.Width = 400
$rdpForm.Height = 300
$rdpForm.StartPosition = "CenterScreen"


$VarXdist1 = 20
$VarYdist1 = 30

$VarXdist2 = 120

$port = Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "PortNumber"

#Client Label 
$rdpPortLabel = New-Object System.Windows.Forms.Label
$rdpPortLabel.Text = "RDP Port:"
$rdpPortLabel.Location = New-Object System.Drawing.Point($VarXdist1, $VarYdist1)
$rdpForm.Controls.Add($rdpPortLabel) 

#Client Dropdown selection
$rdpTextBox = New-Object System.Windows.Forms.TextBox
$rdpTextBox.Location = New-Object System.Drawing.Point($VarXdist2, $VarYdist1)
$rdpTextBox.Name = "clientSelection"
$rdpTextBox.Width = 150
$rdpTextBox.Text = $port.PortNumber

$rdpForm.Controls.Add($rdpTextBox)

# $readRDPBtn = New-Object System.Windows.Forms.Button
# $readRDPBtn.Text = "Read"
# $readRDPBtn.Location = New-Object System.Drawing.Point(150, 70)
# $rdpForm.Controls.Add($readRDPBtn)  

$enableRDPBtn = New-Object System.Windows.Forms.Button
$enableRDPBtn.Text = "Enable"
$enableRDPBtn.Location = New-Object System.Drawing.Point(150, 70) 

$enableRDPBtn.Add_Click({
    enableRDP
    $rdpTextBox.Text = readPort
})

$rdpForm.Controls.Add($enableRDPBtn) 

$disableRDPBtn = New-Object System.Windows.Forms.Button
$disableRDPBtn.Text = "Disable"
$disableRDPBtn.Location = New-Object System.Drawing.Point(150, 130)

$disableRDPBtn.Add_Click({
    disableRDP
    $rdpTextBox.Text = readPort
   
})

$rdpForm.Controls.Add($disableRDPBtn)  

#Close Button
$closeRDPBtn = New-Object System.Windows.Forms.Button
$closeRDPBtn.Text = "Close"
$closeRDPBtn.Location = New-Object System.Drawing.Point(200, 200)
$rdpForm.Controls.Add($closeRDPBtn)    

#Close Button Action
$closeRDPBtn.Add_Click({
    
    $rdpForm.Close()

   # if ([string]::IsNullOrEmpty($client)) {
   #     Start-Sleep -Milliseconds 250
   
})

#Show Window
[void]$rdpForm.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))