# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
# CUI Menu System
#
#
#

<#
.SYNOPSIS
Present a console navigatable menu
and return the selected Index

#>
function AAA-Menu( $xOptions, $xGroups = $null )
	{
	$xMenu = [MN_]::New();
	$xMenu.xOptions = $xOptions;

	# TEST***
	# $xMenu.xGroupsX = $xGroups
	$xMenu.xGroups  += 0;
	$xMenu.xGroupsX += $null;	
	
	$xMenu.Go();
	return $xMenu.xIndex;
	}


function ~AAA-Menu( $xOptions, $xGroups = $null )
	{
	$xMenu = [MN_]::New();
	$xMenu.xOptions = $xOptions;

	# GROUP-CHANGE POINTS APPROPRIATION/AWERNESS
	if ( $xGroups ) 
		{
		# REALIZE GROUPS
		# 1. get inflexion points
		# 2. 
		$xMenu.xGroups = Array-Changepoints $xGroups 
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


<#
.SYNOPSIS
Return a MN_ Object

QUIRK*
to fix Powershell limitation of Class-Types 
not be available  in other modules... 
even if other imported items are correctly available (Functions, vars, ...)
#>
function MN_New(){ return [MN_]::new() }


Class MN_
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

	# Globals
	$UI = $global:host.ui.RawUI;
	$AAAX =  $global:AAAX;


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
		for( $xGroupIx = 0; $xGroupIx -lt $xMax; $xGroupIx++ )
			{
			#
			if ( $this.xGroupsX[ $xGroupIx ] ) 
				{ Write-Host $this.xGroupsX[ $xGroupIx ] }

			# get group limit low-high element index
			$xRangeLo = $this.xGroups[ $xGroupIx ];

			$xRangeHi = `
				if ( $xGroupIx -lt ($xMax-1) ) 
					{ $this.xGroups[ $xGroupIx + 1 ] } 
				else 
					{ $this.xCount };

			# OPTIONS/GROUPS DISPLAY
			for( $xOptionIx = $xRangeLo; $xOptionIx -lt $xRangeHi; $xOptionIx++ )
				{
				$xOptionTx = $this.xOptions[ $xOptionIx ];

				# prevent text from break line?
				if ( $this.UI.CursorPosition.X + $xOptionTx.Length -gt $this.UI.WindowSize.Width )
					{ Write-Host ""; }

				# render non-selected options
				if ( $xOptionIx -ne $this.xIndex ) 
					{
					Write-Host -NoNewLine $xOptionTx;
					}
				else 
					{
					# render Selected option
					$global:host.ui.RawUI.ForegroundColor = $global:AAAX.Colors.Paper;
					$global:host.ui.RawUI.BackgroundColor = $global:AAAX.Colors.Ink;
					Write-Host -NoNewline $xOptionTx;
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

