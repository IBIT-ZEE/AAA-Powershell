<###############################################################################

AAA Module


Import-Module -Name C:\DAT\PowerShell\AAA\AAA-0-Base.psm1 -Force

###############################################################################>


# PREPARE ENVIRONMENT 
Set-StrictMode -Version 5.0;
#$Host.PrivateData.ErrorForegroundColor="green"

#ASSEMBLIES
Add-Type -AssemblyName System.Windows.Forms;
Add-Type -AssemblyName System.Speech

#filter Out-Default {}
#Remove-Item function:Out-Default


$global:AAA = @{ 
	System = @{
		Boot       = Get-Date; 
		Credential = $null;
		Editor     = "C:\APL\Microsoft\Code64\Code.exe"
		}
	
	Error = @();

	Folders = @{
		APL = "C:\APL";
		DAT = "C:\DAT";
		SYS = "C:\SYS";
		XXX = "C:\XXX";
		};

	Mail = @{
		Account  = "zee@ibit.lan"
		Password = ""
		Server   = "proxy0"
		# SMTP/POP/IMAP 
		# ?ports 
		# ?SSL/TLS
		# HTML-Template
		# Text-Template
		}
	
	
	}

$global:AAA.Folders += @{
	AAA      = $AAA.Folders.DAT + "\AAA"
	Data     = $AAA.Folders.DAT + "\AAA\Data"
	Links    = $AAA.Folders.DAT + "\#Links"
	LinksX   = $AAA.Folders.DAT + "\#LinksX"
	Scripts  = $AAA.Folders.DAT + "\#Scripts"
	ScriptsX = $AAA.Folders.DAT + "\#ScriptsX"
	Powershell = $AAA.Folders.DAT + "\Powershell"
	}


# ???REFACTOR $AAA.key.*
$global:AAAX = @{
	
	Modules = @{
		Base   =  $AAA.Folders.DAT + "\PowerShell\AAA\AAA-0-Base.psm1";
		System =  $AAA.Folders.DAT + "\PowerShell\AAA\AAA-1-System.psm1";
		Extensions =  $AAA.Folders.DAT + "\PowerShell\AAA\AAA-2-Extensions.psm1";
		Other  =  $AAA.Folders.DAT + "\PowerShell\AAA\AAA-3-Other.psm1";
		};

	Keys = @{  
		Left  = 37;
		Up    = 38;
		Right = 39;
		Down  = 40;
		Enter = 13;
		Space = 32;
		Home  = 36;
		End   = 35;
		};

	Colors = @{
		Ink   = $host.ui.RawUI.ForegroundColor;
		Paper = $host.ui.RawUI.BackgroundColor;
		};

	Dataset = {};

	}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |A|A|A|
#


<#
.SYNOPSIS
Show all AAA- Namespace funcionality
#>
function AAA- { AAA-Functions }


<#
--------------------------------------------------------------------------------
.SYNOPSIS
Present a Text message to the user

Accept 
. a single string
. a Array of trings

.NOTES
AAA-Alert "1 22 333"
AAA-Alert 1, 22, 333

REFACTOR***
SIMPLIFY
PSEUDO-FUNCTION-OVERLOAD
DECORATOR STRING AUTO-CHANGE
for String and String[] ~> if ( $xData -is [array] ) { } else { }
--------------------------------------------------------------------------------
#>
function AAA-Alert( $xData ) 
	{
	Sound-Plim;

	$xPattern = Strings-Pad-Center ( Pattern-Stair "*" 5 );
	$xData = Strings-Pad-Center $xData -xSize $Host.UI.RawUI.WindowSize.Width;
	$xPattern
	$xData;
	Array-Invert $xPattern;

	Sound-Plum;
	}



<#
.SYNOPSIS
Alias Add/Replace
Usually called from profile.ps1

.NOTES
See also "Profile.ps1"
#>
function AAA-Alias 
	{

	# LANGUAGE
	#1
	Set-Alias -Scope "global" -Name a -Value Get-alias 
	Set-Alias -Scope "global" -Name v -Value variables

	#2
	Set-Alias -Scope "global" -Name hx -Value historyX
	Set-Alias -Scope "global" -Name hi -Value Invoke-History
	Set-Alias -Scope "global" -Name so -Value Select-Object
	Set-Alias -Scope "global" -Name wo -Value Where-Object

	#3
	Set-Alias -Scope "global" -Name err -Value errorX

	#4
	Set-Alias -Scope "global" -Name vars  -Value variables

	#5+
	Set-Alias -Scope "global" -Name funcs -Value functions
	Set-Alias -Scope "global" -Name servs -Value services
	Set-Alias -Scope "global" -Name alias -Value Get-alias

	# AAA-Links
	Set-Alias -Scope "global" -Name l! -Value links!
	Set-Alias -Scope "global" -Name lx! -Value linksX!
	Set-Alias -Scope "global" -Name s! -Value scripts!	
	Set-Alias -Scope "global" -Name sx! -Value scriptsX!

	# REPLACE
	Set-Alias -Option AllScope -Scope "global" -Name h -Value AAA-History

	}


<#
.SYNOPSIS
If no asterisks contained in $x
then decorate $x with Start+End Asterisk

if $x is null then return "*"

*Prevent: if only numbers passed they are convert to string
#>
function AAA-Asteriskator( [string]$x = "*" ) 
	{
	if ( $x.Contains( "*" ) ){ return $x } else { return "*" + $x + "*" } 
	}



<#
.SYNOPSIS
Returns a Bag/Object
with .Date=Now() and .Obs properties
add aditional properties...
and save as Memory/CSV/JSON/XML/...

.NOTES
minimum property bag for aaa persistent objects
use with export/import-clixml 
or other serialization/persistency method
#>
function AAA-Bag()
	{
	return `
		@{
		Date = Get-Date;
		Obs = "";
		}
	
	}



<#
.SYNOPSIS
Get the comments present immediatly above the function
up to the end of the previous one
acts as a quick-help...
+
ATT*** NOTE*** QUIRKS*** ...
#>
function AAA-Comments( [string]$xName )
	{
	# ?searh in $functions:\*
	# get-item
	# get-module
	# regex to $xName and back to last "}"

	
	}



<#
.SYNOPSIS
Credential grab

#>
function AAA-Credential
	{
	if ( $null -eq $AAA.Credential ) 
		{ $AAA.Credential = Get-Credential };

	return $AAA.Credential;
	}







<#
.SYNOPSIS
Prepare a Debug session for the argumented function

AAA-Debug <function> [-On|-Off]
>Debug@Profile



#>
function AAA-Debug( 
	$xFunction, 
	[switch] $xClear 
	)

	{

	# ?CLEAR DIRECTIVE
	if ( $xClear )
		{  
		"Removing all breakpoints..."
		Get-PSBreakpoint | Remove-PSBreakpoint;
		#EXIT/1
		return
		}

	# no argument
	if ( $null -eq $xFunction )	
		{
		# ?MULTIPLE BREAKPOINTS SET??
		$x = Get-PSBreakpoint;

		if ( $null -eq $x )   { "No breakpoints are active..."; return; }		
		if ( $x -is [array] ) { "Multiple breakpoints are set..."; return; }

		"Debug is activated on funcion call: <{0}>" -f $x.Command ;
		#EXIT/2
		Return
		}

	
	# ELSE 
	# function name is valid
	# SET THE BREAKPOINT
	if ( Get-Command -Name $xFunction -ErrorAction SilentlyContinue	)
		{
		"Debug breakpoint is now set on <{0}>..." -f $xFunction
		Set-PSBreakpoint -Command $xFunction
		#EXIT/3
		return;
		}

	"Function/Command <{0}> not found..." -f $xFunction
	#EXIT/-1
	
	}




<#
.SYNOPSIS
Jump to function in the Editor (default is VSCode|AAA.Editor)

AAA-Edit <function>

?argument name
?function-name exists
?get-file ?get-line
!see-module !see-AAA$lib-path
!Invoke VSCode --goto <file>:<line>

#>
function AAA-Edit( [string] $xName )
	{

	# ?did the function exists??
	# we will need to know the module name
	$xFunction = `
		Get-Command `
			-CommandType Function `
			-Name $xName `
			-ErrorAction SilentlyContinue

	# Function does not exists...
	if ( $null -eq $xFunction ) { throw "$xName function does not exist..." }

	# Realize TEXT to seach and the MODULE name
	$xText   = "Function[\s+]{0}" -f $xName
	
	# Search/Filter the Library module/file for the function name
	$x = ( Get-Content $xFunction.Module.Path | Select-String -Pattern $xText )

	if ( $null -eq $x ) { throw "$xName not found..." }

	# Launch AAA/Editor and jump to line
	Start-Process `
		-FilePath $AAA.System.Editor `
		-ArgumentList ( "--goto {0}:{1}" -f $xFunction.Module.Path, $x[0].LineNumber ) `
		-UseNewEnvironment
		;


	}




<#
.SYNOPSIS
Test for existence of ...
* Proof-of-concept for intuitive/explorative expressions

-var		* (default)
-function	* ?null && PS-Function data
+
-file		*
-folder		*


?return
	cumulative ~> =0/1..n
	-or-
	exclusive ~> 1st hit collapses result


#>
function AAA-Exists `
	( 
	[string] $xName, 
	[switch] $Variable,
	[switch] $Function,
	[switch] $File,
	[switch] $Folder
	)
	{
	
	if ( [System.String]::IsNullOrWhiteSpace( $xName ) )
		{
		throw `
			"""
			AAA-Exists
			a Name must be provided... 
			default type is -Variable!
			"""
		}

	# VARIABLE CHECK
	if ( $Variable )
		{ 
		$x = `
			try { Out-Null -InputObject ( invoke-expression ( "$" + $xName )); $true } 
			catch { $false } 

		#QUIRK*** return ( try...  ) *was not working
		return $x;
		}

	# FUNCTION-CHECK
	if ( $Function )
		{
		return `
			( $null -ne (Get-Command -Type Function -Name $xName -ErrorAction SilentlyContinue))
		}

	# FILE-CHECK


	# FOLDER-CHECK


	# ???-CHECK


	}



<#
.SYNOPSIS
List all AAA-* functions
>AAA-Scripts
#>
function AAA-Functions
	{

	# GET NAME OF CALLING FUNCTION
	# ANALISING LAST-CALLER ON THE CALLING-STACK
	$x = ( Get-PSCallStack )[1].FunctionName

	# ?*-ABOUT exits?? && Call it
	$xAbout = $x + "About"
	if ( AAA-Exists $xAbout -Function ){ .( $xAbout ) }

	Get-Command -CommandType function -Name ( "{0}*" -f $x )
	""
	}


<#
.SYNOPSIS
Get Comments sitting before function code
Regex 
. find >\n\s*function\s+$name\s+(
. then backsearch for \n\s*<

.NOTES
about_ActivityCommonParameters
about_Aliases
about_Alias_Provider
...
about_Certificate_Provider
...
about_Enum                            
about_Environment_Provider            
about_Environment_Variables           
about_Escape_Characters               
about_Eventlogs                       
about_Execution_Policies              
about_FileSystem_Provider             
...
about_Format.ps1xml                   
about_Functions                       
about_Functions_Advanced              
about_Functions_Advanced_Methods      
about_Functions_Advanced_Parameters   
about_Functions_CmdletBindingAttribute
about_Functions_OutputTypeAttribute   
about_Function_Provider               
about_Group_Policy_Settings           
about_Hash_Tables                     
about_Hidden                          
about_History                         
about_If                              
about_InlineScript                    
about_Jobs                            
about_Job_Details                     
about_Join                            
about_Language_Keywords               
about_Language_Modes                  
about_Line_Editing
...
about_Parallel                        
about_Parameters                      
about_Parameters_Default_Values       
about_Parameter_Sets                  
about_Parsing                         
about_Parsing_LocTest                 
about_Path_Syntax                     
about_Pipelines                       
about_PowerShell.exe                  
about_PowerShell_exe                  
about_PowerShell_Ise.exe              
about_PowerShell_Ise_exe              
about_Preference_Variables            
about_Profiles                        
about_Prompts                         
about_Properties                      
about_Providers                       
about_PSConsoleHostReadLine           
about_PSModulePath                    
about_PSReadline                      
about_PSSessions                      
about_PSSession_Details               
about_PSSnapins                       
about_Quoting_Rules                   
about_Redirection                     
about_Ref                             
about_Registry_Provider               
about_Regular_Expressions             
about_Remote                          
about_Remote_Disconnected_Sessions    
about_Remote_FAQ                      
about_Remote_Jobs                     
about_Remote_Output                   
about_Remote_Requirements             
about_Remote_Troubleshooting          
about_Remote_Variables                
about_Requires                        
about_Reserved_Words                  
about_Return                          
about_Run_With_PowerShell             
about_Scheduled_Jobs                  
about_Scheduled_Jobs_Advanced         
about_Scheduled_Jobs_Basics           
about_Scheduled_Jobs_Troubleshooting  
about_Sequence                        
about_Session_Configurations          
about_Session_Configuration_Files     
about_Signing                         
about_Simplified_Syntax               
...
about_Updatable_Help                  
...
about_Windows_PowerShell_5.0          
about_Windows_Powershell_5.1          
about_Windows_PowerShell_ISE          
about_Windows_RT
...
about_WQL
...
about_BeforeEach_AfterEach
...
about_should                          
about_TestDrive                       
about_Mdbc                            

about_Scheduled_Jobs                  
about_Scheduled_Jobs_Advanced         
about_Scheduled_Jobs_Basics           
about_Scheduled_Jobs_Troubleshooting  
about_ActivityCommonParameters        
about_Checkpoint-Workflow             

* ?exist in?? ?6.x ?7x
about_ForEach-Parallel                
about_InlineScript                    
about_Parallel                        
about_Sequence          

* WORKFLOWS
about_Checkpoint-Workflow
about_Suspend-Workflow                
about_WorkflowCommonParameters
about_Workflows


* DSC
about_Classes_and_DSC
about_DesiredStateConfiguration
about_DscLogResource



#>
function AAA-Help( $xItem )
	{
	
	$x = 
		"about_", 

		".TYPES", 
		"Types.ps1xml",
		"Type_Accelerators",
		"Type_Operators",
		"Variables",
		"Variable_Provider",
		"Scopes",
		"Using",

		".TEXT",
		"Wildcards",
		"Split",		

		".OPERATORS",
		"Operators",
		"Operator_Precedence",
		"Arithmetic_Operators",
		"Assignment_Operators",
		"Comparison_Operators",
		"Logical_Operators",

		".COLLECTIONS",
		"Arrays",
		"Automatic_Variables",         

		".FLOW",
		"Do",
		"for",
		"foreach",
		"While",
		"Switch",
		"Break",
		"Continue",
		"Throw",		
		"Trap",
		"Try_Catch_Finally",

		".OOP",
		"Classes",
		"Methods",
		"Objects",
		"Object_Creation",

		".LANGUAGE",
		"Command_Precedence",
		"Command_Syntax", 
		"Comment_Based_Help",
		"CommonParameters",
		"Core_Commands",
		"Data_Sections",
		"Debuggers",
		"Locations",
		"Logging",
		"Modules",
		"Mocking",
		"Numeric_Literals",
		"PackageManagement",
		"Pester",
		"Scripts",
		"Script_Blocks",
		"Script_Internationalization",
		"Special_Characters",
		"Splatting",
		"Transactions",
		
		".OS",
		"CimSession",
		"WMI",
		"WMI_Cmdlets",
		"WS-Management_Cmdlets",
		"WSMan_Provider",

		".JOBS",
		"Scheduled_Jobs",
		"Scheduled_Jobs_Basic",
		"Scheduled_Jobs_Advanced",

		".XXX"
	
		;
	
	""

	$x += "Quit...";

	AAA-Alert `
		"2DO*** UNFOLD, REMAINING ITEMS, ... ", `
		"", `
		"Powershell ~> about_*", `
		"";

	$xx = aaa-menu $x;

	if ( $xx -eq $x.length -1 ) { return }

	$xxx = 'about_' + $x[ $xx ];

	Get-Help -Name $xxx -ShowWindow;

	}


<#

type some chars and use F8 to search
#>
function AAA-History( $xMatch )
	{
	return (Get-History | Where-Object { $_.CommandLine -match $xMatch } )
	}


<#

type some chars and use F8 to search
#>
function AAA-HistoryX( [string]$xMatch = "." ) 
	{ 
	Get-History `
		| Where-Object { $_.CommandLine -match $xMatch } `
		| Out-GridView -PassThru `
		| Set-Clipboard ;

	""
	"Clipboard set with..."
	Get-Clipboard
	}

function AAA-Info 
	{
	#  |S|T|A|T|U|S|
	"ZEE/2018 ~ AAA Language adaptations`n"
	"*" * $Host.ui.RawUI.WindowSize.Width

	"ALIAS     ~> alias, delete, print, pause, ..."
	"FUNCTIONS ~> commands(), functions(), scripts(), WMI()/WMIO()..."

	"*" * $Host.ui.RawUI.WindowSize.Width

	Get-PSDrive | Where-Object  {$_.Provider.Name -ne "FileSystem" }
	"`n"

	Get-PSDrive | Where-Object  {$_.Provider.Name -eq "FileSystem" }
	"`n"

	}


<#
***DEPRECATED TO REMOVE
use AAA-Functions for in PS/Console
#>
function AAA-List ( )
	{
	AAA-Functions
	}


<#
if self-command ends with "-" list all siblings
log <command> + <args> to !!!!LOGS/AAA-Run.log

#>
function AAA-Log( [ String[] ]  $x ) 
	{
	Clear-Host
	AAA-Logo
	"`n"

	# $xCaller = (Get-PSCallStack)
	}



function AAA-Logo
	{
"
  //\\==================================================================//\\
 //          /\                                                            \\
//          /__\     ----====::::[[[[ ArteWare/2019 ]]]]::::====----        \\
\\         /\[]/\    ----====::::[[[[ ZEE/PS/.net   ]]]]::::====----        //
 \\       /__\/__\                                                         //
  \\//==================================================================\\//
"
	}



<# 
.SYNOPSIS
Message 

#>
function AAA-Menu( $xOptions = $null, $xGroups = $null ) 
	{
	$x = ( MN-New -xOptions $xOptions -xGroups $xGroups );
	return (Mn-Go $x);

	}



<# 
.SYNOPSIS
Message 

#>
function AAA-Message( $xMessage = "OK to continue..." ) 
	{
	"Use AAA-Alert()"
	}



<# 
.SYNOPSIS
GUI Message dialog assuming/infering optional most usual parameters
	-xMessage = "OK ..." ___ [string]
	-xTitle   = "..." ______ [string]
	-xOptions = 0 __________ >Option
	-xIcon    = 0 __________ >Icon

~Option	: OK | OK/Cancel | Yes/No | Yes/No/Cancel | AbortRetryIgnore | RetryCancel
~Icon	: None | Information | Exclamation | Question | Error

#>
function AAA-MessageX( 
	$xMessage = "OK to continue...", 
	$xTitle = "...", 
	$xOption = 0, 
	$xIcon = 0 
	) 
	{

	# BUTTONS FUNCTIONAL SELECT 
	$xOption = @( `
		[System.Windows.Forms.MessageBoxButtons]::OK,
		[System.Windows.Forms.MessageBoxButtons]::OKCancel,
		[System.Windows.Forms.MessageBoxButtons]::YesNo,
		[System.Windows.Forms.MessageBoxButtons]::YesNoCancel,
		[System.Windows.Forms.MessageBoxButtons]::AbortRetryIgnore
		[System.Windows.Forms.MessageBoxButtons]::RetryCancel
		)[ $xOption ];

	# ICONS FUNCTIONAL SELECT 
	$xIcon = @( `
		[System.Windows.Forms.MessageBoxIcon]::None,
		[System.Windows.Forms.MessageBoxIcon]::Information,		# Asterisk
		[System.Windows.Forms.MessageBoxIcon]::Exclamation,		# Warning
		[System.Windows.Forms.MessageBoxIcon]::Question,
		[System.Windows.Forms.MessageBoxIcon]::Error			# Stop | Hand
		)[ $xIcon ];

	$x = `
		[System.Windows.Forms.MessageBox]::Show( 
			$xMessage,
			$xTitle,
			$xOption,
			$xIcon
			)		

	return $x;

	}




<#
.SYNOPSIS
Return a oProgress

#>
function AAA-Progress( $xPercent = 50 )
	{
	Write-Progress `
		-Activity "Grabbing data..." `
		-Status "Inspecting..." `
		-CurrentOperation "running..." `
		-SecondsRemaining -1 `
		-PercentComplete $xPercent
	}



<#
.SYNOPSIS
FAKE A PROGRESS process from 0..100

#>
function AAA-ProgressFake( $xMS = 1 )
	{
	for ( $x = 0; $x -le 100; $x++ ) 
		{ 
		Write-Progress `
			-Activity "Running..." `
			-Status "$x" `
			-PercentComplete "$x"; 

		Start-Sleep -Milliseconds $xMS 
		}
	}




<#
.SYNOPSIS
Show AAA-Scripts Subspace
#>
function AAA-Script- { AAA-Functions }



<#
.SYNOPSIS
get 1st line comment 

#>
function AAA-Script-Comment( [string]$xScript )
	{
	# read file 1st line
	$xLine = ( Get-Content -Path $xScript -First 1 );

	#cut comment symbol
	return $xLine.Substring( $xLine.IndexOf( " " ) +1 );
	}


<#
.SYNOPSIS
Get <help>...</help> text inside the script

#>
function AAA-Script-Help( [string]$xScript )
	{

	# if no argumented SCRIPTNAME 
	# then grab name of calling script
	if ( [string]::IsNullOrWhiteSpace( $xScript ) ){ $xScript = $MyInvocation.ScriptName }

	# ?script file exists
	if ( -not ( File-Exist $xScript )){ Exit }

	# get FILE in a SINGLE-LINE
	$x = Get-Content -Raw $xScript;
	$x -match '(?s)<#\s*\.SYNOPSIS\s*(.*)\s+#>' | Out-Null
	return $Matches[1];
	# Variables $x; Pause;

	}



<#
Self lister for AAA-* auto-discovery
>AAA-Functions
Folder to seach for sibblings are taken from file fullname
+
DOS/.cmd Powershell/.ps1 Python/.py PERL/.pl PHP/.php ...
#>
function AAA-Script-List
	{

	# must only be invoked from inside a script
	# PSCallStack element #1 is the caller Script metadata
	$xScript = (( Get-PSCallStack)[ 1 ]).ScriptName;

	# $null means not called from inside a SCRIPT
	IF ( $null -eq $xScript )
		{ 
		AAA-Alert `
			"AAA-Scripts-List", `
			"Improper using...", `
			"must only be invoked from inside a script..."

		return $null;
		}

	$xFolder = $xScript | Split-Path -Parent
	$xNameX  = $xScript | Split-Path -Leaf
	$xName   = $xNameX.ToLower().Replace( ".ps1", "" )

	# "^x.*.xxx$" 
	# adding strings with '+' gave some strage results
	# so the option by '-f'
	$xData = @(
		@( 'Batch/.cmd'     , ( '^{0}.*\.cmd$' -f $xName ) ),
		@( 'Powershell/.ps1', ( '^{0}.*\.ps1$' -f $xName ) )
		)

	# Get all files 
	# from the folder where the invoking script reside
	$xAll = Get-ChildItem -Path $xFolder
	$xTotal = $xAll.Length;

	For( $x=0; $x -lt $xData.Length; $x++ )
		{
		$xTitle = $xData[ $x ][ 0 ];
		$xMatch = $xData[ $x ][ 1 ];

		# QUIRK*** force it into an System.Array
		$xFiles = @();
		$xFiles += $xAll | Where-Object { $_.Name -match $xMatch }

		# ATT*** @() is not $null
		# if no matches skip to next iteraction
		if ( $xFiles.Length -eq 0 ) { Continue }

		$xCount = $xFiles.Length;

		$xString = "$xTitle ($xCount/$xTotal)";
		$xString;
		String-Replicate "-" $xString.Length;

		# ***REFACTOR File-Infoline( xFileInfo ) Name/Size/Age/Updated/Attrs ?owner
		$xFiles | `
			ForEach-Object `
				{ `
				String-Edge $_.BaseName `
				( File-Propertyline $_.FullName )`
				};

		""

		}	

	}



<#
Self lister for AAA-Scripts .cmd/.ps1 of the form *- *--

*2implement
1st line comment is short description
:OBS is multiline help

#>
function AAA-Script-ListX( [string]$xMark )
	{
	
	# REFACTOR*** throw to soft-fail...
	if ( $xMark -eq '' ) { throw "´`n`n AAA-ScriptsX $xMark is null...`n`n" }
	
	$xFolder = $AAA.Folders.ScriptsX;
	$xChar = $xMark[0];

	# "^x[^x].*.xxx$"  for .cmd/.ps1
	# "^.*[^x]x.xxx$"  for .cmd/.ps1

	$xData = @(
		@( 'Batch/.cmd -*'     , ( '^{0}[^{1}].*\.cmd$' -f $xMark, $xChar ) ),
		@( 'Batch/.cmd *-'     , ( '^.*[^{1}]{0}\.cmd$' -f $xMark, $xChar ) ),
		@( 'Powershell/.ps1 -*', ( '^({0}|{0}[^{1}].*)\.ps1' -f $xMark, $xChar ) ),
		@( 'Powershell/.ps1 *-', ( '^.*[^{1}]{0}\.ps1$' -f $xMark, $xChar ) )		
		)

	For( $x=0; $x -lt $xData.Length; $x++ )
		{
		$xTitle = $xData[ $x ][ 0 ];
		$xMatch = $xData[ $x ][ 1 ];

		""
		$xTitle;
		String-Replicate "-" $xTitle.Length;
		$xCount = File-List -xFolder $xFolder -xMatch $xMatch;
		"{0} files" -f $xCount;
		}
	
	}





<#
AAA-Random
default is 0..100 
???create AAAX.Random.Min/Max/Step/Seed

Need TYPED <int32> parameters because 
in certain cases Powershell was converting -<N> to a string

used int32.MinValue/MaxValue to emulate $null/NO paramenter passed
#>

function AAA-Random( [int]$xLo = [int]::MaxValue , [int]$xHi = [int]::MinValue )
	{
	# 1. if $xHi is <Minvalue> then $xHi becomes $xLo
	# 2. if $xHi NOW are <MaxValue> (cause $xLo was it/no parameters) 0..100
	# 3. if $xLo > $xHi then swap variables
	if ( $xHi -eq [int]::MinValue ) { $xLo, $xHi = 0, $xLo    }
	if ( $xHi -eq [int]::MaxValue ) { $xLo = 0; $xHi = 100 }
	if ( $xLo -gt $xHi  ) { $xLo, $xHi = $xHi, $xLo; }

	# assure that hi-limmit is ellegible to draw
	$xHi++;

	return Get-Random -Minimum $xLo -Maximum $xHi
	}



<#
Verify and correct a splatter from supplied parameters...
AAA-Splat first argument is always the Operational-Class type
so static/shared constructor can be invoked
pass a template like @{ [oType], p1, p2 }
pass parameter data like  @{ [AV], "c:\" }

validate [oType] or get [oType]::Active (default)

AV-Path .......... get from default/AV-Active
AV-Path o ........ get from designed object
AV-Path o path ... set in designed object
AV-Path path ..... set in default/AV-Active

AV-Scan .......... run in default/AV-Active
AV-Scan o ........ run in designed object
AV-Scan o path ...
AV-Scan o ........

$xTemplate @{ x1 = <oType>, ...  }
$xData     @{ x1 = <oType>, ...  }
$xResult   @{ x1.key = <object>, ...  }

#>
function AAA-Splatter( $xTemplate, $xData )
	{
	#a
	#a1 template/arg0 is alaways a type
	#b2 template restant args determine result @splat

	#b
	#b1 ?is xData/arg0 -of- xTemplate/arg0 type -then- add to xResult/arg0
	#b2 !else get AV-Active and add to xResult/arg0
	#b3 !no default/active ???ERR-or-create???

	#c/loop-consume-args
	#c1 ?is xData/argN -of- xTemplate/argN type -then- add to xResult/argN
	#c2 !else ERR/Fail

	#d
	#d1 return xResult splat
	
	}


<#
Testing data

#>
function AAA-Test-Data
	{
		
	$global:a  = @();
	$global:as = "a", "bb", "ccc", "dddd", "eeeee", "ffffff", "ggggggg";
	$global:an = 1, 22, 333, 4444, 55555, 666666, 7777777;
	$global:h  = @{ one=1; two=22; three=333; four=4444; five=55555; six=666666; seven=7777777; };

	$global:n = 0;
	$global:s = "A ágil raposa castanha saltou sobre o pardo cão pachorrento...";
	$global:x = $null;

	Pattern-Line ; '$a/array'    ; $a  ; '' ;
	Pattern-Line ; '$an/numbers' ; $an ; '' ;
	Pattern-Line ; '$as/strings' ; $as ; '' ;

	Pattern-Line; 
	'$h/Hashtable' ; $h ; '' ;

	Pattern-Line; 
	'$s/String' ; $s ; '' ; 
	'$n/Number' ; $n ; '' ;
	'$x/$null'  ; $x ; '' ;
	
	'';
	
	# BREAK TO REPL MAINTAINING $GLOBALS:*
	Break x123456790;
	}


<#
***DEPRECATED use AAA-Alert
#>
function AAA-Warn( [string] $x ) 
	{

	$a = $x.Length / 5
	
	Sound-Plim

	"  *  " * $a
	" *** " * $a
	"*****" * $a
	$x
	"*****" * $a
	" *** " * $a
	"  *  " * $a
	"`n`n"

	Sound-Plum
	
	}




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |A|R|R|A|Y|
#


<#
.SYNOPSIS
Array functionality

#>
function Array- { AAA-Functions }


<#
.SYNOPSIS
Return a Result-Array of 1st digit from Source-Array
for purpouses of simple Alphabetic organization
or alphaberic Groupify

Used on [MN_]/AAA-Menu
#>
function Array-Alphadigit ( $xArray )
	{
	$xAlpha = @();

	ForEach( $x in $xArray )	{ $xAlpha += $x.Substring(0,1).ToUpper(); } 
	
	return $xAlpha
	}


<#
.SYNOPSIS
TRUE IF $xPos is valid

ATT*** 
   $x[ -1 ] is valid
   $x[ 1.5 ] is rounded to $x[ 2 ]
#>

function Array-Bounds( $xArray, $xPos ) 
	{
	$xPos = [math]::Abs( $xPos );
	if ( $xPos -lt 0 ) { return $false }
	if ( $xPos -gt $xArray.Length-1 ) { return $false }
	return $true;
	}



<#
.SYNOPSIS
Scan the array
Build a 
Build a Result-Array from Source-Array 
of indexes of change Points (inflexions)
#>
function Array-Changepoints( $xArray )
	{
	$xPoints = @();
	$xLast = "";

	for( $x = 0; $x -lt $xArray.Length; $x++ )
		{
		if ( $xArray[ $x ] -ne $xLast) 
			{ 
			$xPoints += $x;
			$xLast =  $xArray[ $x ]
			}
		}

	Return $xPoints
	} 



<#
.SYNOPSIS
Gets a single colum from a multicolumn array 
and returns as a single column array

#>
function Array-Column( $xArray )
	{
	$xTemp = @();
	
	foreach( $x in $xArray ){  }
	}



<#
.SYNOPSIS
?declare

#>
function Array-Declare( $xArray )
	{
	# $a = New-Object 'byte[,]' 2,2
	# $a = New-Object 'string[,,]' 2,2,2
	}



<#
.SYNOPSIS
Up-side-down an array...
Rowwise (columns are not touched)

#>
function Array-Invert( $xArray )
	{

	$xMiddle = [Math]::Floor( $xArray.Length / 2 );
	for( $x = 0; $x -lt $xMiddle; $x++ ) 
		{ 
		$xArray[ $x ], $xArray[ -$x-1 ] = $xArray[ -$x-1 ], $xArray[ $x ];
		}

	# be sure to return an array
	return ,$xArray;

	}

# Loads a table (.dat) into a HashTable
# AAA -> 
#	Strips extra \t
#	Strips extra \crlf
function Array-Load( $xTable )
	{
	# load file
	$x = Get-Content -Path $xTable;

	# remove empty lines
	$xx = $x.Where( { $_ -ne "" } )

	# Strip multiple \t
	$xx = foreach( $e in $xx ) { $e -replace "`t+", "`t" }

	# Make a hashtable from the String.Array
	# headers (field names) are in the 1st row
	$xx = $xx | ConvertFrom-Csv -Delimiter "`t"
	
	# Return this
	return $xx 
	}



# Saves a HashTable into a table (.dat) 
function Array-Save()
	{
	
	}


# CIRCULAR
# RETURN
#     $xPos if match
#     -1 is no match ( ?REFACTOR to ?-1 )
#
function Array-ScanNext( $xArray, $xElement, [int]$xPos = 0 )
	{
	$xSize = $xArray.Length;

	# VACCINES
	# SILENTLY RESET INDEX POSITION IF INVALID
	if ( -not ( Array-Bounds $xArray $xPos )) { $xPos = 0  };

	for( $x = 0; $x -lt $xSize; $x++ )
		{
		$xIndex = ($xPos + $x) % $xSize
		if ( $xArray[ $xIndex ] -like $xElement ) { return $xIndex }
		}

	return [int]-1;
	}



#CIRCULAR	
function Array-ScanPrevious( $xArray, $xElement, [int]$xPos = 0 )
	{

	$xSize = $xArray.Length;
	
	# VACCINES
	# SILENTLY RESET INDEX POSITION IF INVALID
	if ( -not ( Array-Bounds $xArray $xPos )) { $xPos = $xSize; };

	for( $x = $xSize; $x -gt 0; $x-- )
		{
		$xIndex = ($xPos + $x) % $xSize
		if ( $xArray[ $xIndex ] -like $xElement ) { return [int]$xIndex }
		}
	
	return [int]-1;
	}



<#
Sort an Array
Faster then Sort-Object

ATT** REFACTOR
Clone to avoid mutating the paramenter until best solution is found
skip overloading functions but elements should be all of the same type
or STRAGENESS will appear

alternative...
[linq.enumerable]::orderby( [int[]]$, [func[int,int]]{ $args[0] } )
[linq.enumerable]::orderby( [string[]]$, [func[string,string]]{ $args[0] } )
#>
function Array-Sort( $xArray )
	{
	$xTemp = $xArray.Clone();
	[System.Array]::Sort( $xTemp );
	return $xTemp;
	}



<#
Drop repetead elements
first fount elements are maintainded
last elements are dropped
#>
function Array-Unique( $xArray )
	{
	return [LINQ.Enumerable]::Distinct( [object[]] $xArray )
	}


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |B|Y|T|E|S|
#


<#
.SYNOPSIS
Working with bytes...

.NOTES


#>
function Bytes- { AAA-Functions }


<#
.SYNOPSIS
Working with bytes...

.NOTES


#>
function Bytes-xxx 
	{ 
	# to text
	$Bytes = [System.IO.File]::ReadAllBytes($Path)
	[System.Convert]::ToBase64String($Bytes)	

	# to binary
	$Bytes = [System.Convert]::FromBase64String($Text)
	[System.IO.File]::WriteAllBytes($OutputPath, $Bytes)

	}




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |C|O|N|S|O|L|E|
#
<#
.SYNOPSIS
Console functions

#>


function Console- { AAA-Functions }



function Console-Color-Save( $x )
	{ $x.Back, $x.Front = $Host.UI.RawUI.BackgroundColor, $Host.UI.RawUI.ForegroundColor; }


function Console-Color-Invert()
	{
	$x, $xx = $Host.UI.RawUI.BackgroundColor, $Host.UI.RawUI.ForegroundColor;
	$Host.UI.RawUI.BackgroundColor, $Host.UI.RawUI.ForegroundColor = $xx, $x;
	}


function Console-Color-Restore( $x )
	{ $Host.UI.RawUI.BackgroundColor, $Host.UI.RawUI.ForegroundColor = $x.Back, $x.Front; }





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |D|A|T|E|
#
<#
.SYNOPSIS
Date functions

#>
function Date- { AAA-Functions }



<#
.SYNOPSIS
return a AAA-TimespanX (+Years +Months)
from 1 or 2 input dates... 
if only 1 date entered assume !NOW as later date...

#>
function Date-Age( [datetime]$xOld, [datetime]$xNew = (Get-Date) )
	{
	return ( Date-Respan ( $xNew - $xOld ) ); 
	}



<#
.SYNOPSIS
Age string from 1 or 2 dates
if only 1 date entered assume !NOW as later date...

#>
function Date-Aged( [datetime]$xOld, [datetime]$xNew = (Get-Date) )
	{
	[timespan]$xAge = $xNew - $xOld;
	$xSpan = Date-Respan $xAge;

	# REFACTOR***
	# AAA.Dates.Shorttext/Longtext
	# $xNames  = @( "anos", "dias", "horas", "minutos", "segundos" )
	# $xNames = @( "Y:", "M:", "D:", "h:", "m:", "s" )

	return `
		"Y{0:00}:M{1:00}:D{2:00}:h{3:00}:m{4:00}:s{5:00}" `
		-f `
		$xSpan.Years, $xSpan.Months, $xSpan.Days, $xSpan.Hours, $xSpan.Minutes, $xSpan.Seconds
	}



<# 
.SYNOPSIS
Simple age between 2 dates
if only 1 date entered assume !NOW as later date...

[years [months [days [hours [minutes [seconds]]]]]]

#>
function Date-Agely( [datetime]$xOld, [datetime]$xNew = (Get-Date) )
	{ 
	[timespan]$xAge = $xNew - $xOld;
	$xSpan = Date-Respan $xAge;
	$xAgely = "?";

	if     ( $xSpan.Years   -gt 0 )      { $xAgely = "{0,2}+ Years  " -f $xSpan.Years   }
	elseif ( $xSpan.Months  -gt 0 )      { $xAgely = "{0,2}+ Months " -f $xSpan.Months  }
	elseif ( $xSpan.Days    -gt 0 )      { $xAgely = "{0,2}+ Days   " -f $xSpan.Days    }
	elseif ( $xSpan.Hours   -gt 0 )      { $xAgely = "{0,2}+ Hours  " -f $xSpan.Hours   }
	elseif ( $xSpan.Minutes -gt 0 )      { $xAgely = "{0,2}+ Mins   " -f $xSpan.Minutes }
	elseif ( $xSpan.Seconds -gt 0 )      { $xAgely = "{0,2}+ Secs   " -f $xSpan.Seconds }
	elseif ( $xSpan.Milliseconds -gt 0 ) { $xAgely = "{0,2}+ Millis " -f $xSpan.Milliseconds }

	return $xAgely;
	}



<#
.SYNOPSIS
Date for filenames with 16 chars
timeslice up to 1/100 of a second
#>
function Date-Filename ( $xDate = (Get-Date) ) 
	{
	return ( get-date $xDate -Format "yyyyMMddHHmmssff" )
	}



<#
.SYNOPSIS
input a Timespan
output a Hashtable with 
	Years/Months/Days + 
	Hours/Mins/Secs + 
	Millisecs
	dayOfWeek index
	dayOfYear index
	WeekOfYear index
#>
function Date-Respan( $xTimespan )
	{
	# att data.minvalue is 0001.01.01 00:00:00
	# so subtract year 1
	$xDate = [datetime]::MinValue + $xTimespan;

	return @{
		Years	= $xDate.Year -1;
		Months	= $xDate.Month -1;
		Days	= $xDate.Day -1; 
		Hours	= $xDate.Hour; 
		Minutes	= $xDate.Minute; 
		Seconds	= $xDate.Second; 
		Milliseconds = $xDate.Millisecond; 
		#DayOfWeek
		#DayOfYear
		#WeekOfYear
		# [System.Globalization.DateTimeFormatInfo]::CurrentInfo.Calendar.GetWeekOfYear([datetime]::Now,0,0)
		# [Globalization.DateTimeFormatInfo]::CurrentInfo.Calendar.GetWeekOfYear( $d,0,0 )
		# get-date -uformat %V
		}

	}





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |M|A|P
#


<#
.SYNOPSIS
Diverse Mappers like 
	Map01YN ....... 0->No      ; 1=Yes
	Map01TF ....... 0->False   ; 1=True
	MapTFYN ....... $False->No ; True->Yes

	MapAB -> Array1 to Array2

	MapNT -> Number-to-Text (Extense)

#>

function Map- { AAA-Functions }


function Map01YN( $x01        ) { if( $x01 -eq 0 ){ "No" } else { "Yes" }  }
function Map01TF( $x01        ) { if( $x01 -eq 0 ){ "False" } else { "True" }  }
function MapTFYN( $xTrueFalse ) { if( $xTrueFalse -eq $False ){ "No" } else { "Yes" }  }




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |M|A|T|H
#


<#
Sibblings list...
#>
function Math- { AAA-Functions }


<#
Return 
String with best fit in Bytes/KB/MB/GB/TB/PB/...
#>
function Math-Bytes ( $x )
	{
	
	if ($x -gt 1PB ) { return "{0,5:F2} PB" -f ($x / 1PB); }
	if ($x -gt 1TB ) { return "{0,5:F2} TB" -f ($x / 1TB); }
	if ($x -gt 1GB ) { return "{0,5:F2} GB" -f ($x / 1GB); }	
	if ($x -gt 1MB ) { return "{0,5:F2} MB" -f ($x / 1MB); }	
	if ($x -gt 1KB ) { return "{0,5:F2} KB" -f ($x / 1KB); }

	# return "{0,3} --" -f $x; 
	return "{0,5:F2} KB" -f ($x / 1KB);

	}

<#


#>
function Math-Ordinalex( [string]$x )
	{
	if( $x.length -gt 1  ){ if ( $x[-2] -eq "1" ){ return "th" } };
	switch( $x[-1] )
		{ 
		1 { return "st" }; 
		2 { return "nd" }; 
		3 { return "rd" }; 
		default { return "th" }  
		};
	}




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |O|B|J|E|C|T|
#


<#
Sibblings list...
#>
function Object- { AAA-Functions }


<#
Compare object properties
Show the differences
#>
function Object-Compare ( [PSObject] $xBase, [PSObject] $xComp )
	{
	
	# get all base-object + compare-object property names
	# and drop repeats (select unique)
	$xBaseProps = @();
	$xBaseProps += (Get-Member -InputObject $xBase -MemberType Property, NoteProperty).name
	$xBaseProps += (Get-Member -InputObject $xComp -MemberType Property, NoteProperty).name



	}


<#

#>
function Object-isNull( $xObject ) { $null -eq $xObject }


<#
.SYNOPSIS
Nullternative -or- Alternative to Null...

Accept 
. a single string
. a Array of trings

#>
function Object-Nullternative( $xTest, $xAlternative ) 
	{ 
	if ( $null -eq $xTest ) { $xTest = $xAlternative } 
	}



<#
.SYNOPSIS
Rewritten for PS5 using iif(x,a,b) instead of PS7/x?a:b

Reports the object content

#>
function Object-View( $xObject ) 
	{ 

	# DONT TEST NULLs
	if ( $null -eq $xObject ) { AAA-Alert "<NULL>"; return; } 

	$xObject.psobject.Properties `
		| Sort-Object membertype `
		| ForEach-Object `
			{ `
			[pscustomobject]@{ `
				Member = $_.name; `
				Type = $_.membertype; `
				W = iif issettable "Y" ""; `
				I = iif isInstance "Y" "N"; `
				Value = $_.value } `
			} `
		| Format-Table -AutoSize

	<# 
	1. Detect if NULL ~> Exit
	2. Detect if Collection ~> ?recurse
	3. Get $x.PSObject 
	4. Hashtable make from substanced properties
	5. Hashtable make from null properties
	6. Sort
	7. Alphabetize [0, A-Z, _]
	8. Show in grid

	$xData = [ordered] @{};
	$xNull = [ordered] @{};

	$xObject.PSObject.Properties | `
		ForEach-Object `
			{ 
			# if ( $_.value ) { $xData[ $_.name ] = $_.value; } 
			# if ( $_.value ) { $xData.Add( $_.name, $_.value ) } 
			if ( $_.value ) { $xData.Add( $_.name, $_.value ) } 
			else { $xNull.Add( $_.name, "<null>" ) }
			}

	return $xData + $xNull;
	# Out-GridView -InputObject $xData
	#>

	}
	





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |T|E|X|T|
#
#

<#
.SYNOPSIS
Text routines...

.NOTES
Encode/Decode
Base64
zXCrypt

...




#>
function Text- { AAA-Functions; }


<#
.SYNOPSIS

#>
function Text-Encode 
	{  
	"2DO***"
	}


<#
.SYNOPSIS

#>
function Text-Decode
	{  
	"2DO***"
	}



<#
.SYNOPSIS
Convert to base64

#>
function Text-toBase64( [string] $xText )
	{  
	$x = [System.Text.Encoding]::ASCII.GetBytes( $xText );

	}


<#
.SYNOPSIS
Convert from base64

#>
function Text-fromBase64
	{  
	"2DO***"
	# [System.Text.Encoding]::ASCII.GetString( $b )
	}




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |X|X|X|
#
#
<#
.SYNOPSIS.
Quick fixes...
to later re-classify...

#>

<#
.SYNOPSIS.

.NOTES.

#>

function XXX- { AAA-Functions }



<#
.SYNOPSIS.
Detect if a variable exists (was defined)
ATT*** pass the variable name without $ prefix

.NOTES.
it is a not existent variable
not the same as a existent variable with the value $null

#>
function XXX-ExistVariable( $x )
	{ 
	$null = Get-Variable -Name $x -ErrorAction SilentlyContinue; 
	if ($?) { return $true} else {return $false}
	}


<#
.SYNOPSIS.
Launch session in new console

.NOTES.

#>
function XXX-SessionConsole( $xPC=".", $xUser="OEM"  )
	{
	# $xPowershell = (Get-Process -id $pid).Path;
	
	Start-Process `
		-FilePath Powershell.exe `
		-ArgumentList ( "-noexit -command Enter-PSSession -ComputerName {0} -Credential {1}" -f $xPC, $xUser );
	
	}



<#
.SYNOPSIS.
Launch session in new console

.NOTES.

#>
function XXX-SessionConnection( $xPC=".", $xUser="OEM"  )
	{
	New-PSSession -ComputerName $xPC -Credential $xUser
	
	# -ArgumentList ( "-noexit -command Enter-PSSession -ComputerName {0} -Credential {1}" -f $xPC, $xUser );
	
	}

