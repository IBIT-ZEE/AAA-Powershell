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
# Get-EventLog 
# Get-WinEvent
# Get-Event
#
#
<#

>zeeLogs.csx

#>

function Event- { AAA-Functions }


function Event-All- { AAA-Functions }

<#
.SYNOPSIS
Show first N/10 events of a specific lof

#>
function Event-All-First( [int] $x=10 ) 
	{
	# oldest <n>
	}


function Event-All-Last( [int] $x=10 ) 
	{
	# newest <n>
	}


<#
.SYNOPSIS
Show a resume of all logs that have events

#>
function Event-All-List()
	{
	Get-EventLog -List
	}



<#
.SYNOPSIS
Show a the list of all Windows logs

#>
function Event-All-ListX()
	{
	Get-winEvent -ListLog *
	}




<#
.SYNOPSIS
Last N events (newest)
from the the Application log
#>
function Event-Application-First( [int]$x=10 ) 
	{
	# oldest <n>
	Get-EventLog -LogName Application -Newest $x
	}


<#
First N events (oldest)
from the the Application log
#>
function Event-Application-Last( [int]$x=10 ) 
	{
	Get-WinEvent -LogName Application -Oldest -MaxEvents 10
	# Get-EventLog -LogName Application -Newest $x
	}



function Event-Log- { AAA-Functions }



function Event-System-All()
	{
	Get-EventLog -LogName System
	}


function Event-Store- { AAA-Functions }


<#
Show all event-store names that has events (recordCount > 0)
#>
function Event-Store-Any()
	{
	Get-WinEvent -ListLog * | Where-Object {$_.RecordCount -gt 0}
	}


# CLEAR STANDARD LOGS (Application System Security ...)
function Event-Store-Clear()
	{
	$x = Get-EventLog -List 
	
	"Clearing standard logs..."
	foreach( $e in $x)
		{
		echo $e.Log;
		Clear-EventLog -LogName $e.log
		}

	}


<#
.SYNOPSIS
$xxx=  (Get-WinEvent -ListLog * | Where-Object { $_.recordcount -gt 0 }).logname

#>
function Event-Store-ClearX()
	{

	$x = Get-WinEvent -ListLog *

	"Clearing Windows extended logs..."
	foreach( $e in $x)
		{
		echo $e.LogName;
		[System.Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.ClearLog( $e.LogName )
		}
	}


function Event-Store-ClearByWEvtUtil()
	{
	$x = wevtutil.exe el
	$x | ForEach-Object  {"Clearing...", $_; wevtutil cl $_; "Cleared!`n`n"  }

	# check
	$x | ForEach-Object  {wevtutil qe $_ }
	}


function Event-Store-ClearFiles()
	{
	#1 stop event service
	#2 remove all files in events path
	#3 start service
	}


# EMPTY
function Event-Store-Empty()
		{
		Get-WinEvent -ListLog * | Where-Object {$_.RecordCount -eq 0}
		}




<#
?InstanceId 1073748869
?event id 7045
#>
function Event-Programs-Hidden
	{
	// Get-EventLog -LogName System -InstanceId 1073748869
	Get-EventLog -LogName System | Where-Object { $_.EventID = 7045 } | formaat-table -Wrap
	}



	
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |F|I|L|E|
#


function File- { AAA-Functions }



function File-ACLCheck()
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



<#
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

#>
function File-Path- { AAA-Functions }



<#
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
	$x = Get-ItemProperty
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
# |F|O|L|D|E|R|S|
#

function Folder- { AAA-Functions }

function Folder-Go( [string] $x )  
	{}


function Folder-Reset( [string] $x )  
	{}





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |G|U|I|
#
#
<#


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


function Process-  { AAA-Functions }


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

function Service-  { AAA-Functions }


<#
List services name/DisplayName
#>
function Service-Names ( $xGrep )
	{ 
	# search for filter in NAME & DISPLAYNAME
	$x = `
		Get-Service `
			| Where-Object { $_.name -match $xGrep -OR $_.DisplayName -match $xGrep } `
			| Sort-Object -Property status

	$x | ForEach-Object { String-Edge $_.displayname  ( "{0} {1} {2,-10}" -f $_.name, $_.status, $_.starttype ) }
 	}


<#
List services name/executable
using WMI for information not available in Get-Service
#>
function Service-Paths ( $xGrep )
	{
	# search for filter in NAME & DISPLAYNAME
	Get-WmiObject win32_service `
		| Where-Object { $_.name -match $xGrep -OR $_.DisplayName -match $xGrep } `
		| Sort-Object -Property state `
		| Format-Table -HideTableHeaders -AutoSize -GroupBy State -Property PathName, Name
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


