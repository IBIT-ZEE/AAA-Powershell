# Notifications in sidebar with icon on tray
# todo: aaa-notify-None/Info/Warning/Error

if ( $args.Length -eq 0 )
	{
	Write-Host "`n`n"
	Write-Host "aaa-notify <messages>"
	Write-Host "`n`n"
	exit
	}
 
[string] $xIcon      = "Info"
[int32]  $xDuration  = 1000
[string] $xTitle     = $args[0]
[string] $xMessage   = ""

# make text message (strip Title)
# and add line breaks
for( $i = 1; $i -lt $args.Length; $i++ ) 
	{ $xMessage += [string]( $args[ $i ] ) + "`n" }

#[void] [System.Reflection.Assembly]::LoadWithPartialName( "System.Windows.Forms" )
Add-Type -AssemblyName "System.Windows.Forms"

$xNotify = New-Object System.Windows.Forms.NotifyIcon 
$xNotify.Icon = [System.Drawing.SystemIcons]::Information
# $x.Icon = "C:\dat\aaa\zee.ico"
$xNotify.BalloonTipIcon  = $xIcon
$xNotify.BalloonTipText  = $xMessage
$xNotify.BalloonTipTitle = $xTitle
$xNotify.Visible = $true
$xNotify.ShowBalloonTip( $xDuration )


