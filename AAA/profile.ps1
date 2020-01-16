<#

|A|A|A|

Main objective is to define basic funcionality
and import AAA Modules

AAA-0-Base
AAA-1-System
AAA-2-Extensions
AAA-3-Other


TODO***
???is it needed yet
detect if script is to be excecuted in -command -file
(Get-CimInstance Win32_Process -Filter "ProcessID=$PID").CommandLine
or user -noProfile switch

Objective is to call AAA-Info only if no parameters passed
* so if no 1st parameter (script name) 
* means user wants a interactive console

#>


Set-StrictMode -Version 5;

#[MODULES]######################################################################
#
# Stop powershell <Command>-<Verb> warnings
# because of our <Object>-<Action> syntax
#
$WarningPreference = "SilentlyContinue"
Import-Module -Name C:\dat\PowerShell\AAA\AAA-0-Base.psm1
Import-Module -Name C:\dat\PowerShell\AAA\AAA-1-System.psm1
Import-Module -Name C:\dat\PowerShell\AAA\AAA-2-Extensions.psm1
Import-Module -Name C:\dat\PowerShell\AAA\AAA-3-Other.psm1

Import-Module -Name C:\dat\PowerShell\AAA\AV.psm1
$WarningPreference = "Continue"

# Start-Sleep -Seconds 10

#[FUNCTIONS]####################################################################
#
# Base system extension
#
function Prompt() { 

	$x = ""
	$x += "`n"
	$x = ( Get-Location ).Path

	$xLength = $Host.UI.RawUI.MaxWindowSize.Width - $x.Length - 19

	if ( $xLength -gt 1 ) 
		{  
		$x += " " * $xLength;
		$x += ( Get-Date -Format "yyyy.MM.dd-HH.mm.ss" );
		}

	Write-Host $x -BackgroundColor DarkGray -ForegroundColor Gray
	"> "
	}

<#
COMMANDS
#>
function functions( $x ){ Get-ChildItem -Path function:\ | Where-Object { $_.name -match $x } | Format-Table -AutoSize }
function code( $x ) { Get-Content -path function:$x }
function delete( $x ) { Remove-Variable -name $x -scope global }
function history( [string]$xMatch = "." ) { AAA-History $xMatch }
function historyX( [string]$xMatch = "." ) { AAA-HistoryX $xMatch;	}
function help( $xItem ) { Get-Help -Name $xItem -ShowWindow }
function path( [string]$x ){ where.exe $x }
function type( $x ) { $x.GetType() | Format-Table -AutoSize }
function typeX( $x ) { $x.GetType() | Format-List * }
function services( $x ) { Services-Names $x }
function variables( $xMatch ) { Get-Variable | Where-Object { $_.Name -match $xMatch } }

# AAA-Links
# use Function for the long-version 
# use Alias the short-version ~> l! lx! s! sx!
function links! {Set-Location -Path C:\DAT\#Links\}
function linksX! {Set-Location -Path C:\DAT\#LinksX\}
function scripts! {Set-Location -Path C:\DAT\#Scripts\}
function scriptsX! {Set-Location -Path C:\DAT\#ScriptsX\}
function AAA! {Set-Location -Path C:\DAT\AAA\}
function APL! {Set-Location -Path C:\APL\}
function DAT! {Set-Location -Path C:\DAT\}
function SYS! {Set-Location -Path C:\SYS\}
function XXX! {Set-Location -Path C:\XXX\}


# AAA-Alias
# Get-Alias | Where-Object { $_.Source -like "AAA*" }
#
# AAA-Functions
# Get-Module -Name AAA* | foreach { $_.Name; "-" * $_.Name.Length;  $_.ExportedFunctions.Keys; "`n" }
#

#[ALIAS]########################################################################
#
AAA-Alias

# QUIRK***
# Remove-Item is not affect AllScope/Built-in aliases, 
# so do not work inside functions
# in PS 6.xx can use Remove-Alias
# REMOVE (defuse conflict with functions)
Remove-Item -Force Alias:\type
Remove-Item -Force Alias:\where

