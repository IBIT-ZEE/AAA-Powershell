# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |P|S|
#


<#
.SYNOPSIS
Language inspection
Metadata inspection
#>
function PS- { AAA-Functions }
function PS-Commands( $x="*" )   { Get-Command -Type Cmdlet -Name $x }
function PS-Functions( $x="*" )  { Get-Command -Type Function -Name $x }
function PS-Scripts( $x="*" )	  { Get-Command -Type ExternalScript -Name $x }
function PS-Parameters( $x="*" ) { Get-Command -ParameterName $x }
function PS-Modules( $x="*" )	{ Get-Module -Name $x }
function PS-Version()	  		{ $Host.Version.Major }
function PS-VersionX()	  		{ $Host.Version.Minor }


function PS-Reload()
	{ 

	Write-Host -NoNewline ( "PID (Old/New) : {0}/" -f $PID )

	# set ENVIRONMENT variable in the same PROCESS-SPACE
	[Environment]::SetEnvironmentVariable("POWERSHELL-PID", $PID, "process")

	# Invoke-Command -ScriptBlock { (Get-Process -PID $pid).Path -noexit -command PS-Reloaded } -NoNewScope
	Invoke-Command -ScriptBlock { C:\APL\Microsoft\PowerShell64\pwsh.exe -noexit -command PS-Reloaded } -NoNewScope

	}

function PS-Reloaded()
	{
	# Discard calling process
	Get-Process -PID ${env:POWERSHELL-PID} `
		| Stop-Process -force

	$PID
	}
