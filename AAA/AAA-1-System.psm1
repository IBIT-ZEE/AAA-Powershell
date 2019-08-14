<#
AAAX Module


TODO
=====
Get-Command –Module NetTCPIP –Name *IP*
Get-Help Get-Process
Get-Process | Get-Member

Start-Process notepad.exe
$NotepadProc = Get-Process -Name notepad
$NotepadProc.WaitForExit()
Start-Process calc.exe

Import-Module -Name C:\dat\PowerShell\AAA\AAA-1-System.psm1 -Force
#>

Set-StrictMode -Version 5;





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |C|O|U|N|T|E|R|S|
#

function Counters-Table
	{
	Get-Counter -ListSet * | Out-GridView -PassThru
	}


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |D|I|A||G|N|O|S|T|I|C|S|
#

function Diagnostics- 
	{ 
	AAA-List 
@'


See:
		Counters
		Environment
		...
'@
	}




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |D|I|A|L|O|G|
#


function Dialog- { AAA-List }

function Dialog-Message ( [string] $xMessage, [string[]] $xOptions = @('OK') )
	{
	
	}


function Dialog-List ()
	{
	
	}

function Dialog-Picker ()
	{
	
	}


function Dialog-Grid ()
	{
	
	}





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |E|V|E|N|T|S|
#

function Events- { AAA-List }


function Events-All ( $x=10 )
	{ 
	# get last <n> events from all logs

	}


function Events-First( [int] $x=10 ) 
	{
	# oldest <n>
	}


function Events-Last( [int] $x=10 ) 
	{
	# newest <n>
	}


function Events-Store- { AAA-List }


<#
Show all event-store names that has events (recordCount > 0)
#>
function Events-Store-Any()
	{
	Get-WinEvent -ListLog * | Where-Object {$_.RecordCount -gt 0}
	}


# CLEAR STANDARD LOGS (Application System Security ...)
function Events-Store-Clear()
	{
	$x = Get-EventLog -List 
	
	"Clearing standard logs..."
	foreach( $e in $x)
		{
		echo $e.Log;
		Clear-EventLog -LogName $e.log 
		}

	}


function Events-Store-ClearX()
	{

	$x = Get-WinEvent -ListLog *

	"Clearing Windows extended logs..."
	foreach( $e in $x)
		{
		echo $e.LogName;
		[System.Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.ClearLog( $e.LogName ) 
		}
	}


function Events-Store-ClearByWEvtUtil()
	{
	$x = wevtutil.exe el
	$x | ForEach-Object  {"Clearing...", $_; wevtutil cl $_; "Cleared!`n`n"  }

	# check
	$x | ForEach-Object  {wevtutil qe $_ }
	}


function Events-Store-ClearFiles()
	{
	#1 stop event service
	#2 remove all files in events path
	#3 start service
	}


# EMPTY
function Events-Store-Empty()
		{
		Get-WinEvent -ListLog * | Where-Object {$_.RecordCount -eq 0}
		}


function Events-Store-System()
	{
	Get-EventLog -LogName System
	}

function Events-Programs-Hidden
	{
	Get-EventLog -LogName System -InstanceId 1073748869
	}



	
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |F|I|L|E|
#


function File- { AAA-List }



function Files-ACLCheck()
 	{
	Param( 
		[Parameter(HelpMessage = 'Enter a directory or file path')]      
		[ValidateScript({if ($_ -match '\\'){Test-Path $_}else{$True}})] 
		[string]$path 
	) 
	 
	$arr = @()

	Get-ChildItem -Path $path -Recurse | ForEach-Object -Process { 
		$path = $_.fullname 
		$acl = Get-Acl $path 
		$sid = $acl.access | Where-Object -FilterScript { 
			$_.identityreference -match 'S-1-.*' -and !($_.isinherited) 
		} 

		if($sid) 
			{ 
			$sid| ForEach-Object -Process { 
				$co = [pscustomobject] @{ 
					Path       = $path 
					RemovedSID = $_.identityreference 
					} 
				$co|Format-List
				}


			}
		}
	}


function File-Blocked( [string]$xFile )
	{
	# $xFile should be an absolute path 
	# otherwise will default to the home directory 
	$xFile = Resolve-Path $xFile
	try { [IO.File]::OpenWrite( $xFile ).Close(); $False }	catch { $True }
	}

	
function File-Copy
	{
	Get-Command *file* -CommandType function
	Get-Command *file* -CommandType cmdlet
	Get-Command *file* -CommandType alias
	}


function File-Exists( [string]$xFile )
	{
	
	}


# ???File-Path ???File-Info 
# .Name
# .Extension
# .Parents
# .Drive
# .Full
# ?Size
# ?Owner
# ?Rights
function File-Info( $xFile = "." )
	{
	if ( -not ( Test-Path $xFile ) ){ return $null }
	if ( Test-Path $xFile -PathType Container ){ return $null }

	$xData = @{ Full=""; Name=""; Extension="";  Path=""; Drive="" }

	# ATT*** Resolve-Path 
	# can returns collections for wildcards
	# not a single file

	$x = Split-Path $xFile -Leaf
	$xData.Name      = $x.Substring( 0, $x.LastIndexOf( "." ) );
	$xData.Extension = $x.Substring( $x.LastIndexOf( "." ) + 1 );

	$x = Split-Path $xFile -Resolve -Parent
	$xData.Path  = $x.Substring(2) ;
	$xData.Drive = $x.Substring(0,2);
	$xData.Full  = $xData.Drive + "\" + $xData.Path + "\" + $xData.Name + "." + $xData.Extension;

	return $xData;
	}


function File-Read( [string]$xFile )
	{
	# collection of string
	[System.IO.File]::ReadAllBytes( (Resolve-Path $xFile) )
	}

function File-ReadText( [string]$xFile )
	{
	# collection of strings
	# full-path or tries to get file in System32
	[System.IO.File]::ReadAllText( (Resolve-Path $xFile) )
	}

function File-ReadLines( [string]$xFile )
	{
	# collection of strings
	# same as -> Get-Content -path $xFile
	# full-path or tries to get file in System32
	[System.IO.File]::ReadAllLines( (Resolve-Path $xFile) )
	}



# Reset file rights and change owner to ?Everyone
function File-Reset( [string] $x )
	{
	
	}


function File-Write( [string]$xFile )
	{
	# same as ~> Set-Content
	# full-path or tries to get file in System32
	try
		{
		$stream = [System.IO.StreamWriter]::new( $Path )
		$data | ForEach-Object{ $stream.WriteLine( $_ ) }
		}
	finally
		{ $stream.close() }
	}




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |F|I|X|
#
function Fix- { "See Powershell-" }


function Fix-PS1Run
	{
	New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT

	Set-ItemProperty `
		-Path "HKCR:\Microsoft.PowerShellScript.1\Shell\open\command" `
		-name '(Default)' `
		-Value '"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -noLogo -ExecutionPolicy unrestricted -file "%1"'
	}







# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# |F|O|L|D|E|R|S|
#

function Folder- { AAA-List }

function Folder-Go( [string] $x )  
	{}


function Folder-Reset( [string] $x )  
	{}





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |L|I|S|T|
#


function List- { AAA-List }




# Standard list is a List>String>
function List-Load( $xList )
	{ 
	Get-Content -Path  ("{0}\_data\{1}" -f $AAA.AAA, $xList )	
	Return
	}



function List-Save( $xList )
	{
	Set-Content -Path ("{0}\_data\{1}" -f $AAA.AAA, $xList )	
	}





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |M|O|D|U|L|E|S
#
function Modules- { AAA-List }


function Module-List
	{
	Get-Command *module*
	}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |NE|T|W|O|R|K|
#


function Net- { AAA-List }


function Net-Scan { IP-Scan }

function Network- { AAA-Warn( "Use net-*" ) }


function Net-iSCSI { AAA-Warn( "Use iSCSI-*" ) }


function Net-IP { AAA-Warn( "Use IP-*" ) }




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# |P|N|P|
#

function PNP-  { AAA-List }


function PNP-List 
	{ 
	Get-WmiObject -Class Win32_PnpEntity | Select-Object -ExpandProperty caption
	}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |P|O|W|E|R|S|H|E|L|L|
#

function Powershell- { AAA-Warn( "Use PS-*" ) }




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |P|R|O|C|E|S|S|
#


function Process-  { AAA-List }


function Process-Info( $x )
	{
	
	}

function Process-XXX()
	{ 
	Get-Process | Where-Object { $_.Name -eq "explorer" }
	
	}





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |P|S|
#


function PS- { AAA-List }


function PS-Commands( $x="*" )   { Get-Command -Type Cmdlet -Name $x }

function PS-Functions( $x="*" )  { Get-Command -Type Function -Name $x }

function PS-Scripts( $x="*" )	  { Get-Command -Type ExternalScript -Name $x }

function PS-Parameters( $x="*" ) { Get-Command -ParameterName $x }

function PS-Modules( $x="*" )	  { Get-Module -Name $x }



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |R|E|G|I|S|T|R|Y|
#



function Registry-  { AAA-List }


function Registry-HKLM() { regjump.cmd HKLM }		# HKEY_LOCAL_MACHINE


function Registry-HKCR() { regjump.cmd HKCR }		# HKEY_CLASSES_ROOT


function Registry-HKU() { regjump.cmd HKU }			# HKEY_USERS


function Registry-HKCU() { regjump.cmd HKCU }		# HKEY_CURRENT_USER


function Registry-HKCC() { regjump.cmd HKCC }		# HKEY_CURRENT_CONFIG



function Registry-Go( [string] $x ) 
	{
	if (-not (Test-Path $x)) { return $false }

	regjump.cmd $x
	}


function Registry-Add
	( 
	[string] $xKey="HKCU:\xxx", 
	[string] $xName, 
	[string] $xValue 
	) 

	{
	Return "2do"

	if ( (Test-Path $xKey) ) { return $false }
	New-ItemProperty -Path $x -Name $xName -Value $xValue -PropertyType DWORD -Force
	}

function Registry-Remove( [string] $xKey="HKCU:\xxx"	) 
	{
	Return "2do"

	if ( -not (Test-Path $xKey ) ) { return $false }
	New-ItemProperty -Path $x -Name $xName -Value $xValue -PropertyType DWORD -Force
	}




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |S|O|U|N|D|
#

function Sound-  { AAA-List }


function Sound-Beep
	{ 
	[System.Console]::beep( 111, 11)
	[System.Console]::beep( 222, 22)
	[System.Console]::beep( 333, 33)
	[System.Console]::beep( 444, 44)
	}

function Sound-Plim
	{ 
	[System.Console]::beep( 2222, 222)
	}

function Sound-Plum
	{ 
	[System.Console]::beep( 111, 111)	
	}

function Sound-Speak( [string] $x )
	{ 	}







# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |U|S|B|
#

function USB-  { AAA-List }







# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |U|S|E|R|
#
function User-IsAdmin() 
	{
	$x = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent() 
	$x.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator )
	}




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |W|I|N|D|O|W|S|
#



function Windows- { AAA-List }


function Windows-License- { AAA-List }

function Windows-LicenseBySLMgr()
	{
	# slmgr.vbs /ipk NPPR9-FWDCX-D2C8J-H872K-2YT43
	# CScript.exe
	# slmgr.vbs /ipk <new-key>

	# Version
	slmgr.vbs /dlv

	# Information
	slmgr.vbs /dli


	# Expiration 
	slmgr.vbs /xpr

	}


function Windows-LicenseByWMI()
	{
	wmic.exe path SoftwareLicensingService get OA3xOriginalProductKey
	}


function Windows-Update- { AAA-List }

function Windows-Update-Log {  }

