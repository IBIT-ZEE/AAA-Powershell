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
	AAA-Functions 
@'


See:
		Counters
		Environment
		...
'@
	}







# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |E|V|E|N|T|S|
#
#	STORES	~>	Application Security Setup System Forwarded
#	LOGS	~>	Microsoft, Intel, OpenSSH, Windows Powershell, ...
#
# Get-EventLog 
# Get-WinEvent
# Get-Event
#
#
<#

>zeeLogs.csx

#>
function Event- { AAA-Functions }



<#
.SYNOPSIS
Clear logs (Application, System, Security, ...)
using Clear-EventLog -LogName <log>
#>
function Event-Clear()
	{
	$xStores = Get-EventLog -List 
	
	"Clearing standard logs..."
	foreach( $e in $xStores )
		{
		$e.Log;
		Clear-EventLog -LogName $e.Log
		""
		""
		}

	}


<#
.SYNOPSIS
Clear by log
using .net
[System.Diagnostics.Eventing.Reader.EventLogSession]
	::GlobalSession.ClearLog( $e.LogName )

#>
function Event-ClearX()
	{

	$xLogs = Get-WinEvent -ListLog *

	"Clearing Windows extended logs..."
	foreach( $e in $xLogs )
		{
		$e.LogName;
		[System.Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.ClearLog( $e.LogName )
		}
	}


<#
.SYNOPSIS
Clear by stopping log services,~
and deleting files in ?:\Windows\Logs
ATT*** to folder owner (?System)
#>
function Event-ClearByFiles()
	{
	#1 stop event service
	#2 remove all files in events path
	#3 start service
	}



<#
.SYNOPSIS
Clear logs using system "wevtlog.exe" command functionality
#>
function Event-ClearByWEvtUtil()
	{
	$xLogs = wevtutil.exe el
	$xLogs | ForEach-Object  {"Clearing...", $_; wevtutil cl $_; "Cleared!`n`n"  }

	# check
	$xLogs | ForEach-Object  {wevtutil qe $_ }
	}




<#
.SYNOPSIS
?InstanceId 1073748869
?event id 7045
#>
function Event-Get-HiddenPrograms
	{
	# Get-EventLog -LogName System -InstanceId 1073748869
	Get-EventLog -LogName System | Where-Object { $_.EventID -eq 7045 } 
	}



<#
.SYNOPSIS
Logins
#>
function Event-Get-{ AAA-Functions }



<#
.SYNOPSIS
Logins
#>
function Event-Get-Logins
	{
	# Get-EventLog -LogName System -InstanceId 1073748869
	# Get-EventLog -LogName System | Where-Object { $_.EventID -eq 7045 } | format-table -Wrap
	}



<#
.SYNOPSIS
Events Windows Console (.msc)
#>
function Event-GUI{ eventvwr.msc }




<#
.SYNOPSIS
Show a resume of all logs that have events

#>
function Event-List()
	{
	Get-EventLog -List
	}





<#
.SYNOPSIS

#>
function Event-Log- { AAA-Functions }


<#
.SYNOPSIS
List empty stores
#>
function Event-Log-Empty()
	{
	Get-WinEvent -ListLog * | Where-Object { $_.RecordCount -eq 0 }
	}



<#
.SYNOPSIS
List non empty stores
stores that has at leat 1 event recorded...

#>
function Event-Log-Filled()
	{
	Get-WinEvent -ListLog * | Where-Object { $_.RecordCount -gt 0 }
	}



<#
.SYNOPSIS
Show a the list of all Windows logs

#>
function Event-Log-List()
	{
	Get-WinEvent -ListLog *
	}



<#
.SYNOPSIS
Show most recent 'n' events for all stores
by default last 10 are shown

-nogui to bypass grid-view (*to implement)
#>
function Event-Newest( [int]$xCount=10, [switch]$nogui ) 
	{
	$xStores  = Get-EventLog -LogName *;
	$xEvents  = @();
	$xEventsX = @();

	foreach( $e in $xStores )
	 	{ 
		$xEvents = `
			Get-EventLog -LogName $e.Log -Newest $xCount -ErrorAction SilentlyContinue `
			| Select-Object * ; 

		if ($xEvents -ne $null) { $xEventsX += $xEvents }
		}

	if ( $nogui ) { $xEventsX }

	$xEventsX | Out-GridView -Title "Events-Newest/$xCount" -PassThru;
	}


<#
.SYNOPSIS
Show oldest 'n' events
by default last 10 are shown

#>
function Event-Oldest( [int]$x=10 ) 
	{
	"***2 IMPLEMENT"
	}



<#
.SYNOPSIS
Providesrs functionality...

#>
function Event-Provider- { AAA-Functions }



<#
.SYNOPSIS
Providers functionality...

#>
function Event-Provider-GUI 
	{ 
	Get-WinEvent -ListProvider * | Select-Object * | Out-GridView -Title "Event-Providers" -PassThru
	}





<#
.SYNOPSIS
Stores functionality...
Application, System, Security, Setup, ...
#>
function Event-Store- { AAA-Functions }


<#
.SYNOPSIS
Last N/10 events (newest)
from the the Application log
#>
function Event-Store-Application-All( ) 
	{
	# oldest <n>
	Get-EventLog -LogName Application
	}





<#
.SYNOPSIS
#>
function Event-Store-Empty( ) 
	{
	# oldest <n>
	Get-EventLog -LogName Application
	}



<#
.SYNOPSIS
Last N/10 events (newest)
from the the Application log
#>
function Event-Store-Application-First( [int]$x=10 ) 
	{
	# oldest <n>
	Get-EventLog -LogName Application -Newest $x
	}


<#
First N/10 events (oldest)
from the the Application log
#>
function Event-Store-Application-Last( [int]$x=10 ) 
	{
	Get-WinEvent -LogName Application -Oldest -MaxEvents 10
	# Get-EventLog -LogName Application -Newest $x
	}



<#
.SYNOPSIS
Events Stores list...
Application, System, Security, Setup, ...
#>
function Event-Store-GUI
	{ 
	#TODO
	#Work in the information to display
	#get data to show into object[] Log ~> Name, MachineName, ...
	Get-EventLog -LogName * | Select-Object * | Out-GridView -Title "Event-Stores" -PassThru
	}



<#
.SYNOPSIS
Events Stores list...
Application, System, Security, Setup, ...
#>
function Event-Store-List 
	{ 
	Get-EventLog -LogName *
	}




function Event-Store-Security-All()
	{
	Get-EventLog -LogName Security
	}




function Event-Store-System-All()
	{
	Get-EventLog -LogName System
	}
	
	
		
	
	
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |F|I|L|E|
#


function File- { AAA-Functions }




<#
.SYNOPSIS
*Moniker ~> File-ACL-Get

#>
function File-ACL( $xFile )	{ File-ACL-Get $xFile }


<#
.SYNOPSIS
ACL

#>
function File-ACL-Get( $xFile )
	{
	$xEntity = [System.Security.Principal.NTAccount];
	# $xEntity = [System.Security.Principal.SecurityIdentifier]; 

	$x = Get-Acl $xPath;
	$x.GetAccessRules( $true, $true, $xEntity ) 

	# $x.SetAccessRulesProtection( $true, $false ) 

	#	$xSID = $xACL.Access.identityreference 
	#		.translate -> 'S-1-.*' 
	#		.isinherited

	}



	<#
.SYNOPSIS
ACL

#>
function File-ACL-Set( $xFile )
{
# $xEntity = [System.Security.Principal.SecurityIdentifier]; 

$x = Get-Acl $xPath;
# $x.SetAccessRulesProtection( $true, $false ) 
$xAdmin = [System.Security.Principal.NTAccount]::new( "Administrators" );
#	$xSID = $xACL.Access.identityreference 
#		.translate -> 'S-1-.*' 
#		.isinherited

}




<#
.SYNOPSIS

$xFile should be an absolute path 
otherwise will default to the home directory 

#>
function File-Blocked( [string]$xFile )
	{
	$xFile = Resolve-Path $xFile
	try { [IO.File]::OpenWrite( $xFile ).Close(); $False }	catch { $True }
	}


<#
.SYNOPSIS


#>
function File-Copy
	{
	Get-Command *file* -CommandType function
	Get-Command *file* -CommandType cmdlet
	Get-Command *file* -CommandType alias
	}


<#
.SYNOPSIS


#>
function File-Exists( [string]$xFile )
	{
	Test-Path -Path $xFile;
	}



<#
.SYNOPSIS

	???File-Path ???File-Info 
	.Name
	.Extension
	.Parents
	.Drive
	.Full
	?Rights
	?Owner
	?Owner
	?Size
#>

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



<#
.SYNOPSIS

List files from folder
Controled by regex/match
Display Title and #Count/#All
+
***REFACTOR
list by extension and show size/date/... 
with sctring-edge <name> <properties>
#>
function File-List( $xData, $xFolder = $Home )
	{

	# get all files to a List<FileInfo>
	$xAll = Get-ChildItem -Path $xFolder
	$xTotal = $xAll.Length;

	For( $x=0; $x -lt $xData.Length; $x++ )
		{
		$xTitle = $xData[ $x ][ 0 ];
		$xMatch = $xData[ $x ][ 1 ];

		# QUIRK***
		# if a single element is returned then is not a System.Array
		# so force it into an System.Array
		$xFiles = @();
		$xFiles += $xAll | Where-Object { $_.Name -match $xMatch }

		# if no matches skip to next iteaction
		# if ( $null = $xFiles ) { Continue }
		# former wont work because @() is not $null
		if ( $xFiles.Length -eq 0 ) { Continue }

		# QUIRK***  
		# if a single element is returned then is not a System.Array
		# so force it into an array of 1
		# if ( $xFiles -isnot [System.Array] ) { $xFiles = ,$xFiles }

		$xCount = $xFiles.Length;

		$xString = "$xTitle ($xCount/$xTotal)";
		$xString;
		String-Replicate "-" $xString.Length;

		# ATT*** REFACTOR FOR 
		# . File-Infoline( xFileInfo ) Name/Size/Age/Updated/Attrs ?owner
		# . String-Bisection( s1, s2 ) /Trisection( s1, s2, s3 )
		$xFiles | ForEach-Object { String-Edge $_.BaseName  };
		""

		}
	
	Return
	}




<#
.SYMOPSIS

#>
function File-Path- { AAA-Functions }



<#
.SYNOPSIS

0 Invalid
1 File
2 Folder
...
wildcards
-pathType Container/Leaf
-credentials
#>
function File-Path-Type ( $xElement )
	{
	# ? is valid path
	if ( -not ( Test-Path -Path $xElement ) ) { return 0 };

	# ? File/1 or Folder/2
	if ( Test-Path -Path $xElement -PathType Leaf ) { return 1 }

	# if it is not white... ;-)
	return 2

	}




<#
.SYNOPSIS

PSPath/Microsoft.PowerShell.Core\FileSystem::<file>
PSParentPath/Microsoft.PowerShell.Core\FileSystem::<parent>
PSChildName/<file>
PSDrive/<drive>
PSProvider/Microsoft.PowerShell.Core\FileSystem
Mode/<???> -a----
Attributes
VersionInfo/File + InternalName + OriginalFilename + FileVersion + ...
BaseName
Target
LinkType
Name
Length
DirectoryName
Directory
IsReadOnl
Exists
FullName
Extension
CreationTime + CreationTimeUtc
LastAccessTime + LastAccessTimeUtc + LastWriteTime + LastWriteTimeUtc

#>
function File-Properties ( $xFile )
	{
	if ( -not ( File-Exists $xFile ) ){ return $null }
	$x = Get-ItemProperty -Path $xFile
	return $x;
	}


function File-Read( [string]$xFile )
	{
	# collection of string
	[System.IO.File]::ReadAllBytes( (Resolve-Path $xFile) )
	}

function File-ReadAsText( [string]$xFile )
	{
	# collection of strings
	# full-path or tries to get file in System32
	[System.IO.File]::ReadAllText( (Resolve-Path $xFile) )
	}

function File-ReadAsLines( [string]$xFile )
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


<#
$x = [system.diagnostics.fileversioninfo]::getversioninfo( <fullpath> )

#>
function File-Version( $xFile )
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
#
#  |F|O|L|D|E|R|
#
#
<#
.SYNOPSIS
Folder utilities...

#>
function Folder- { AAA-Functions }


<#
.SYNOPSIS
Folder ACL...

#>
function Folder-ACL-Get( $xFolder )
	{
	$xEntity = [System.Security.Principal.NTAccount];
	# $xEntity = [System.Security.Principal.SecurityIdentifier]; 
	
	$xACL = Get-Acl $xFolder;
	$x.GetAccessRules( $true, $true, $xEntity );

	}


function Folder-Go( [string] $x )  
	{

	}


function Folder-Reset( [string] $x )  
	{
	
	}





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |G|U|I|
#
#
<#
.SYNOPSIS

GUI Interface functionality...

#>
function GUI- { AAA-Functions }


<#
State holder
#>
class GUI_Window 
	{
	$Form = $null;
	$Body = $null;

	<#
	1. add component to the Body
	2. try to style-it
	#>
	[System.Windows.Forms.Control] `
	Add( $xControl ) 
		{
		$this.Styler( $xControl );
		$this.Body.Controls.Add( $xControl );	

		# prevent Fluency...
		return $xControl;
		}

	<#
	
	#>
	Show() { $this.Form.ShowDialog(); }

	<#
	1 get component type
	2 if no styler available exit
	3 style the component
	#>
	Styler( $xControl ) 
		{
		$xControl.Backcolor = `
			[System.Drawing.Color]::FromArgb( 
				(Get-Random -Maximum 255), 
				(Get-Random -Maximum 255), 
				(Get-Random -Maximum 255) 
				)

		}

	}


<#
returns a form with hrlders & helpers:
	.Window ... the OS/Form container
	.Body ..... the container render area
	+
	.Build .... accept a control to reside in form and style-it (.Styler)
	.Styler ... accept a control and style-it if style available


$xWindow.Build $xMenu
$xWindow.Build $xStatusBar

$xWindow.Styler $xLabel1
$xWindow.Styler $xTextbox1

#>
function GUI-Window()
	{
	$xWindow = [GUI_Window]::New();

	# FORM
	$xWindow.Form = [System.Windows.Forms.Form]::New();
	$xWindow.Form.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font

	# FLOWLAYOUTPANEL
	$xWindow.Body = [System.Windows.Forms.FlowLayoutPanel]::New()
	$xWindow.Body.BackColor = "#FAFE01";
	$xWindow.Body.Dock = [System.Windows.Forms.DockStyle]::Fill;

	$xWindow.Form.Controls.Add( $xWindow.Body );

	# EVENT MouseWheel Scale
	$xWindow.Form.add_mousewheel( 
		{ 
		$e = [System.Windows.Forms.MouseEventArgs]$_;

		$this.Font = 
			[System.Drawing.Font]::new( 
				$this.Font.FontFamily, 
				$this.Font.Size + ( [System.Math]::Sign( $e.Delta ))  
				)
		})

	
	return $xWindow;
	}



<# CONTROLS #>
function GUI-Button( $xWindow )  { $xWindow.Add( [System.Windows.Forms.Button]::New() ) }
function GUI-Label( $xWindow )   { $xWindow.Add( [System.Windows.Forms.Label]::New() ) }
function GUI-Textbox( $xWindow ) { $xWindow.Add( [System.Windows.Forms.Textbox]::New() ) }
function GUI-Combobox( $xWindow ) { $xWindow.Add( [System.Windows.Forms.Combobox]::New() ) }
function GUI-Listbox( $xWindow ) { $xWindow.Add( [System.Windows.Forms.Listbox]::New() ) }





function GUI-File ( $xFile = "." )
	{
	$xDialog = [System.Windows.Forms.OpenFileDialog]::new();

	# ?arg is file or folder??
	$xType = File-Path-Type $xFile;

	if ( $xType -eq 0 ) { Throw "Invalid path..."  }

	if ( $xType -eq 1 ) 
		{ $xFolder = Split-Path $xFile -Parent  }
	else 
		{ $xFolder = $xFile; $xFile = ""; }

	$xDialog.InitialDirectory = $xFolder;
	$xDialog.ShowDialog();


	return $xDialog.FileNames;

	}


function GUI-Message ( $xMessage )
	{
	$xDialog = [System.Windows.Forms.MessageBox]::Show( $xMessage  )

	$xDialog = $null;
	}




function GUI-Message ( [string] $xMessage, [string[]] $xOptions = @('OK') )
	{

	}

	

function GUI-List ()
	{
	
	}

function GUI-Picker ()
	{
	
	}


function GUI-Grid ()
	{
	
	}


function GUI-Properties-File( [string] $xFile )
	{

	if ( -not ( File-Path-Type $xFile -eq 1 ) ) 
		{ 
		AAA-Alert "Invalid file path..."; 
		return; 
		}

	$xPath   = Resolve-Path -Path $xFile
	$xFile   = Split-Path   -Path $xPath -Leaf; 
	$xFolder = Split-Path   -Path $xPath -Parent;

	$xShell   = New-Object -ComObject Shell.Application;
	$xShellX  = $xShell.NameSpace( $xFolder );
	$xShellXX = $xShellX.ParseName( $xFile );
	$xShellXX.InvokeVerb( "Properties" );

	}


<#

#>
function GUI-Properties-Folder( [string] $xFolder )
	{

	if ( -not ( File-Path-Type $xFolder -eq 2 ) ) 
		{ 
		AAA-Alert "Invalid folder path..."; 
		return; 
		}

	$xPath   = Resolve-Path -Path $xFolder;
	$xShell  = New-Object   -ComObject Shell.Application;
	$xShellX = $xShell.NameSpace( $xPath.ProviderPath );
	$xShellX.Self.InvokeVerb( "Properties" );	
	
	}





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |J|O|B|
#

function Job- { AAA-Functions }



<#

#>
function Job-Kill( $xName = "*" )
	{  
	Remove-job -name $xName -Force
	}



<#

#>
function Job-List( $xName = "*" )
	{  
	Get-Job -name $xName
	}


<#

#>
function Job-New( $xCode = {} )
	{  
	Start-job -ScriptBlock $xCode
	}





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |L|I|S|T|
#


function List- { AAA-Functions }




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
function Modules- { AAA-Functions }


function Module-List
	{
	Get-Command *module*
	}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |NE|T|W|O|R|K|
#


function Net- { AAA-Functions }


function Net-Scan { IP-Scan }

function Network- { AAA-Warn( "Use net-*" ) }


function HTTP- { AAA-Functions }

function Net-iSCSI { AAA-Warn( "Use iSCSI-*" ) }


function Net-IP { AAA-Warn( "Use IP-*" ) }

function Net-Proxy { AAA-Warn( "Use Proxy-*" ) }





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |O|S|
#
#
<#
.SYNOPSIS
OS Related Functionality


#>
function OS-(){ AAA-Functions }




<#
.SYNOPSIS
OS Information (see alse System-info)

Microsoft Windows 10 Pro 10.0.18363, 18363/Multiprocessor Free 64-bit SP=0.0
33397252/28038924 (Memory/Free) 
2019-12-20 20:57:59, 2020-01-23 18:42:03 (Install/Last-Boot)
\Device\HarddiskVolume5 <> \Device\HarddiskVolume4 (Device System <> Boot)
C:Windows, Debug is Off
OS-SKU=48, 00331-10000-00001-AA303
MUILanguages={en-GB, pt-PT}/0809/1252/44/2057
OEM (2/0)

...
Name                                      :Microsoft Windows 10 Pro|C:\Windows|\Device\Harddisk4\Partition1
SystemDirectory                           : C:\Windows\system32
SystemDrive                               : C:
Status                                    : OK
Description                               : 
CreationClassName                         : Win32_OperatingSystem
CSCreationClassName                       : Win32_ComputerSystem
LocalDateTime                             : 2020-01-23 20:32:16
MaxNumberOfProcesses                      : 4294967295
MaxProcessMemorySize                      : 137438953344
SizeStoredInPagingFiles                   : 4980736
TotalSwapSpaceSize                        : 
TotalVirtualMemorySize                    : 38377988
FreeSpaceInPagingFiles                    : 4980736
FreeVirtualMemory                         : 33093656
CSName                                    : ZEE-PC
CurrentTimeZone                           : 0
Distributed                               : False
NumberOfProcesses                         : 167
OSType                                    : 18
OtherTypeDescription                      : 
CSDVersion                                : 
DataExecutionPrevention_32BitApplications : True
DataExecutionPrevention_Available         : True
DataExecutionPrevention_Drivers           : True
DataExecutionPrevention_SupportPolicy     : 2
EncryptionLevel                           : 256
ForegroundApplicationBoost                : 2
LargeSystemCache                          : 
Manufacturer                              : Microsoft Corporation
Organization                              : 
PAEEnabled                                : 
PlusProductID                             : 
PlusVersionNumber                         : 
PortableOperatingSystem                   : False
Primary                                   : True
ProductType                               : 1
OSProductSuite                            : 256
SuiteMask                                 : 272
PSComputerName                            : 
CimClass                                  : root/cimv2:Win32_OperatingSystem
CimInstanceProperties                     : {Caption, Description, InstallDate, Name...}
CimSystemProperties                       : Microsoft.Management.Infrastructure.CimSystemProperties

#>
function OS-Info()
	{
	$xData = Get-CimInstance Win32_OperatingSystem

	"{0} {1} {2}, build {3}, {4}, SP={5}.{6} " -f `
		$xData.Caption, $xData.Version, $xData.BuildNumber, $xData.BuildType, $xData.OSArchitecture, $xData.ServicePackMajorVersion, $xData.ServicePackMinorVersion;
	
	"Memory {0}/{1} (Total/Free)" -f $xData.TotalVisibleMemorySize, $xData.FreePhysicalMemory;

	"Moments {0} / {1} (Installed/Last-Boot)" -f $xData.InstallDate, $xData.LastBootUpTime;

	"Devices {0} <> {1} (System<>Boot)" -f $xData.SystemDevice, $xData.BootDevice;

	"Installed in {0} ~> Debug={1}" -f $xData.WindowsDirectory, ( "Off", "On" )[$xData.Debug];

	"SKU={0}; Serial={1}" -f $xData.OperatingSystemSKU, $xData.SerialNumber; 

	"Language {0}, Locale {1}, Codeset {2}, Country {3}, MUI {4}" -f `
		$xData.OSLanguage, $xData.Locale, $xData.CodeSet, $xData.CountryCode, ($xData.MUILanguages -join "+");

	"Current user is {0}; users {1}; Licensed {2}" -f $xData.RegisteredUser, $xData.NumberOfUsers, $xData.NumberOfLicensedUsers;
	""
	""
	
	}



<#
.SYNOPSIS
Is a OS restart pending?
get info from registry
#>
function OS-PendingRestart()
	{ Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" }





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# |P|A|T|H|
#
#
# Metainformation about files

function Path-  
	{ 
	AAA-Alert `
		"see:", `
		"File-Path-    ", `
		"Registry-Path-", `
		"... "
	}




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# |P|N|P|
#

function PNP-  { AAA-Functions }


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
<#
.SYNOPSIS
Operating System Processes related utilities

#>
function Process-  { AAA-Functions }


<#
.SYNOPSIS
Process(s) command-line invocation
uses Get-CimInstance ( that superseeded Get-WmiObject )
inspecting Win32_Process class
with Filter on Name (like '%$xGrep%'")

#>
function Process-Command( $xGrep = "%" )
	{
	class p0 { $Name; $PID; $CLI } 
	$xDataX = @();
	
	$xProcesses = Get-CimInstance Win32_Process -Filter "Name like '%$xGrep%'"

	foreach( $e in $xProcesses )
		{
		$xData  = [p0]::new();

		$xData.PID     = $e.ProcessID;
		$xData.Name    = $e.Name;
		$xData.CLI     = $e.CommandLine;

		$xDataX += $xData;
		}
	
	$xDataX | Out-GridView -Title "Command-Line" -PassThru;
	}


<#
.SYNOPSIS
???

#>
function Process-GUI( $xGrep = "*" )
	{
	Get-Process -Name ( AAA-Asteriskator $xGrep ) `
		| Select-Object * `
		| Out-GridView -PassThru;
	}


function Process-Get( $xGrep = "*" )
	{ 
	Get-Process -Name ( AAA-Asteriskator $xGrep ) 	
	}


<#
.SYNOPSIS
Process Hoggers
CPU, Memory and Total-Time...

#>
function Process-Hog-  { AAA-Functions }


<#
.SYNOPSIS
Top 10 Processes Hogging CPU...

#>
function Process-Hog-CPU( $xGrep = "*" )
	{ 
	Get-Process -Name $xGrep `
		| Sort-Object -Property CPU -Descending `
		| Select-Object -First 10
	}


<#
.SYNOPSIS
Top 10 Processes Hogging Memory...

#>
function Process-Hog-Memory( $xGrep = "*" )
	{ 
	Get-Process -Name $xGrep `
		| Sort-Object -Property WorkingSet64 -Descending `
		| Select-Object -First 10
	}


<#
.SYNOPSIS
Top 10 Processes cumulative hogging the CPU...

#>
function Process-Hog-Time( $xGrep = "*" )
	{ 
	Get-Process -Name $xGrep `
		| Sort-Object -Property TotalProcessorTime -Descending `
		| Select-Object -First 10
	}


<#
.SYNOPSIS
Kill process(es)
By Name or PID

#>
function Process-Kill-Name( $xGrep = "*" )
	{ 
	
	}

function Process-Kill-PID( $xGrep = "*" )
	{ 
	
	}

	
function Process-List( $xGrep = "*" )
	{
	Get-Process -Name ( AAA-Asteriskator $xGrep ) 
	}


<#
.SYNOPSIS
Pick/GUI a process for further use...

Properties: 
	Name, PID, SessionID, WorkingSet, StartTime/Date-Age, Path/?CLI, StartInfo
	* Threads, Handle, Handles 
	* MainWindowTitle, MainWindowHandle, MachineName
	?Name, CPU, BasePriority
	?Name, UserProcessorTime, TotalProcessorTime, PrivilegedProcessorTime ProcessorAffinity
	?Name, Responding, ExitCode, HasExited
	?Name, Product, ProductDescrition, ProductVersion
	+
	?Paged*
	?NonPaged*
	?Peak*
	?Private*
	?Virtual
	?Standard In/Out/Err
	?+...

	$x = @{ Property = @( "Name", "CPU", "UserProcessorTime" , "BasePriority") }
#>
function Process-Pick( $xGrep = "*" )
	{
	class p0 { $Name; $PID; $Session; $Memory; $Start; $Age } 
	# $xDataX = ,[p0];
	$xDataX = @();
	
	$xProcesses = Get-Process -Name ( AAA-Asteriskator $xGrep )

	foreach( $e in $xProcesses )
		{
		$xData  = [p0]::new();

		$xData.PID     = $e.Id;
		$xData.Name    = $e.Name;
		$xData.Session = $e.SessionId;
		$xData.Memory  = $e.WorkingSet / 1MB;
		$xData.Start   = $e.StartTime;
		$xData.Age     = ( Date-Agely $e.StartTime );

		$xDataX += $xData;
		}
	
	$xDataX | Out-GridView -Title "Picker" -PassThru;
	}



<#
.SYNOPSIS
Process mechanics testing...

Properties: 
	Name, PID, SessionID, WorkingSet, StartTime/Date-Age, Path/?CLI, StartInfo
	* Threads, Handle, Handles 
	* MainWindowTitle, MainWindowHandle, MachineName
	?Name, CPU, BasePriority
	?Name, UserProcessorTime, TotalProcessorTime, PrivilegedProcessorTime ProcessorAffinity
	?Name, Responding, ExitCode, HasExited
	?Name, Product, ProductDescrition, ProductVersion
	+
	?Paged*
	?NonPaged*
	?Peak*
	?Private*
	?Virtual
	?Standard In/Out/Err
	?+...

	$x = @{ Property = @( "Name", "CPU", "UserProcessorTime" , "BasePriority") }
#>
function Process-XXX( $xGrep = "*" )
	{
	class p0 { $Name; $PID; $Session; $Memory; $Age } 
	# $xDataX = ,[p0];
	$xDataX = @();
	
	$xProcesses = Get-Process -Name ( AAA-Asteriskator $xGrep )

	# Get-WmiObject Win32_Process | select commandline

	foreach( $e in $xProcesses )
		{
		$xData  = [p0]::new();

		$xData.PID     = $e.Id;
		$xData.Name    = $e.Name;
		$xData.Session = $e.SessionId;
		$xData.Memory  = $e.WorkingSet / 1MB;
		$xData.Age     = ( Date-Agely $e.StartTime );

		$xDataX += $xData;
		}
	
	$xDataX | Out-GridView -Title "Picker" -PassThru;
	}






# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |P|R|O|X|Y
#
#


function Proxy-  { AAA-Functions }



<#

.SYNOPSIS
Configure the proxy parameters
	address (default is 127.0.0.1) 
	and 
	port (default is 1080)

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v 

#>
function Proxy-Get( )
	{ 
	$xKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

	"Server is {0}"  -f ( Get-ItemProperty -path $xKey ProxyServer ).ProxyServer 
	"Type is {0}"    -f ( Get-ItemProperty -path $xKey ProxyOverride ).ProxyOverride
	"Enabled is {0}" -f ( Map01TF ( Get-ItemProperty -path $xKey ProxyEnable ).ProxyEnable )

	# ProxyUser /t REG_SZ /d username
	# ProxyPass /t REG_SZ /d password
	
	}

function Proxy-Set( $xProxy = 127.0.0.1, $xPort = 1080 )
	{ 
	$xKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

	Set-ItemProperty -path $xKey ProxyEnable   -value 1
	Set-ItemProperty -path $xKey ProxyOverride -Value "<local>"
	Set-ItemProperty -path $xKey ProxyServer   -value $xProxy 
	# ProxyUser /t REG_SZ /d username
	# ProxyPass /t REG_SZ /d password

	}


function Proxy-On
	{ 
	Set-ItemProperty `
		-path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" `
		-Name "ProxyEnable" `
		-value 1
	}


function Proxy-Off
	{ 
	Set-ItemProperty `
		-path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" `
		-Name "ProxyEnable" `
		-value 0
	}





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |P|S|
#


function PS- { AAA-Functions }


function PS-Commands( $x="*" )   { Get-Command -Type Cmdlet -Name $x }

function PS-Functions( $x="*" )  { Get-Command -Type Function -Name $x }

function PS-Scripts( $x="*" )	  { Get-Command -Type ExternalScript -Name $x }

function PS-Parameters( $x="*" ) { Get-Command -ParameterName $x }

function PS-Modules( $x="*" )	  { Get-Module -Name $x }



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |R|E|G|I|S|T|R|Y|
#



function Registry-  { AAA-Functions }


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
#  |S|E|C|U|R|I|T|Y|
#

<#

#>
function Security-  { AAA-Functions }


<#

#>
function Security-Securestring-Set ( [securestring] $x ) 
	{
	
	}


<#

#>
function Security-Securestring-Get ( [securestring] $x ) 
	{ 
	$xBSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR( $x );
	[System.Runtime.InteropServices.Marshal]::PtrToStringAuto( $xBSTR );
	return;
	}


<#

#>
function Security-Credential-Get( [pscredential] $x )
	{
	$x.GetNetworkCredential() | Format-List -Force
	}



<#

#>
function Security-Credential-Set( $xName, $xPassword )
	{
		
	}




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |S|E|R|V|I|C|E|S
#
#
<#
.SYNOPSIS
Services-
	-Name
	-Status ?startup-type ?current-state

#>
function Service-  { AAA-Functions }


<#
.SYNOPSIS
List services name/DisplayName

#>
function Service-Name ( $xGrep )
	{ 
	# search for filter in NAME & DISPLAYNAME
	$x = `
		Get-Service `
			| Where-Object { $_.name -match $xGrep -OR $_.DisplayName -match $xGrep } `
			| Sort-Object -Property status

	$x | ForEach-Object { String-Edge $_.displayname $_.name }
 	}


<#
.SYNOPSIS
List services Command-Line invocation
Groups and Order by Service-State

uses WMI for information not available in Get-Service
#>
function Service-Command ( $xGrep )
	{
	# search for filter in NAME & DISPLAYNAME
	# $x = `
		Get-WmiObject win32_service `
			| Where-Object { $_.PathName -match $xGrep } `
			| Sort-Object -Property state `
			| Format-Table -HideTableHeaders -AutoSize -GroupBy State -Property PathName
	}




<#
.SYNOPSIS
List services ?startup-yype ?actual-state

#>
function Service-Status ( $xGrep )
	{ 
	# search for filter in NAME & DISPLAYNAME
	$x = `
		Get-Service `
			| Where-Object { $_.name -match $xGrep -OR $_.DisplayName -match $xGrep } `
			| Sort-Object -Property status

	$x | ForEach-Object { String-Edge $_.name  ( "{0} {1}" -f $_.starttype, $_.status ) }
 	}

	


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |S|O|U|N|D|
#

function Sound-  { AAA-Functions }


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
#  |S|Y|S|T|E|M|
#
#
<#
.SYNOPSIS
System releated functionality ( devices, ... )

#>
function System-(){ AAA-Functions }





<#
.SYNOPSIS
System releated functionality ( devices, ... )

Get-CimInstance 
	Win32_AssociatedProcessorMemory
	Win32_BaseBoard
	Win32_Battery
	Win32_BIOS
	Win32_ComputerSystem
	+
	Win32_CIMLogicalDeviceCIMDataFile
	Win32_CodecFile
	+
	Win32_ControllerHasHub


>OS-Info()
Get-CimInstance 
	Win32_Account
	Win32_AccountSID
	Win32_BaseService


>+
Get-CimInstance
	Win32_ClassicCOMClass
	Win32_ClassicCOMApplicationClasses
	Win32_ComponentCategory
	Win32_COMSetting
	+
	Win32_CreateFolderAction
	Win32_CurrentProbe
	
#>
function System-Info()
	{ 
	
	}







# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |T|A|S|K|
#

function Task-  { AAA-Functions }


function Task-Create { "***2implement"  }
function Task-Destroy { "***2implement"  }
function Task-Get { "***2implement"  }
function Task-List( [switch]$nogui ) { "***2implement"  }




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |U|S|B|
#

function USB-  { AAA-Functions }







# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |U|S|E|R|
#

function User-  { AAA-Functions }

function User-IsAdmin() 
	{
	$x = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent() 
	$x.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator )
	}




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |W|I|N|D|O|W|S|
#



function Windows- { AAA-Functions }


function Windows-License- { AAA-Functions }

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

<#

#>
function Windows-LicenseByWMI()
	{
	wmic.exe path SoftwareLicensingService get OA3xOriginalProductKey
	}


function Windows-Update- { AAA-Functions }

function Windows-Update-Log {  }







# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |W|M|I|
#
#  Windows Managment Instrumentation
#


function WMI-() { AAA-Functions }

<#
Get-Command -Noun * | Get-Command -Verb *
#>
function WMI-List( $xFilter="*" )        { Get-WmiObject -List $x }


<#

#>
function WMI-Object( $xName="*" )       { Get-WmiObject $x }


