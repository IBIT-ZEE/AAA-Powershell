

# return the selected String
function AAA-MenuX( $xOptions )
	{
	$x = [AAA_Menu]::New();
	$x.xOptions = $xOptions;
	$x.Go();
	return $x.xOptions[ $x.xIndex ];
	}

Class AAA_Menu
	{
	$xKey;					# [System.ConsoleKeyInfo.key] 
	$xChar;					# [System.ConsoleKeyInfo.keyChar] 
	$xKeyPrevious;
	$xOptions;				# [string[]] 
	$xCount = 0;
	$xIndex = 0;
	$xCursor;
	$xSeparator = "`n";
	
	# ***REFACTOR to AAA.Options
	$keys   = $global:AAAX.Keys;
	$xInk   = $global:AAAX.Colors.Ink;
	$xPaper = $global:AAAX.Colors.Paper;


	# DISPLAY | WAIT-FOR-KEY | ...
	Go()
		{
		$this.xCount  = $this.xOptions.Length;
		$this.xCursor = $global:Host.UI.RawUI.CursorPosition;

		# Skip if 1st option is a group-marker
		$this.Check( 1 );

		while ( $this.xKey -ne $this.keys.Enter ) 
			{
			$this.Processor();
			$this.Show();

			# Input/get Key code
			# $this.xKey = $global:host.UI.RawUI.ReadKey( "NoEcho,IncludeKeyDown" ).VirtualKeyCode;
			$x = [Console]::ReadKey();
			$this.xKey = [int]$x.Key;
			$this.xChar = $x.keyChar;
			}

		}


	# DISPLAY THE OPTIONS & MARK THE SELECTED ONE
	Show()
		{
		$global:host.UI.RawUI.CursorPosition = $this.xCursor;

		for( $x = 0; $x -lt $this.xCount; $x++  )
			{
			# VACCINE using number arrays 
			# ( no strings => no .StartsWith() )
			[string] $xOption = $this.xOptions[ $x ];

			# "" means GROUP.START ~> CHANGE LINE
			if ( $xOption.StartsWith( "`n" ) )
				{
				# is starting to show data do not SEPARATE
				if ( $x -gt 0 ) { Write-Host $this.xSeparator; };
				Write-Host $xOption.Substring(1);
				continue;
				}

			# REFACTOR***
			#    $AAA.color.background / paper
			#    $AAA.color.foreground / ink
			#
			# option.selected=YES 
			if ( $x -eq $this.xIndex ) 
				{
				$global:host.ui.RawUI.ForegroundColor = $global:AAAX.Colors.Paper;
				$global:host.ui.RawUI.BackgroundColor = $global:AAAX.Colors.Ink;
				Write-Host -NoNewline $xOption 
				$global:host.ui.RawUI.ForegroundColor = $global:AAAX.Colors.Ink;
				$global:host.ui.RawUI.BackgroundColor = $global:AAAX.Colors.Paper;
				}
			else
				{ 
				Write-Host -NoNewLine $xOption
				} 

			Write-Host -NoNewLine " ";
			}
		}
	
	# PROCESS USER INPUT
	Processor()
		{
		# VACCINE using number arrays 
		# ( no strings => no .StartsWith() )

		switch( $this.xKey )
			{
			$this.keys.Home  { $this.xIndex = 0; $this.Check( 1 ) ; }
			$this.keys.End   { $this.xIndex = $this.xCount - 1    ; $this.Check( -1 ) ; }
			$this.keys.Space { $this.xIndex++                     ; $this.Check( 1 )  ; }
			$this.keys.Right { $this.xIndex++                     ; $this.Check( 1 )  ; }
			$this.keys.Left  { $this.xIndex--                     ; $this.Check( -1 ) ; }
			$this.keys.Up    { $this.PreviousGroup()              ; $this.Check( 1 )  ; } 
			$this.keys.Down  { $this.NextGroup()                  ; $this.Check( 1 )  ; }

			# REFACTOR TO DEFAULT
			#0..9/A..Z
			Default 
				{
				if ( $this.xChar -eq 0 ) 
					{ Sound-Plim; }
				else
					{
					# VACCINE $xIndex from GETTING NON VALID ordinals
					$x = Array-ScanNext $this.xOptions "$($this.xChar)*" $this.xIndex;
					if ( $x -ne -1 ) { $this.xIndex = $x }
					}
			 	}
			}
		}

	# PROCESSOR EXTENDED LOGIC
	# $xDirection to reposition the cursor after a move
	Check( $xDirection )
		{
		
		Switch( $xDirection )
			{

			# PREVIOUS
			-1 
				{
				[string] $xOption = $this.xOptions[ $this.xIndex ];
				if ( $xOption.StartsWith( "`n" ) ) { $this.xIndex--}

				if ( $this.xIndex -lt 0 )
					{ $this.xIndex = $this.xCount - 1; } 

				break;
				}

			# NEXT
			1
				{ 
				if ( $this.xIndex -gt $this.xCount - 1 ) 
					{ $this.xIndex = 0; } 
				
				[string] $xOption = $this.xOptions[ $this.xIndex ];
				if ( $xOption.StartsWith( "`n" ) ) { $this.xIndex++ }
				
				break;
				}
			
			}
		}

	
	#
	NextGroup()
		{
		# VACCINE $xIndex from GETTING NON VALID ordinals
		$x = Array-ScanNext $this.xOptions "`n*" $this.xIndex;
		if ( $x -eq -1 ) { return;  }
		$this.xIndex = $x;
		}


	#
	PreviousGroup()
		{
		$x = Array-ScanPrevious $this.xOptions "`n*" $this.xIndex;

		# NO GROUPS then exit
		if ( $x -eq -1 ) { return; }

		# QUIRK*** 
		# DECREMENT HERE
		# STRANGENESS OCCURS IF DECREMENTED AS PARAMETER IN FUNCTION CALL
		$this.xIndex = --$x;
		$x = Array-ScanPrevious $this.xOptions "`n*" $this.xIndex;
		$this.xIndex = $x
		}

	}

