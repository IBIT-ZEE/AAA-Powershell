<#
CONSOLE
EVENTS REGISTRY
NETWORK 

#>


$____CLI=
<#[ CLI ]########################################################################>
Function Foo( $directory )
	{ echo $directory }
	if ( $args.Length -eq 0 ) { echo "Usage: Foo <directory>" }
	else { Foo($args[0]) }

# parameter validation
param(
	# Our preferred encoding
	[ parameter( Mandatory=$false ) ]
	[ ValidateSet("UTF8","Unicode","UTF7","ASCII","UTF32","BigEndianUnicode") ]
	[string] $Encoding = "UTF8"
	)

	?default
	
	write ("Encoding : {0}" -f $Encoding)




$____GUI=
<#[ GUI ]####################################################################>

[System.Windows.Forms.DockStyle] 1= 2=TOP 3= 4= 5=Fill

# MESSAGEBOX
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show( "Text`nof`nMessage", "Title" )
[System.Windows.MessageBox]::Show( "111`n222`n333", "Title...", "YesNoCancel", "info" ) # r:Yes/No/Cancel

# FORM/TEXTBOX/OPTIONS
# show form with a message and OK/Cancel buttons
# return 
Add-Type -AssemblyName System.Windows.Forms
$x = [System.Windows.Forms.Form]::New()
# Textbox
$xTB0 = [System.Windows.Forms.Textbox]::New(); 
$xTB0.BackColor = [System.Drawing.Color]::Aqua;
$xTB0.Multiline=True;
$xTB0.Dock = [System.Windows.Forms.DockStyle]
$x.Controls.Add( $xTB0 )

# FlowControlLayout
$xFLP0 = [System.Windows.Forms.FlowLayoutPanel]::New(); 
$xFLP0.BackColor = [System.Drawing.Color]::Green;
$xFLP0.Dock = 1;
$x.Controls.Add( $xFLP0 )
# Button
$xBT1 = [System.Windows.Forms.Button]::New(); 
$xBT1.BackColor = [System.Drawing.Color]::LightYellow;
$xBT1.Text = "button 1"
$xFLP0.Controls.Add( $xBT1 )
$x.ShowDialog()


# LISTBOX/PICKER
# return modalResult:OK/Cancel and $x.itemNumber
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select a Computer'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please select a computer:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)
$listBox.Height = 80

[void] $listBox.Items.Add('atl-dc-001')
[void] $listBox.Items.Add('atl-dc-002')
[void] $listBox.Items.Add('atl-dc-003')
[void] $listBox.Items.Add('atl-dc-004')
[void] $listBox.Items.Add('atl-dc-005')
[void] $listBox.Items.Add('atl-dc-006')
[void] $listBox.Items.Add('atl-dc-007')

$form.Controls.Add($listBox)
$form.Topmost = $true
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK){ $listBox.SelectedItem }


$____EVENTS=
<#[ EVENTS+ ################################################################>
# Clear
foreach( $e in (Get-EventLog -LogName *)) { Clear-EventLog $e.log } 

# Clear by deleting files in system32/winevt/logs
#?  error?  exists?  ?>0
$xFolder=( $env:SystemRoot + '\system32\winevt\logs' )
$xFiles=(Get-ChildItem $xFolder) | Select-Object name
Start $xFiles							# launch folder to view/control
set-Service EventLog -StartupType Disabled
stop-Service EventLog -Force
Set-Location $x
foreach ( $e in $xFiles ) { Remove-Item $e.name }
set-Service EventLog -StartupType Automatic
start-Service EventLog -Force

# event log archived (.etl/.evt/.evtx)
Get-WinEvent -Path C:\fso\SavedAppLog.evtx



$____EXCEPTIONS
<#[ EXCEPTIONS ]###############################################################>

try {}
catch { $_.Exception.Message }




$____NETWORK=
<#[ NETWORK ]##################################################################>
# FIREWALL
Get-NetFirewallRule -DisplayGroup Remote*
Get-NetFirewallRule -Action Block -Enabled True -Direction Inbound
Get-NetFirewallRule -Action Allow -Enabled False -Direction Inbound -DisplayGroup Network* | select DisplayName, DisplayGroup
Get-NetFirewallRule -Action Block -Enabled True | %{$_.Name; $_ | Get-NetFirewallApplicationFilter}
Get-NetFirewallProfile -Name Domain | Get-NetFirewallRule | ? DisplayName ‑like File*
Disable-NetFirewallRule -Action Block -Enabled True -Direction Inbound
?Remove-NetFirewallRule 
netsh advfirewall set allprofiles state on/off

# IP data
Get-WmiObject -Class Win32_NetworkAdapterConfiguration
[net.dns]::GetHostAddresses("") | Select -ExpandProperty IPAddressToString
[Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces().GetIPProperties().UnicastAddresses
Test-Connection -ComputerName server0
(netsh interface ipv4 show addresses) -match 'Address' -replace '.+:\s+(\S+)', '$1'
systeminfo|%{@(([regex]"\s{33}\[\d{2}\]:\s(?<I>.*)").Matches($_).Groups)[-1].Value}
(ipconfig) -like '*ipv4*' | %{ ( $_ -split " : " )[1] }

$x = Get-NetIPConfiguration
	$x[0].IPv4Address[0].
		IPAddress			 10.0.1.8
		PrefixLength		: 8
		InterfaceAlias		: LAN1
		ifIndex				: 15
		AddressFamily		: IPv4

++get-WmiObject -class Win32_Share -computer server0



$____REGISTRY=
<#[ $REGISTRY ]###############################################################>

$hive = [Microsoft.Win32.RegistryKey]::OpenBaseKey('ClassesRoot', 'Default')
$key = $hive.CreateSubKey('Microsoft.PowerShellScript.1\Shell\Open\Command')
$key.SetValue($null, 'Powershell.exe -Command "& {Start-Process PowerShell.exe -Verb RunAs -ArgumentList ''-File """%1"""''}"')




$____TYPES=
<#[ TYPES ]####################################################################>

# date/time
$x = [datetime]::Now
	.[Day/DayOfWeek/DayOfyear/Month/Year]
	.[Hour/Minute/Second/MilliSecond]
	.Ticks
	.ToShortDateString()
	.Kind




$____CONSOLE=
<#[ CONSOLE ]################################################################>
function prompt { "`n`n" + (get-location) + "> " }



