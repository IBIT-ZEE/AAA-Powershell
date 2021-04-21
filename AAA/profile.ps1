<#

.SYNOPSIS
|A|A|A|

Main objective is to define basic funcionality
and import AAA Modules

AAA-0-Base
AAA-1-System
AAA-2-Extensions
AAA-3-Other

short-functions *should be lambdas
is???( x ) for datatypes
has( x )


.NOTES
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


# Allow try/catch to work with commandlets
$ErrorActionPreference = "Stop";
$WarningPreference = "SilentlyContinue"

Import-Module -Name C:\dat\PowerShell\AAA\AAA-String.psm1
Import-Module -Name C:\dat\PowerShell\AAA\AAA-Strings.psm1

Import-Module -Name C:\dat\PowerShell\AAA\AAA-0-Base.psm1
Import-Module -Name C:\dat\PowerShell\AAA\AAA-1-System.psm1
Import-Module -Name C:\dat\PowerShell\AAA\AAA-2-Extensions.psm1
Import-Module -Name C:\dat\PowerShell\AAA\AAA-3-Other.psm1


# Import-Module -Name C:\dat\PowerShell\AAA\_AA.psm1		# AA Generic Function/State prototype
Import-Module -Name C:\dat\PowerShell\AAA\AA.psm1		# AA/Help+Reference
Import-Module -Name C:\dat\PowerShell\AAA\AV.psm1		# Antivirus/MS/...
Import-Module -Name C:\dat\PowerShell\AAA\BK.psm1		# Backup/...
Import-Module -Name C:\dat\PowerShell\AAA\DB.psm1		# Database/ADO/Dataset
Import-Module -Name C:\dat\PowerShell\AAA\FS.psm1		# Filesystem/Files/Folders/...
Import-Module -Name C:\dat\PowerShell\AAA\MN.psm1		# Menus/Console
Import-Module -Name C:\dat\PowerShell\AAA\NW.psm1		# Network
Import-Module -Name C:\dat\PowerShell\AAA\OS.psm1		# Operating System
Import-Module -Name C:\dat\PowerShell\AAA\PS.psm1		# Powershell
Import-Module -Name C:\dat\PowerShell\AAA\TS.psm1		# Text-to-Speech
Import-Module -Name C:\dat\PowerShell\AAA\UI.psm1		# User Interfaces (CUI/GUI/WUI/...)
Import-Module -Name C:\dat\PowerShell\AAA\VD.psm1		# Virtual Devices
Import-Module -Name C:\dat\PowerShell\AAA\VM.psm1		# Virtual Machine
Import-Module -Name C:\dat\PowerShell\AAA\WS.psm1		# WebServices
Import-Module -Name C:\dat\PowerShell\AAA\WF.psm1		# WebServices


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



<# .net EXTENSIONS #>
# in correnspondent .psm1 libraries
# here only new or misfits...
# ... 


<# COMMANDS #>
function ~() { Set-Location $env:USERPROFILE  }
function _-() { Get-Command -name "*-" -CommandType function }
function _--() { Get-Command -name "*--" -CommandType function }


<#
SYSTEM

exists( <var> )
is???
has()
exists() ?test make with get-variable???
#>

function accelerators		{ [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators")::get }
function code( $x )			{ Get-Content -path function:$x }
function debug( $x )		{ AAA-Debug -xFunction $x -xOn }
# function err()				{ Write-Host -ForegroundColor Red $error[-1] }
function delete( $x )		{ Remove-Variable -name $x -scope global }
function edit( $x )			{ AAA-Edit $x }
#function error()			*error symbol exists in PS>5.0
function errorX()			{ (Get-Error -newest 1).Message }
function exists( ${~} )		{ try { Out-Null -InputObject ( invoke-expression ( "$" + ${~} )); $true } catch { $false }  }
function functions( $x )	{ Get-ChildItem -Path function:\ | Where-Object { $_.name -match $x } | Format-Table -AutoSize }
function help( $xItem )		{ Get-Help -Name $xItem -ShowWindow }
function helpX( $xItem = "Show-Command" )	{ Show-Command -CommandName $xItem }
function isEmpty( $x ) 		{ return [string]::IsNullOrEmpty( $x ) }
function isNull( $x ) 		{ return ( $null -eq $x ) }
function obsolete( $x )		{ if ($Host.Version.Major -ge $x) { throw "$((Get-PSCallStack)[-2].FunctionName) ~> O*B*S*O*L*E*T*E in PS#$x"  } }
function print()			{ foreach( $x in $args ){ Write-Host -NoNewline $x }}
function type( $x )			{ if( $x ){ $x.GetType() | Format-Table -AutoSize } else { return '$null'; }}
function typeX( $x )		{ if( $x ){ $x.GetType() | Format-List * }; return '$null' }
function variables( $xMatch )	{ Get-Variable -Include $xMatch }
function version()			{ $Host.Version.Major }
function versionX()			{ $Host.Version.Minor }

# <functional paradigm MAP/FILTER/REDUCE>
# sadly Powershell already has a keyword named "filter"... so "filtr"
# for reduce-context assume $__ as the 'collector'
function map( $xData, $xLambda ){ return  $xData | ForEach-Object $xLambda }
function filtre( $xData, $xLambda ){ $xData | Where-Object $xLambda }
function reduce( $xData, $xLambda )
	{ $__ = ( $null -as $xData[0].GetType()); foreach( $_ in $xData ){ Invoke-Command -ScriptBlock $xCode -ArgumentList $_,$__ -NoNewScope }; return $__}



<# COMMANDS #>
function grid( $x )			{ $x | Out-GridView -PassThru }

function iif( $x, $a, $b )	{ if( $x ) { return $a } else { return $b } }
function info( $xItem )		{ Get-Command -Name $xItem | Format-List * }
function input( $x = "" )	{ if( $x ){ $x = @{ 'prompt' = $x } } else { $x = @{} }; Read-Host @x }
function object( $x )		{ Object-View $x;	}
function objectX( $x )		{ Out-GridView -InputObject ( Object-View $x );	}
function path( [string]$x )	{ where.exe $x }
function reload( )			{ PS-Reload }
function services( $x )		{ Services-Names $x }
function wait( $x = 1 )		{ Start-Sleep -seconds $x }



<# COMMANDS WITH DEFAULT PARAMETER #>
function assist( $xItem = "Show-Command" )	{ Show-Command -CommandName $xItem }
function commandX( $xItem = "Show-Command" )	{ Show-Command -CommandName $xItem }

function history( [string]$xMatch = "." )	{ AAA-History $xMatch }
function historyX( [string]$xMatch = "." )	{ AAA-HistoryX $xMatch;	}



# AAA-Links
# use Function for the long-version 
# use Alias the short-version ~> l! lx! s! sx!
function links!		{ Set-Location -Path C:\DAT\#Links\ }
function linksX!	{ Set-Location -Path C:\DAT\#LinksX\ }
function scripts!	{ Set-Location -Path C:\DAT\#Scripts\ }
function scriptsX!	{ Set-Location -Path C:\DAT\#ScriptsX\ }
function AAA!		{ Set-Location -Path C:\DAT\AAA\ }
function APL!		{ Set-Location -Path C:\APL\ }
function DAT!		{ Set-Location -Path C:\DAT\ }
function SYS!		{ Set-Location -Path C:\SYS\ }
function XXX!		{ Set-Location -Path C:\XXX\ }


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

Set-Alias -Name '^' -Value 'Select-Object'



#[PSREADLINE ANSI COLORS]#########################################################
#
# ATT*** Only versions sfter 5.x
#
# QUIRK ~> { Operator = "`e[35;1m" } for bold-or-bright
# affects bright of next elements in the same line
#
#

<#
CommandColor                           : "`e[93m"
CommentColor                           : "`e[32m"
ContinuationPromptColor                : "`e[37m"
DefaultTokenColor                      : "`e[37m"
EmphasisColor                          : "`e[96m"
ErrorColor                             : "`e[91m"
KeywordColor                           : "`e[92m"
MemberColor                            : "`e[97m"
NumberColor                            : "`e[97m"
OperatorColor                          : "`e[90m"
ParameterColor                         : "`e[90m"
InlinePredictionColor                  : "`e[38;5;238m"
SelectionColor                         : "`e[30;47m"
StringColor                            : "`e[36m"
TypeColor                              : "`e[37m"
VariableColor                          : "`e[92m"
#>

if ( $PSVersionTable.PSVersion.Major -gt 5 )
	{
	#ATT*** USE Get-PSReadLineOption TO INSPECT COLORS

	Set-PSReadLineOption -Colors @{

		"Default"   = "White";
		"Error"     = "`e[97m`e[41m";

		"Keyword"   = "`e[32m";
		"Number"    = "`e[30m`e[43m";
		"String"    = "`e[30m`e[46m";
		"Variable"  = "`e[33m";
		"Operator"  = "`e[95m";
		"Comment"   = "`e[96m";

		"Command"   = "#4488CC";
		"Member"    = "#EECCAA";
		"Type"      = [System.ConsoleColor]::DarkGreen;
		"Parameter" = [System.ConsoleColor]::Magenta;

		"InlinePrediction"   = "#0FAFE0";
		"ContinuationPrompt" = "#FAFFAF";
		}

	Set-PSReadLineOption -BellStyle Audible -DingTone 1221 -DingDuration 60;
	
	}


# %USERPROFILE$ / %HOME%
~

