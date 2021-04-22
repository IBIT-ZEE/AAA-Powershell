# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
# UI Menu System/Console
#
#
#

# QUIRK*** so we can use the [_AA]/METADATA type
using module C:\dat\PowerShell\AAA\AA.psm1;

<#
.SYNOPSIS
~

AAA/Advanced Artifact Template

	About .... Objective/Usage quick overview
	New ...... Creates a new object, put at use, return reference
	Object ... Returns current object reference
	Test .....	Quick test framework (assert for...)

	State .... ?
	Status ... ?

	On/Off ... Activate/Deactivate object (for event processors, ...)

~
#>
function MN- { AAA-Functions }

Set-StrictMode -Version 5;
# Add-Type -AssemblyName "System.Web"; # for Mime types


Class MN_
	{
	# holds the current object
	# for all methods
	# and interactive functionality [WS_]::$object
	static [MN_] $object = $null;
	[_AA]$_AA = [_AA]::new();


	# SPECIFIC CLASS/TYPE PROPERTIES


	$xKey=0;						# [System.ConsoleKeyInfo.key] 
	$xKeyPrevious;
	$xChar=0;						# [System.ConsoleKeyInfo.keyChar] 
	$xCount   = 0;
	$xIndex   = 0;
	$xGroup   = $null;
	$xCursor;
	$xSeparator = "`n";

	$xOptions = @();		# string
	$xGroups  = @();		# int[]
	#$xGroupsX = @();		# String[]
	
	$keys   = $global:AAAX.Keys;
	$xInk   = $global:AAAX.Colors.Ink;
	$xPaper = $global:AAAX.Colors.Paper;

	# Globals
	$UI = $global:host.ui.RawUI;
	$AAAX =  $global:AAAX;

	# ctor expose for clean AV object return
	# in v5 PS has no constructor chainning
	# so no overloads here has not much advantage
	# let's opt-in for basic constructor
	MN_() 
		{ 
		# SHARED/STATIC holds the last/current object	
		[MN_]::Object = $this;

		# METADATA
		$this._AA.xDate = Get-Date;
		$this._AA.xCredential = $global:AAA.System.Credential;
		
		# constructor "default return" is the "instantiated object"
		}


	# DISPLAY | WAIT-FOR-KEY | ...
	Go()
	{
		$this.xCount  = $this.xOptions.Length;
		$this.xCursor = $global:Host.UI.RawUI.CursorPosition;

		while ( $this.xKey -ne $this.keys.Enter ) 
			{
			# wait for user actions
			# show options/groups
			$global:host.UI.RawUI.CursorPosition = $this.xCursor;
			$this.Move();
			$this.Render();	

			# INPUT
			# get Key code
			# $this.xKey = $global:host.UI.RawUI.ReadKey( "NoEcho,IncludeKeyDown" ).VirtualKeyCode;
			$x = [Console]::ReadKey();
			$this.xKey = [int]$x.Key;
			$this.xChar = $x.keyChar;
			}

		}


	# PROCESS USER INPUT
	Move()
		{
		# VACCINE using number arrays 
		# ( no strings => no .StartsWith() )

		switch( $this.xKey )
			{
			$this.keys.Home  { $this.xIndex = 0 ; break; }
			$this.keys.End   { $this.xIndex = $this.xCount - 1; break; }
			$this.keys.Space { $this.xIndex++   ; break; }
			$this.keys.Right { $this.xIndex++   ; break; }
			$this.keys.Left  { $this.xIndex--   ; break; }
			$this.keys.Up    { $this.GroupUp()  ; break; }
			$this.keys.Down  { $this.GroupDn()  ; break; }

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

					$x = `
						Array-ScanNext `
							-xArray $this.xOptions `
							-xElement $this.xChar + '*' `
							-xPos $this.xIndex;

					if ( $x -ne -1 ) { $this.xIndex = $x }
					}
			 	}
			}

		# wrap menu
		if ( $this.xIndex -lt 0               ) { $this.xIndex = $this.xCount - 1 }			
		if ( $this.xIndex -gt $this.xCount -1 ) { $this.xIndex = 0                }

		# update current group for current index
		# $this.xGroup = $this.xGroups[ $this.xIndex ];

		}
		

	# SCAN GROUP-TAGS FOR THE 1ST GREATER THAN OPTION-INDEX
	# position $this.xIndex cursor
	GroupUp()
		{
		# cycle-backwards through all elements begining at current index
		# if group-tag change then break and assign index
		for( $x = 1; $x -lt $this.xCount - 1; $x++ )
			{
			if( $this.xGroups[ (  $this.xIndex + ( $this.xCount - $x ) ) % $this.xCount ] -ne $this.xGroup )
				{ 
				$this.xIndex = (  $this.xIndex + ( $this.xCount - $x ) ) % $this.xCount;
				$this.xGroup = $this.xGroups[ $this.xIndex ]			
				break; 
				} 
			}

		
		}



	# SCAN GROUP-TAGS FOR THE 1ST LESS THAN OPTION-INDEX
	# position $this.xIndex cursor
	GroupDn()
		{
		# cycle-forwards through all elements begining at current index
		# if group-tag change then break and assign index
		for( $x = 1; $x -lt $this.xCount - 1; $x++ )
			{
			if( $this.xGroups[ (  $this.xIndex + $x ) % $this.xCount ] -ne $this.xGroup )
				{ 
				$this.xIndex = (  $this.xIndex + $x ) % $this.xCount;
				$this.xGroup = $this.xGroups[ $this.xIndex ]			
				break; 
				} 
			}
		}

	
	
	# RENDER GROUPS+MENU
	Render()
		{

		# Control group change/draw
		$xGroupNow = $null;
		$xGroupOld = $null;

		for( $x = 0; $x -lt $this.xCount; $x++ )
			{

			# RENDER GROUPS
			$xGroupNow = $this.xGroups[ $x ];

			# show only -on- 1st grouyp item -and- if Group-Title=ON...
			if ( $xGroupNow -ne $xGroupOld )
				{
				# prevent a NULL
				# and prevent new-lines at first option
				if ( $xGroupNow ) 
					{
					# ??write group separator
					if ( $x ) { Write-Host "`n" }
					Write-Host ( "[{0}]" -f $xGroupNow )
					}
				}
			
			# hold current value for next compare
			$xGroupOld = $xGroupNow;


			# RENDER OPTIONS
			[string]$xOption = $this.xOptions[ $x ];

			# break line before option text would break
			if ( $this.UI.CursorPosition.X + $xOption.Length -gt $this.UI.WindowSize.Width )
				{ Write-Host ""; }

			# render non-selected options
			if ( $x -ne $this.xIndex ) 
				{
				Write-Host -NoNewLine $xOption;
				}
			else 
				{
				# render Selected option
				$global:host.ui.RawUI.ForegroundColor = $global:AAAX.Colors.Paper;
				$global:host.ui.RawUI.BackgroundColor = $global:AAAX.Colors.Ink;
				Write-Host -NoNewline $xOption;
				$global:host.ui.RawUI.ForegroundColor = $global:AAAX.Colors.Ink;
				$global:host.ui.RawUI.BackgroundColor = $global:AAAX.Colors.Paper;									
				}

			Write-Host -NoNewLine " ";
			}

		}

	}



<#
.SYNOPSIS

If defined...
is called from AMN-Functions
before listing available methods...


#>
function MN-About()
	{
	"
	MN-New to get a instance ( xOptions/null xGroups/null )
	Mn-On to render and wait for user input

	...
	"
	}




<#
.SYNOPSIS
Roll the drums!!!

#>
function MN-Go( [MN_]$xObject = [MN_]::object )
	{
	if( $null -eq $xObject ){ throw "MN-On ~> no Object defined..." }

	# reset key for on/off sessions (last enter key will cause exit/return)
	# and relaunch menu with current state
	$xObject.xKey = $null
	$xObject.Go();

	return $xObject.xIndex;
	}




<#
.SYNOPSIS
Show the help page...

#>
function MN-Help( )
	{ 
	Get-Help -Category function -Name MN- -ShowWindow;
	}




<#
.SYNOPSIS
Create a new object of this kind...
and make it current

Return the newly created reference...
#>
function MN-New( $xOptions = $null, $xGroups = $null )
	{
	# object inception/instantiation
	# SHARED $this::object and other METADATA/_AA (time, credential, ...)
	# is assigned in the contructor
	$x = [MN_]::new()

	# inicialization
	$x.xOptions = $xOptions;
	$x.xGroups  = $xGroups;

	# if OPTIONS are argumented
	# opt-in for initializion of xGroups to $nulls if necessaire
	# and reduce the move/render methods mechanics complexity
	if ( $xOptions ) 
		{
		if ( $null -eq $xGroups )
			{ $x.xGroups = @( $null ) * $xOptions.Length }
		}

	return $x; 
	}



<#
.SYNOPSIS
GET/SET the current object

Return the current new MN_ object 
[MN_]::$object

#>
function MN-Object( $xObject = $null )
	{ 
	
	# Current object
	# . Get/Retrieve
	# -or-
	# . Set/Assign/Activate	
	if ( $null -eq $xObject  ) 
		{ 
		# no argument...
		# so... get the Current object
		if ( $null -eq [MN_]::object ){ "No current MN- object" }; 
		return [MN_]::object;
	
		}
	else
		{
		# set argumented object
		# ?return former object
		}

	}




<#
.SYNOPSIS
Start listening for requests...

#>
function MN-On( [MN_]$xObject = [MN_]::object )
	{
	if( $null -eq $xObject ){ throw "MN-On ~> no Object defined..." }

	# 2DO*** redundant...
	return Mn-Go $xObject;
	}


<#
.SYNOPSIS
Stop listening for requests...

#>
function MN-Off( [MN_]$xObject = [MN_]::object )
	{ 
	

	}



<#
.SYNOPSIS
State display...

State refers to internal data


#>
function MN-State( [MN_]$xObject = [MN_]::object )
	{ 
	
	# 2DO***
	# Customize the STATE output for this object
	if ( $null -eq $xObject ){ throw "MN-State ~> no selected object..." }

	$xObject;

	}




<#
.SYNOPSIS
Status display...

Status refers to external usage

* default is current object
#>
function MN-Status( [MN_]$xObject = [MN_]::object )
	{ 
	
	# 2DO***
	# Customize the STATUS output for this object
	if ( $null -eq $xObject ){ throw "MN-State ~> no selected object..." }
	$xObject;

	}



<#
.SYNOPSIS
Tests
to provide a simple test framework
and assert for incoherences

#>
function MN-Test( [MN_]$xObject = [MN_]::object )
	{ 
	'''
	Simple test framework
	Asserting for incohereces

	Define your more critical 
	centralize here a global call 
	to all tests considered critical
	applied over the current object...
	'''

	MN-New 1,22,333,4444,55555,666666,7777777 A,BB,BB,CCC,CCC,CCC,DDDD
	MN-On
	
	}


# MN-New -xName "<aa-default>"
