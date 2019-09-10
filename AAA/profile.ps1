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
$WarningPreference = "Continue"

~

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

	Write-Host $x -BackgroundColor DarkBlue -ForegroundColor Gray
	"> "
	}

function history( [string]$xMatch = "." ) { AAA-History $xMatch }
function historyX( [string]$xMatch = "." ) { AAA-HistoryX $xMatch;	}
function help( $xItem ) { Get-Help -Name $xItem -ShowWindow }
function variables( $xMatch ) { Get-Variable | Where-Object { $_.Name -match $xMatch } }


#[ALIAS]########################################################################
#
# Alias cannot be set inside a function
# so AAA-Alias was deprecated
# or use Set-Alias -scopt "global" ???try

AAA-Alias
