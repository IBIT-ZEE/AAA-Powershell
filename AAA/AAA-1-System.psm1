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
#  |E|V|E|N|T|
#
# Get-Event
#
#
<#
.SYNOPSIS
Events triggerd by ...

#>
function Event- { AAA-Functions }





<#
.SYNOPSIS
Ongoing Events
triggerd by ...


#>
function Event-List() 
	{ 
	"2DO***"
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
#  |L|O|G|
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
Logs...
>zeeLogs.csx

Get-EventLog 
	-logname == -list	~> Stores .entries .retentiondays
	-newest
	-before/-after
	-EntryType

Get-WinEvent

Log-GUI-EventsbBySize
Log-GUI-EventsbByTime
Log-GUI-EventsbByOther
	Get-WinEvent
		-listlog *
		| Select-Object -Property `
			LogName, RecordCount, FileSize, LogFilePath
			LogName, LastAccessTime, LastWriteTime, OldestRecordNumber
			LogName, LogType, IsEnabled, LogIsolation, IsClassicLog, ProvidersNames

//TEST/GET-WINEVENT
Get-WinEvent -ListLog *
Get-WinEvent -Listprovider * -ErrorAction SilentlyContinue
(Get-WinEvent -Listprovider "Microsoft-Windows-GroupPolicy" ).events
$xDate = Get-Date -Hour 0 ; (Get-WinEvent -FilterHashtable @{ logname="security"; starttime = $xDate })[-1] | fl *
Get-WinEvent -FilterHashtable @{ logname="Microsoft-Windows-GroupPolicy*";  } | Group-Object { $_.id } 
Get-WinEvent -FilterHashtable @{ providername="Microsoft-Windows-GroupPolicy";  } 


#>
function Log- { AAA-Functions }



<#
.SYNOPSIS
Event Cleanining...

#>
function Log-Clear-{ AAA-Functions }


<#
.SYNOPSIS
Clear logs (Application, System, Security, ...)
using Clear-EventLog -LogName <log>

#>
function Log-Clear-Basic()
	{
	$xStores = Get-EventLog -List
	
	Write-Progress -Activity "Clearing Standard Logs..." -Status "." -PercentComplete 0

	$x  = 100 / $xStores.Count
	$xx = 0

	foreach( $e in $xStores )
		{
		Write-Progress `
			-Activity "Clearing Standard Logs..." `
			-Status $e.Log `
			-PercentComplete ( $xx += $x )

		Clear-EventLog -LogName $e.Log;

		Start-Sleep 1;
		}

	}


<#
.SYNOPSIS
Clear by log
using .net
[System.Diagnostics.Eventing.Reader.EventLogSession]
	::GlobalSession.ClearLog( $e.LogName )

#>
function Log-Clear-dotNet()
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
function Log-Clear-Files()
	{
	#1 stop event service
	#2 remove all files in events path
	#3 start service
	}



<#
.SYNOPSIS
Clear logs using system "wevtlog.exe" command functionality
#>
function Log-Clear-WEvtUtil()
	{
	$xLogs = wevtutil.exe el
	$xLogs | ForEach-Object  {"Clearing...", $_; wevtutil cl $_; "Cleared!`n`n"  }

	# check
	$xLogs | ForEach-Object  {wevtutil qe $_ }
	}


<#
.SYNOPSIS
Filter logs... (Filter)

#>
function Log-Filter-(){ AAA-Functions }



<#
.SYNOPSIS
Filter logs... 
Query with a composable filter

#>
function Log-Filter( $xFilter )
	{ 
	"***2implement..."

	}


<#
.SYNOPSIS
Filter by level
	Critical | Warning | Verbose | Error | Information


#>
function Log-Filter-Level(  )
	{ 
	"***2implement..."

	}





<#
.SYNOPSIS
Find in logs... (Filter)

#>
function Log-Find-(){ AAA-Functions }



<#
.SYNOPSIS
Find First 1|n events (oldest)
#>
function Log-Find-First-(){ AAA-Functions }

<#
.SYNOPSIS
Find... -aka- Filterings

#>
function Log-Find( $xStore, $xFilter )
	{ 
	"***2implement..."

	}



<#
.SYNOPSIS
First/Oldest 1|n events (newest)
from the the Application log

#>
function Log-Find-First( $xLog, [int]$xCount=1 ) 
	{ 
	# return Get-EventLog -LogName $xLog -Newest $xCount 
	return Get-WinEvent	 -LogName $xLog -MaxEvents $xCount
	}



<#
.SYNOPSIS
Filtering First 1|n events (oldest) from ??? log
#>
function Log-Find-First-Application( [int]$xCount=1 ) { return Log-Find-First -xLog "Application" -xCount $xCount }
function Log-Find-First-Security( [int]$xCount=1 )    { return Log-Find-First -xLog "Security" -xCount $xCount }
function Log-Find-First-Setup( [int]$xCount=1 )    { return Log-Find-First -xLog "Setup" -xCount $xCount }
function Log-Find-First-System( [int]$xCount=1 )    { return Log-Find-First -xLog "System" -xCount $xCount }


<#
.SYNOPSIS
Find Last 1|n events (oldest)
#>
function Log-Find-Last-() { AAA-Functions }


<#
.SYNOPSIS
Filtering Last 1|n (newest) from ??? log
#>
function Log-Find-Last( $xLog, [int]$xCount=1 ) 
	{ return Get-WinEvent -LogName $xLog -Oldest -MaxEvents $xCount }



<#
.SYNOPSIS
Last 1|n events (oldest) from the the Application log
#>
function Log-Find-Last-Application( [int]$xCount=1 ) { return Log-Find-Last -xLog "Application" -xCount $xCount }
function Log-Find-Last-Security( [int]$xCount=1 )    { return Log-Find-Last -xLog "Security" -xCount $xCount }
function Log-Find-Last-Setup( [int]$xCount=1 )       { return Log-Find-Last -xLog "Setup" -xCount $xCount }
function Log-Find-Last-System( [int]$xCount=1 )      { return Log-Find-Last -xLog "System" -xCount $xCount }



<#
.SYNOPSIS
Empty stores
#>
function Log-Find-Empty-Stores()
	{ Get-WinEvent -ListLog * | Where-Object { $_.RecordCount -eq 0 } }



<#
.SYNOPSIS
List non empty stores
stores that has at leat 1 event recorded...
#>
function Log-Find-Populated-Stores()
	{ Get-WinEvent -ListLog * | Where-Object { $_.RecordCount -gt 0 } }



<#
.SYNOPSIS
Log retrieve
#>
function Log-Get-{ AAA-Functions }



<#
.SYNOPSIS
Get all from log *

#>
function Log-Get-All-( $xLog ) 
	{ 
	Get-EventLog -LogName Application 
	}



<#
.SYNOPSIS
Application events...
#>
function Log-Get-All-Application() { Get-EventLog -LogName Application }



<#
.SYNOPSIS
Security events...
#>
function Log-Get-All-Security() { Get-EventLog -LogName Security }



<#
.SYNOPSIS
All Setup events...
#>
function Log-Get-All-Setup() { Get-EventLog -LogName System      }



<#
.SYNOPSIS
All System events...
#>
function Log-Get-All-System() { Get-EventLog -LogName System      }

<#
.SYNOPSIS
Providers

#>
function Log-Get-All-Providers()
	{
	return Get-WinEvent -ListProvider * -ErrorAction SilentlyContinue `
		| Select-Object * 
	}


<#
.SYNOPSIS
Events Stores list...
Application, System, Security, Setup, ...
Show a the list of all Windows logs

#>
function Log-Get-All-Stores(){ Get-EventLog -LogName *  }




<#
.SYNOPSIS
Events Stores list...
Application, System, Security, Setup, ...
Show a the list of all Windows logs

#>
function Log-Get-All-StoresX(  ){ Get-WinEvent -ListLog *  }



<#
.SYNOPSIS
GUI for Logs
#>
function Log-GUI-{ AAA-Functions }



<#
.SYNOPSIS
GUI/Other
#>
function Log-GUI-Events-All()
	{
	Write-Progress -Activity "Log/All" -Status "Reading..." -PercentComplete 50
	$x = Get-WinEvent -ListLog * | Select-Object * 
	Write-Progress -Activity "Log/All" -Status "Reading..." -PercentComplete 100
	$x | Out-GridView -Title "All events" -PassThru | Format-List
	}



<#
.SYNOPSIS
GUI/Other
#>
function Log-GUI-Events-Application()
	{ 
	Log-Get-All-Application  `
		| Out-GridView -Title "Application events" -PassThru `
		| Format-List
	}



<#
.SYNOPSIS
Providers functionality...

ATT***
Error on passtrough
only works with small lists
with large lists passthrough do not pass the object

#>
function Log-GUI-Providers
	{ 
	Write-Progress -Activity "Providers" -Status "Getting registed..." -PercentComplete 50

	$x = Log-Get-Providers

	Write-Progress -Activity "Providers" -Status "Showing..." -PercentComplete 100
	$x | Out-GridView -Title "Log-Providers" -PassThru
	}




<#
.SYNOPSIS
Events Stores list...
Application, System, Security, Setup, ...
#>
function Log-GUI-Stores ( [switch] $xNoGUI )
	{ 
	#TODO
	#Work in the information to display
	#get data to show into object[] Log ~> Name, MachineName, ...

	$x = Get-EventLog -LogName * | Select-Object * 

	if ( $xNoGUI ) { return $x }

	$x | Out-GridView -Title "Log-Stores" -PassThru

	}




<#
.SYNOPSIS
GUI/Other
#>
function Log-GUI-Stores-Sizes
	{ 
	Get-WinEvent -ListLog * `
		| Select-Object -Property `
			LogName, RecordCount, FileSize, LogFilePath `
		| Out-GridView -PassThru `
		| Format-List

	}


<#
.SYNOPSIS
GUI/Other
#>
function Log-GUI-Stores-Times
	{ 
	Get-WinEvent -ListLog * `
		| Select-Object -Property `
			LogName, LastAccessTime, LastWriteTime, OldestRecordNumber `
		| Out-GridView -PassThru `
		| Format-List

		#LogName, LogType, IsEnabled, LogIsolation, IsClassicLog, ProvidersNames

	}



<#
.SYNOPSIS
GUI/Other
#>
function Log-GUI-Stores-Others
	{ 
	Get-WinEvent -ListLog * `
		| Select-Object -Property `
		 	LogName, LogType, IsEnabled, LogIsolation, IsClassicLog, ProvidersNames `
		| Out-GridView -PassThru `
		| Format-List

	}




<#
.SYNOPSIS
Events Windows Console (.msc)
#>
function Log-GUI-OS{ eventvwr.msc }




<#
.SYNOPSIS
	Hidden-Programs		?event id 7045
	Logins				?InstanceId 1073748869

#>
function Log-Inspect-(){ AAA-Functions }


<#
.SYNOPSIS
?InstanceId 1073748869
?event id 7045
#>
function Log-Inspect-HiddenPrograms
	{
	# Get-EventLog -LogName System -InstanceId 1073748869
	Get-EventLog -LogName System | Where-Object { $_.EventID -eq 7045 } 
	}



<#
.SYNOPSIS
Logins
#>
function Log-Inspect-Logins
	{
	# Get-EventLog -LogName System -InstanceId 1073748869
	Get-EventLog -LogName System | Where-Object { $_.EventID -eq 7045 } | format-table -Wrap
	}


<#
.SYNOPSIS
Logon
#>
function Log-Inspect-Logon
	{
	# Get-EventLog -LogName System -InstanceId 1073748869
	# Get-EventLog -LogName System -Source "Microsoft-Windows-WinLogon" | Where-Object { $_.EventID -eq 7001 } 
	Get-WinEvent -FilterHashtable @{ ProviderName="microsoft-windows-winlogon"; id=7001; }
	}


<#
.SYNOPSIS
Logoff
#>
function Log-Inspect-Logoff
	{
	Get-WinEvent -FilterHashtable @{ ProviderName="microsoft-windows-winlogon"; id=7001; }	
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
#  |NE|T|
#


function Net- { AAA-Functions }

function Net-DNS { AAA-Warn "Use DNS-"  }

function Net-Http { AAA-Warn "Use HTTP-"  }

function Net-iSCSI { AAA-Warn( "Use iSCSI-" ) }

function Net-IP { AAA-Warn( "Use IP-" ) }

function Net-Proxy { AAA-Warn( "Use Proxy-" ) }

function Net-TCP { AAA-Warn( "Use TCP-" ) }

function Net-UDP { AAA-Warn( "Use UDP-" ) }

function Net-URI { AAA-Warn( "Use URI-" ) }

function Network- { AAA-Warn( "Use net-" ) }


<#
.SYNOPSIS
Network adapters information
(NIC)

#>
function Net-NIC- { AAA-Functions }


<#
.SYNOPSIS
View network adapters suported features
Optional Select

#>
function Net-NIC-Features
	{ 
	Get-NetAdapterAdvancedProperty | Out-GridView -Title "Network adapters features" -PassThru
	}


<#
.SYNOPSIS
View network adapters
Optional Select

#>
function Net-NIC-List 
	{ 
	Get-NetAdapter | Out-GridView -Title "Network adapters" -PassThru
	}


<#
.SYNOPSIS
View network adapters statistics
Optional Select

#>
function Net-NIC-Statistics 
	{ 
	Get-NetAdapterStatistics | Out-GridView -Title "Network statistics" -PassThru
	}


<#
.SYNOPSIS
SingleRoot I/O Virtualization information

#>
function Net-NIC-Statistics 
	{ 
	Get-NetAdapterSRIOV | Out-GridView -Title "Network adapters SRIOV" -PassThru
	}






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
Start/Stop/Restart a service...
#>

function Service-Action-  { AAA-Functions }


<#
.SYNOPSIS
Start a service...
#>
function Service-Action-Start ( $xService ){ $xService | Start-Service }


<#
.SYNOPSIS
Stop a service...
#>
function Service-Action-Stop ( $xService ){ $xService | Stop-Service }



<#
.SYNOPSIS
Restart a service...
#>
function Service-Action-Restart ( $xService ){ $xService | Restart-Service }



<#
.SYNOPSIS
List services/enums ?startup-type ?actual-state ?types ?...

#>
function Service-Enum- { AAA-Functions }
function Service-Enum-Start()  { [System.Enum]::GetValues( [System.ServiceProcess.ServiceStartMode] ) }
function Service-Enum-Status() { [System.Enum]::GetValues( [System.ServiceProcess.ServiceControllerStatus] )	}
function Service-Enum-Types()  { [System.Enum]::GetValues( [System.ServiceProcess.ServiceType] ) }


function Service-GUI  { Start-Process -FilePath Services.msc }

function Service-GUIX  { Get-Service | Out-GridView -Title "Services..." -PassThru }






<#
.SYNOPSIS
Equalize all lines

!implement xFill
!implement xAlignment

?do String-Pad ?string ?fill ?aligment
#>
function String-Columnize( [string[]]$xArray, $xSize, $xFill = " " )
	{

	$x = @();

	# ?xSize was argumented?? or realize it!!!
	if ( $null -eq $xSize )
		{ $xSize = $xArray[ (String-Longest $xArray) ].length }

	foreach( $e in $xArray )
		{ $x += String-Pad-Left -xString $e -xFill $xFill -xSize $xSize;  }

	return $x
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
List services name/DisplayName

#>
function Service-List ( $xGrep = "*" )
	{ 

	Get-WmiObject win32_service `
		| Where-Object { $_.name -like $xGrep -OR $_.DisplayName -like $xGrep } `
		| Sort-Object -Property startmode `
		| Group-Object -Property state `
		| ForEach-Object {
			"`n"; `
			$x = $_.group.pathname[ (String-Longest $_.group.pathname) ].length; `
			String-Pad-Center $_.group[0].state "."; `
			"`n";
			$_.group `
				| ForEach-Object `
					{ `
					"{0} {1} {2} " -f `
						( String-Pad-Left -xString $_.pathname -xSize $x ), `
						( String-Pad-Center -xString $_.startmode -xSize 10 ), `
						$_.name `
					} 
			}
 	}



<#
.SYNOPSIS
Actions Start/Stop/Restart

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
List services CLI /Name/Status
by Grouped enum.Status

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
	{ 	
	TTS-Speak( $x )
	}







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
System counters

#>
function Counters-Table
	{
	Get-Counter -ListSet * | Out-GridView -PassThru
	}



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

<#
.SYNOPSIS
System counters

#>
function Task-  { AAA-Functions }


<#
.SYNOPSIS
System counters

#>
function Task-Create { "***2implement"  }



<#
.SYNOPSIS
System counters

#>
function Task-Destroy { "***2implement"  }


<#
.SYNOPSIS
System counters

#>
function Task-Get { "***2implement"  }


<#
.SYNOPSIS
System counters

#>
function Task-List( [switch]$nogui ) { "***2implement"  }






# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |T|R|U|S|T|
#

<#
.SYNOPSIS
Trust system
Creadentials, Certificates, Tokens, ...
Kerberos, LANManager, ...

#>
function Trust-  { AAA-Functions }



<#
.SYNOPSIS
Get a credential
defaults to current user

#>
function Trust-Credential( $xUser = $env:username ) 
	{ 
	$x = Get-Credential -UserName $xUser;
	return $x
	}



<#
.SYNOPSIS
Get a credential
defaults to current user

#>
function Trust-WinRM( ) 
	{ 
	try 
		{ Get-Item WSMan:\localhost } 
	catch 
		{ "WinRM/WSMan is apparently is disabled..." }
	}



	



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


