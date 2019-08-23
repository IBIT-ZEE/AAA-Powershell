<###############################################################################

AAA Module


Import-Module -Name C:\DAT\PowerShell\AAA\AAA-0-Base.psm1 -Force

###############################################################################>


# PREPARE ENVIRONMENT 
Set-StrictMode -Version 5.0;
$Host.PrivateData.ErrorForegroundColor="green"
Add-Type -AssemblyName System.Windows.Forms;
#filter Out-Default {}
#Remove-Item function:Out-Default


$global:AAA = @{};

$global:AAA += `
	@{
	Folders = @{
		APL = "C:\APL";
		DAT = "C:\DAT";
		SYS = "C:\SYS";
		XXX = "C:\XXX";
		};
	}

$global:AAA.Folders += `
	@{
	AAA      = $AAA.Folders.DAT + "\AAA"
	Links    = $AAA.Folders.DAT + "\#Links"
	LinksX   = $AAA.Folders.DAT + "\#LinksX"
	Scripts  = $AAA.Folders.DAT + "\#Scripts"
	ScriptsX = $AAA.Folders.DAT + "\#ScriptsX"
	}


# ???REFACTOR $AAA.key.*
$global:AAAX = `
	@{
	Modules = `
		@{
		Base   =  $AAA.Folders.DAT + "\PowerShell\AAA\AAA-0-Base.psm1";
		System =  $AAA.Folders.DAT + "\PowerShell\AAA\AAA-1-System.psm1";
		Extensions =  $AAA.Folders.DAT + "\PowerShell\AAA\AAA-2-Extensions.psm1";
		Other  =  $AAA.Folders.DAT + "\PowerShell\AAA\AAA-3-Other.psm1";
		};

	Keys = `
		@{  
		Left  = 37;
		Up    = 38;
		Right = 39;
		Down  = 40;
		Enter = 13;
		Space = 32;
		Home  = 36;
		End   = 35;
		};

	Colors = `
		@{
		Ink   = $host.ui.RawUI.ForegroundColor;
		Paper = $host.ui.RawUI.BackgroundColor;
		};

	}


function test-xxx
	{
	param()

	$x = 111
	Write-Host "x is $x"
	Read-Host
	}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  AAAX-Fix
#

function AAA-On()
	{
	#  |A|L|I|AS|
	Set-Alias Alias		"Get-Alias"			# Alias command
	Set-Alias Delete	"Remove-Item"
	Set-Alias Print		"Write-Host"
	Set-Alias Input		"Read-Host"
	Set-Alias Pause		"Start-Sleep"		# seconds/-milliseconds
	Set-Alias Wait		"Start-Sleep"		# seconds/-milliseconds
	Set-Alias Help		"Get-Help"
	Set-Alias Processes	"Get-Process"

	#  |K|E|Y|S|
	Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

	# Libraries initialization
	import-module -Scope Global -name 'AAA\AAASystem.psm1' 
	import-module -Scope Global -name 'AAA\AAASystemX.psm1'
	import-module -Scope Global -name 'AAA\AAAOther.psm1'

	# READY audio alert
	[System.Console]::beep( 111, 11)
	[System.Console]::beep( 222, 22)
	[System.Console]::beep( 333, 33)
	[System.Console]::beep( 444, 44)

	}





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |*|
#

function ~() { Set-Location $env:USERPROFILE  }

function _() { AAA-Classes;   }

function AAA-Check()          { return $true }


# Get-Command -Noun * | Get-Command -Verb *
function WMI( $x="*" )        { Get-WmiObject -List $x }

function WMIO( $x="*" )       { Get-WmiObject $x }
# FUNCTIONS +++ repeat(c, x); loop(c); timeout(c); timed(c,i); ...



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |A|A|A|
#



<#
to be replaced with AAA-Functions
#>
function AAA- { AAA-List }



# REFACTOR***
# SIMPLIFY
function AAA-Alert( $xData ) 
	{
	Sound-Plim;

	# PSEUDO-FUNCTION-OVERLOAD
	# for String and String[]
	# if ( $xData -is [array] ) { } else { }

	$xPattern = String-Center ( String-Pattern-Stair "*" 5 );
	$xData = String-Center $xData;
	$xPattern 
	$xData;
	Array-Invert $xPattern;

	Sound-Plum;
	
	}


function AAA-Alias()
	{
	# HISTORY
	Set-Alias -Name hv -Value AAA-History
	Set-Alias -Name hi -Value Invoke-History

	Set-Alias -Name so -Value Select-Object

	}



# minimum property bag for aaa persistent objects
# use with export/import-clixml 
# or other serialization/persistency method
function AAA-Bag()
	{
	return `
		@{
		Date = Get-Date;
		Obs = ""	
		}
	
	}


function AAA-Classes
	{
	# special case list functions
	$x = "*-"
	Get-Command $x -CommandType function
	Get-Command $x -CommandType cmdlet
	Get-Command $x -CommandType alias
	}


# Get the comments present immediatly above the function
# up to the end of the previous one
# acts as a quick-help...
# +
# ATT*** NOTE*** QUIRKS*** ...
function AAA-Comments( [string]$xName )
	{
	# ?searh in $functions:\*
	# get-item
	# get-module
	# regex to $xName and back to last "}"

	
	}



<#
List all AAA-* functions
>AAA-Scripts
#>
function AAA-Functions
	{

	}


# INJECT GROUP-MARKERS IN A SIMPLE ARRAY
# PRIMARY USE IS FOR AAA-MENU
function AAA-Groupify( $xArray, $xGroups )
	{
	$xGrouped = @();
	$xSentinel = "";
	# $xSentinel = "`n" + $xGroups[ 0 ];
	# $xGrouped += "`n" + $xGroups[ $x ];

	for( $x=0; $x -lt $xArray.Length; $x++ )
		{

		if ( $xGroups[ $x ] -ne $xSentinel )
			{
			$xGrouped += "`n" + $xGroups[ $x ];
			$xSentinel = $xGroups[ $x ];
			}

		$xGrouped += $xArray[ $x ];
		}

	return $xGrouped;
	}


# Scan a group column
# Returning group change
function AAA-Groupness( $xGroups )
	{
	$xArray = @();
	$xLast = "";

	for( $x = 0; $x -lt $xGroups.Length; $x++ )
		{
		if ( $xGroups[ $x ] -ne $xLast) 
			{ 
			$xArray += $x;
			$xLast =  $xGroups[ $x ]
			}
		}

	Return $xArray
	} 


function AAA-Help
	{
	AAA-Warn "Get Comments sitting before function code"
	}





function AAA-History 
	{
	Get-History | Out-GridView -PassThru | Invoke-History $_
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
Substitute with 
	AAA-Functions for in PS/Console
	AAA-Scripts   for in CMS/Console (called from ???-.ps1)

#>
function AAA-List ( )
	{
	
	$x = ( Get-PSCallStack )[1].FunctionName
	Get-Command ( "{0}-*" -f $x ) -CommandType function
	
	"`n"

	$x = "*$x*"
	Get-Command $x -CommandType function
	Get-Command $x -CommandType cmdlet
	Get-Command $x -CommandType alias
	}



	# if self-command ends with "-" list all siblings
	# log <command> + <args> to !!!!LOGS/AAA-Run.log
	#
	function AAA-Log( [ String[] ]  $x ) 
	{
	Clear-Host
	AAA-Logo
	"`n"

	# $xCaller[2].invocationinfo.mycommand ?parameters ?...
	$xCaller = (Get-PSCallStack)
	# $xCaller = ( Get-PSCallStack )[1].FunctionName;

	# <aaa-log.cmd>
	# if "%~1"=="" aaa-main %~f0
	#
	# :MAIN
	#       echo ERRORLEVEL%errorlevel% ~ %date%-%time% ~ %cd% >> c:\xxx\!!!!LOGS\aaa-run.log
	#       echo %* >> c:\xxx\!!!!LOGS\aaa-run.log
	#       exit /b
	#
	# :OBS
	#       aaa-log.cmd
	#               Log %errorlevel% ~ %date%-%time% ~ %cd%
	#               and %*
	#               to  aaa-run.log in c:\xxx\!!!!LOGS
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



###############################################################################
# Simple menu
#
#

# return the selected Index
function AAA-Menu( $xOptions, $xGroups = $null )
	{
	$xMenu = [AAA_Menu]::New();
	$xMenu.xOptions = $xOptions;

	# GROUP-BREAKS APPROPRIATION/AWERNESS
	if ( $xGroups ) 
		{
		# REALIZE GROUPS
		$xMenu.xGroups = AAA-Groupness $xGroups 
		foreach( $x in $xMenu.xGroups )	{ $xMenu.xGroupsX += $xGroups[ $x ] }
		}
	else
		{
		# AUTO-GENERATE DEFAULT GROUP (All-Elements)
		$xMenu.xGroups  += 0;
		$xMenu.xGroupsX += $null;
		}
	
	$xMenu.Go();
	return $xMenu.xIndex;
	}

Class AAA_Menu
	{
	$xKey=0;						# [System.ConsoleKeyInfo.key] 
	$xChar=0;						# [System.ConsoleKeyInfo.keyChar] 
	$xKeyPrevious;
	$xOptions = @();			# string[]
	$xCount   = 0;
	$xIndex   = 0;
	$xCursor;
	$xSeparator = "`n";

	$xGroups  = @();			# int[]
	$xGroupsX = @();			# String[]
	
	$keys   = $global:AAAX.Keys;
	$xInk   = $global:AAAX.Colors.Ink;
	$xPaper = $global:AAAX.Colors.Paper;


	# DISPLAY | WAIT-FOR-KEY | ...
	Go()
		{
		$this.xCount  = $this.xOptions.Length;
		$this.xCursor = $global:Host.UI.RawUI.CursorPosition;

		while ( $this.xKey -ne $this.keys.Enter ) 
			{
			$this.Processor();

			$global:host.UI.RawUI.CursorPosition = $this.xCursor;
			$this.Show();

			# Input/get Key code
			# $this.xKey = $global:host.UI.RawUI.ReadKey( "NoEcho,IncludeKeyDown" ).VirtualKeyCode;
			$x = [Console]::ReadKey();
			$this.xKey = [int]$x.Key;
			$this.xChar = $x.keyChar;
			}

		}


	# DISPLAY GROUPS
	Show()
		{
		$xMax = $this.xGroups.Length;

		# GROUPS DISPLAY
		for( $x = 0; $x -lt $xMax; $x++ )
			{
			if ( $this.xGroupsX[ $x ] ) { Write-Host $this.xGroupsX[ $x ] }

			$xRangeLo = $this.xGroups[ $x ];
			$xRangeHi = if ( $x -lt ($xMax-1) ) { $this.xGroups[ $x + 1 ] } else { $this.xCount };

			# OPTIONS/GROUPS DISPLAY
			for( $xx = $xRangeLo; $xx -lt $xRangeHi; $xx++ )
				{
				if ( $xx -ne $this.xIndex ) 
					{
					Write-Host -NoNewLine $this.xOptions[ $xx ];
					}
				else 
					{
					$global:host.ui.RawUI.ForegroundColor = $global:AAAX.Colors.Paper;
					$global:host.ui.RawUI.BackgroundColor = $global:AAAX.Colors.Ink;
					Write-Host -NoNewline $this.xOptions[ $xx ];
					$global:host.ui.RawUI.ForegroundColor = $global:AAAX.Colors.Ink;
					$global:host.ui.RawUI.BackgroundColor = $global:AAAX.Colors.Paper;									
					}
				Write-Host -NoNewLine " ";
				}
			Write-Host "`n";
			}
		}


	# PROCESS USER INPUT
	Processor()
		{
		# VACCINE using number arrays 
		# ( no strings => no .StartsWith() )

		switch( $this.xKey )
			{
			$this.keys.Home  { $this.xIndex = 0                }
			$this.keys.End   { $this.xIndex = $this.xCount - 1 }
			$this.keys.Space { $this.xIndex++  }
			$this.keys.Right { $this.xIndex++  }
			$this.keys.Left  { $this.xIndex--  }
			$this.keys.Up    { $this.PreviousGroup()  } 
			$this.keys.Down  { $this.NextGroup()      }

			# TODO*** REFACTOR TO DEFAULT
			#0..9/A..Z
			Default 
				{
				if ( $this.xChar -eq 0 ) 
					{ Sound-Plim; }
				else
					{
					# VACCINE $xIndex from GETTING NON VALID ordinals
					$this.xIndex++;
					$x = Array-ScanNext $this.xOptions "$($this.xChar)*" $this.xIndex;
					if ( $x -ne -1 ) { $this.xIndex = $x }
					}
			 	}
			}

			if ( $this.xIndex -lt 0               ) { $this.xIndex = $this.xCount - 1 }			
			if ( $this.xIndex -gt $this.xCount -1 ) { $this.xIndex = 0                }

		}
		
	
	# SCAN GROUP-MARKS FOR THE 1ST GRATER THAN OPTION-INDEX
	NextGroup()
		{
		# AT LEAST FIXED '<N>=LAST' GROUP IS ALWAYS HIT
		for( $x = 0; $x -lt $this.xGroups.Length - 1; $x++ )
			{ if( $this.xIndex -gt $this.xGroups[ $x ] ) { continue; } else { break; } }

		# QUIRK: THERE IS NO LAST ELEMENT IN GROUP SECTIONS
		# IF IN LAST GROUP... NEXT WILL BE 0
		if ( $x -eq $this.xGroups.Length - 1 ) 
			{ $this.xIndex = 0 } else { $this.xIndex = $this.xGroups[ $x + 1 ] }
		
		}



	# SCAN GROUP-MARKS FOR THE 1ST LESS THAN OPTION-INDEX
	PreviousGroup()
		{
		# VACCINE: ?IS AT TOP ALREADY THEN GOTO MAX
		if ( $this.xIndex -eq 0 ) { $this.xIndex -eq $this.xCount - 1 }

		# AT LEAST FIXED '0=1ST' GROUP IS ALWAYS HIT
		for( $x = $this.xGroups.Length - 1 ; $x -gt 0; $x-- )
			{ if( $this.xIndex -lt $this.xGroups[ $x ] ) { continue } else { break; }}
		
		$this.xIndex = $this.xGroups[ $x - 1 ]; 
		}

	}



# Option
# 0. OK
# 1. OK/cancel
# 2. Yes/No
function AAA-Message( $xMessage="...", $xTitle="...", $xOption = 0, $xImage = 0 )
	{

	# BUTTONS FUNCTIONAL SELECT 
	$xButtons = @( `
		[System.Windows.Forms.MessageBoxButtons]::OK,
		[System.Windows.Forms.MessageBoxButtons]::OKCancel,
		[System.Windows.Forms.MessageBoxButtons]::YesNo
		)[$xOption];

	# ICONS FUNCTIONAL SELECT 
	$xIcon = @( `
		[System.Windows.Forms.MessageBoxIcon]::Information,
		[System.Windows.Forms.MessageBoxIcon]::Exclamation,
		[System.Windows.Forms.MessageBoxIcon]::Question, 
		[System.Windows.Forms.MessageBoxIcon]::Error
		)[ $xImage ];

	$x = [System.Windows.Forms.MessageBox]::Show( 
		$xMessage,
		$xTitle,
		$xButtons,
		$xIcon
		)
	
	return $x;
	}

function AAA-MessageOK( $x ) { AAA-Message $x }

function AAA-MessageOC( $x ) { AAA-Message $x "OK/Cancel" 1 1; }

function AAA-MessageYN( $x ) { AAA-Message $x "Yes/No" 2 2; }



# FAKE A PROGRESS process from 0..100
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
Self lister for AAA-* auto-discovery
>AAA-Functions
#>
function AAA-Scripts
	{
	# Extensions to treat
	$xData = @( 
		@{ id="Powershell"; Extension="ps1" }, 
		@{ id="Batch";      Extension="cmd" } 
		)

	# Get current script name
	# the name of the script that called this function PSCallStack[1]
	# PSCallStack[0] is this module name
	$xScript = (Get-PSCallStack)[1].ScriptName
	
	# Current folder "List-Here" mode
	# other option would be to hardire to AAA.ScripsX
	$xFolder = $xScript | Split-Path -Parent
	$xName   = $xScript | Split-Path -Leaf
	$xFiles  = $xName.ToLower().Replace( ".ps1", "" )

	foreach( $e in $xData )
		{
		$x = Get-ChildItem -Path ( "$xFolder\$xFiles*.$($e.Extension)" )

		# if not items skip titles
		if ( $x -eq $null ){ continue; }

		$xTitle = "$($e.id)/*.$($e.Extension)";
		$xTitle;
		( "-" * $xTitle.Length );
		$x | ForEach-Object { "`t{0}" -f $_.BaseName }
		""
		}
	
	}



function AAA-Test- { AAA-List }



function AAA-Test-Code( $x1="aaa111", $x2="bbb222", $x3=333, $x4=444 ) 
	{
	if ( $null -eq $x1 ){ $x1 = 111 }
	if ( $null -eq $x2 ){ $x2 = 222 }
	
	$x1
	$x2
	""
	$x3;
	$x4;
	}


# Testing data
function AAA-Test-Data
	{
	$global:a = 1, 22, 333, 4444, 55555, 666666, 7777777;
	$global:h = @{ one=1; two=22; three=333; four=4444; five=55555; six=666666; seven=7777777; };
	$global:s = "A ágil raposa castanha saltou sobre o cão pachorrento...";
	$global:x = 1;

	String-Line;
	'$a/Array';
	$a;
	'';

	String-Line;
	'$h/Hashtable';
	$h;
	'';

	'$s/String';
	'';
	
	'$x';
	$x;
	'';
	
	# BREAK TO REPL MAINTAINING $GLOBALS:*
	Break x123456790;
	}


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

function Array- { AAA-List }

function Array-Declare( $xArray )
	{
	# $a = New-Object 'byte[,]' 2,2
	# $a = New-Object 'string[,,]' 2,2,2
	}



# TRUE IF $xPos is valid
# 
# ATT*** 
#    $x[ -1 ] is valid
#    $x[ 1.5 ] is rounded to $x[ 2 ]
function Array-Bounds( $xArray, $xPos ) 
	{
	$xPos = [math]::Abs( $xPos );
	if ( $xPos -lt 0 ) { return $false }
	if ( $xPos -gt $xArray.Length-1 ) { return $false }
	return $true;
	}


# Gets a single colum from a multicolumn array 
# and returns as a single column array
function Array-Column( $xArray )
	{
	$xTemp = @();
	
	foreach( $x in $xArray ){  }
	}



<#
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

	return $xArray;

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




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |F|I|L|E
#
# ***** SNIPPETS *****
# $x = [system.diagnostics.fileversioninfo]::getversioninfo( <fullpath> )
#


function File-Version( $xFile )
	{
	

	}




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |S|T|R|I|N|G|
#




<#
? Grow 
? Invert sinle/multiple
? Inflate/Deflate
? Clone/Cloner -vs- Replicate ?! single/multiple
? Add/Subtract -vs- Append/Remove

? Strings-* or String overload ??

#>
function String-  { AAA-List }



function String-Add( [string] $xString, [string] $xAdd ) 
	{}



<#
Center <String> or <String[]>
Parameter pattern-string to fill/auto is " "...
Parameter for size/auto is console width...

QUIRKS: Pseudo overload for String or Strings[]
#>
function String-Center( $xString, [string]$xFill = ' ', $xSize )
	{
	
	# PSEUDO OVERLOAD FOR STRING/STRING[]
	# USING RECURSIVITY
	if ( $xString -is [System.Array] )
		{
		$xStrings = @();
		Foreach( $e in $xString ) 
			{ $xStrings += ( String-Center $e $xFill $xSize ) }
		
		return $xStrings
		}

	# VACCINE: PREVENT OPERATOR CONFUSION ON NUMERIC -VS- STRING TYPE
	$xString = [string]$xString

	# 0/$null = adjust to console 
	if ( $xSize -eq $null -or $xSize -eq 0 ) 
		{ $xSize = $Host.UI.RawUI.WindowSize.Width }

	$xLen = $xString.Length;
	if ( $xLen -gt $xSize ) { return $xString.Substring( 0, $xSize ) }
	
	# GENERATED STRING CAN EXCEED $xSize
	# (pure math solution can also sin for LESS then desired size)
	$xHalf = [Math]::Floor( ( $xSize - $xLen ) / 2 / $xFill.Length );
	$xData =  $xFill * $xHalf + $xString + $xFill * ++$xHalf 

	# so FIX it to desired size
	return $xData.Substring( 0, $xSize );
	}


function String-Cut( [string] $xString, [int] $xSize ) 
	{}


<#
First N elements of the string

#>
function String-Head( [string] $xString, [int] $xSize ) 
	{}


<#
Invert String/String[]


#>
function String-Invert( $xString )
	{
	# PATTERN: PSEUDO OVERLOAD FOR STRING/STRING[]
	# USES RECURSIVITY
	if ( $xString -is [System.Array] )
		{
		$xStrings = @();
		Foreach( $e in $xString ) 
			{ $xStrings += ( String-Invert $e $xFill $xSize ) }
		
		return $xStrings
		}
	
	Label String-Invert-Single
	return $xStrings


	Label String-Invert-Multiple
	return $xStrings

	}



<#
Get Last N elements
#>
function String-Tail( [string] $xString, [int] $xSize ) 
	{}




