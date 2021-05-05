# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |S|T|R|I|N|G|
#
#


# STRING.HEAD( N )
Update-TypeData `
	-TypeName System.String -MemberType ScriptMethod -MemberName Head `
	-Value { param( [int]$xSize=1 ) if ( $this.Length -lt $xSize ){ return $this }; return $this.Substring(0, $xSize) }

# STRING.TAIL( N )
Update-TypeData `
	-TypeName System.String -MemberType ScriptMethod -MemberName Tail `
	-Value { param( [int]$xSize=1 ) if ( $this.Length -lt $xSize ){ return $xString }; return $this.Substring( $this.Length - $xSize ) }

# STRING.REPLICATE( N )
Update-TypeData `
	-TypeName System.String -MemberType ScriptMethod -MemberName Replicate `
	-Value { param( [int]$xTimes=2 ); return $this * $xTimes; }



<#
.SYNOPSIS.
? Grow 
? Invert sinle/multiple
? Inflate/Deflate
? Clone/Cloner -vs- Replicate ?! single/multiple
? Add/Subtract -vs- Append/Remove

? Strings-* or String overload ??

#>
function String-  { AAA-Functions }



<#
.SYNOPSIS.
Assemble a array into a string...
using SPACE as separator... or specify any string as separator

String-Assenble 1,22,333 " | "
String-Assenble -xStrings 1, 22, 333 -xSeparator " | "

#>
function String-Assemble( [string[]] $xStrings, $xGlue = "" ) 
	{
	return $xStrings -join $xGlue;
	}



<#
.SYNOPSIS
Deprecated... 
To Remove...
use String-Pad-Center

Center <String> or <String[]>
Parameter pattern-string to fill/auto is " "...
Parameter for size/auto is console width...

QUIRK***
Pseudo overload for String or Strings[]


#>
function String-Center( 
	$xString = '<String-Center-Sample>', 
	[string]$xFill = ' ',
	$xSize = $Host.UI.RawUI.WindowSize.Width
	)
	{
	return ( String-Pad-Center -xString $xString -xFill $xFill -xSize $xSize);
	}



<#
.SYNOPSIS
~

Get a chunk of the string...
begin at n and with m size

>slice

~
#>
function String-Cut( [string] $xString, [int] $xSize ) 
	{
	"2DO***"
	}



<#
.SYNOPSIS
~

remove n chars from -left/-right
?use -n or left/right
>slice

~
#>
function String-Cut( [string] $xString, [int] $xSize ) 
	{
	"2DO***"
	}


<#
.SYNOPSIS
~

Encrypt with Windows DPS/User
// Add-Type -AssemblyName System.Security

>String-Decrypt

// SAMPLE

~
#>
function String-Crypt( [string] $xString ) 
	{
	# $x  = [System.Text.Encoding]::UTF8.GetBytes( $xString )
	# $xx = [System.Security.Cryptography.ProtectedData]::Protect($bytes, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
	# return [Convert]::ToBase64String( $xx )

	return `
		[Convert]::ToBase64String(
			[System.Security.Cryptography.ProtectedData]::Protect(
				[System.Text.Encoding]::UTF8.GetBytes( $xString ),
				$null, 
				[System.Security.Cryptography.DataProtectionScope]::CurrentUser
				)
			)
	}





<#
.SYNOPSIS
~

Encrypt with Windows DPS/User
// Add-Type -AssemblyName System.Security

>String-Decrypt

// SAMPLE

~
#>
function String-Decrypt( [string] $xString ) 
	{
	# $x  = [Convert]::FromBase64String( $xString )
	# $xx = [System.Security.Cryptography.ProtectedData]::Unprotect($x, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
	# return [System.Text.Encoding]::UTF8.GetString( $xx )

	return `
		[System.Text.Encoding]::UTF8.GetString( 
			[System.Security.Cryptography.ProtectedData]::Unprotect(
				[Convert]::FromBase64String( $xString ),
				$null, 
				[System.Security.Cryptography.DataProtectionScope]::CurrentUser
				)
			)
	}





<#
.SYNOPSIS
~

Returns a sized string 
composed by 2 other strings on the edges
if no size is supplied console width is assumed

* If you need several elements displayed
Compose the Strings for Left and Right :-)

TEST:
	String-Edge "Dock-Left" "Dock-Right"
	String-Edge "Dock-Left" "Dock-Right" 80

SEE:
	String-Center

~
#>
function String-Edge( [string]$xLeft, [string]$xRight, $xSize )
	{

	if ( $null -eq $xSize ){ $xSize = $Host.UI.RawUI.WindowSize.Width }

	$xSize--;
	$xSize1 = $xLeft.Length;
	$xSize2 = $xRight.Length;

	# resize
	if ( $xSize1 + $xSize2 -gt $xSize )
		{
		# ?too big... resize bigger
		# and account for end in "..."
		if ( $xSize1 -gt $xSize2 ) 
			{ 
			$xLeft  = $xLeft.Substring( 0,  $xSize - $xSize2 - 3 ) + "...";
			$xSize1 = $xLeft.Length;
			}
		else 
			{
			$xRight = $xRight.Substring( 0,  $xSize - $xSize1 - 3 ) + "..." 
			$xSize2 = $xRight.Length;
			}

		}

	
	return "{0}{1}{2}" -f $xLeft,  ( " " * ( $xSize - $xSize1 - $xSize2 + 1 ) ), $xRight;
	
	}


<#
.SYNOPSIS
~

Returns a string fitted to size
if argument is not enough it replicates until 'necessaire'
if argument if more then enough cuts to size

// SAMPLE
	String-Fit "-=-" 80
	String-Fit -xString "-=-" -xSize 80

>String-Center
>String-Pad

~
#>
function String-Fit( [string]$xString, [int]$xSize = $host.ui.RawUI.WindowSize.Width )
	{
	# is string enough...
	if ( $xString.Length -ge $xSize ){ return $xString.Head( $xSize )	}
	# ...or has to be replicated???
	# then cut to the desired size...
	# AAA***/What a nice Fluency/Chain construct
	return $xString.Replicate( [int]( $xSize / $xString.Length ) + 1 ).Head( $xSize )
	}



<#
.SYNOPSIS
~

First N elements of the string

>String-Tail
>String-Slice

ATT***
AAA/[string]::Head
no breaking error if insufficient elements

// SAMPLES
String-Head
String-Head "123456789" 5

~
#>
function String-Head( [string] $xString, [int]$xSize=1 ) 
	{ $xString.Head( $xSize ) }



<#
.SYNOPSIS.
Invert String/String[]

#>
function String-Invert( $xString )
	{
	"2DO***"
	}




function String-Pad-  { AAA-Functions }


<#
.SYNOPSIS
Center/Pad string with optional pad char
if size is not argumented get the width of the console

.NOTES
String-Pad-Center "AAA"
String-Pad-Center "AAA", "_"

#>	
function String-Pad-Center ( 
	[String]$xString = "<String-Pad-Center default>", 
	[string]$xFill = " ",
	[int]$xSize = $Host.UI.RawUI.WindowSize.Width
	)
	{
	
	# IS SIZE GREAT THEN ARGUMENTED
	$xLen = $xString.Length;
	if ( $xLen -gt $xSize ) { return $xString.Substring( 0, $xSize ) }
	
	# GENERATED STRING CAN EXCEED $xSize
	# (pure math solution can also sin for LESS then desired size)
	[int]$xFilen = ( [Math]::Floor( ( $xSize - $xLen ) / 2 ) ) / $xFill.Length;

	$xData =  $xFill * $xFilen + $xString + $xFill * ++$xFilen 

	# so FIX it to desired size
	return $xData.Substring( 0, $xSize );
	}

	

<#
.SYNOPSIS
Left/Pad string
if size is not argumented get width of console
--------------------------------------------------------------------------------

.NOTES
Strings-Pad-Left "AAA"
Strings-Pad-Left "AAA", "_"


#>	
function String-Pad-Left( 
	[String]$xString = "<String-Pad-Left default>", 
	[string]$xFill = " ",
	[int] $xSize = $Host.UI.RawUI.WindowSize.Width
	)

	{

	# IS SIZE GREAT THEN ARGUMENTED
	$xLen = $xString.Length;
	if ( $xLen -gt $xSize ) { return $xString.Substring( 0, $xSize ) }
	
	# GENERATED STRING CAN EXCEED $xSize or be truncated
	# [int] will round up
	[int]$xFilen = ( $xSize - $xLen ) / $xFill.Length + 1;

	# so FIX it to desired size
	return ( $xString + $xFill * $xFilen ).Substring( 0, $xSize );

	}
	



<#
.SYNOPSIS
Right/Pad string to a defined size
if size is not argumented console width is assumed
--------------------------------------------------------------------------------

.NOTES
Strings-Pad-Right "1"
Strings-Pad-Right "1" "22"

#>	
function String-Pad-Right( 
	[String]$xString = "<String-Pad-Right default>", 
	[string]$xFill = " ",
	[int] $xSize = $Host.UI.RawUI.WindowSize.Width
	)

	{

	# IS SIZE GREAT THEN ARGUMENTED
	$xLen = $xString.Length;
	if ( $xLen -gt $xSize ) { return $xString.Substring( 0, $xSize ) }
	
	# GENERATED STRING CAN EXCEED $xSize or be truncated
	# [int] will round up
	[int]$xFilen = ( $xSize - $xLen ) / $xFill.Length + 1;

	# assure that rightmost xString is intact
	# so first generate xFill... and truncate it
	# then add the xString
	return ($xFill * $xFilen).Substring( 0, $xSize - $xLen ) + $xString;
	}




<#
.SYNOPSIS
Alerter only...

#>
function String-Pattern { AAA-Alert "Use Pattern-*" }




<#
.SYNOPSIS

Replicate/Cut to argumented leght

>String.Replicate

~
#>
function String-Replicate ( [string] $xString, [int] $xTimes = 2 )
	{ return $xString.Replicate( $xTimes ) }


<#
.SYNOPSIS
~

Get a slice from n to m
?or from n, m chars

ATT***
Non breaking error if insufficient elements

// SAMPLES
String-Slice
String-Slice "123456798" 5
String-Slice -xString "123456789" -xStart 0 -xLength 1

>String.Head/Tail
+
>String-Chunk
>String-Head
>String-Tail

~
#>
function String-Slice( [string]$xString, [int]$xStart = 0, [int]$xLength=1 ) 
	{
	"2DO***"
	}





<#
.SYNOPSIS
~

Split on a mark ?by char/string/interval ???
!THERE SHOULD BE OVERLOADS IN POWERSHELL!!
?OR CAN WE SOLVE IT WITH EXTENSION METHODS??

ATT***
Non breaking error if insufficient elements

// SAMPLES

>???

~
#>
function String-Split( [string]$xString, [string]$xMark ) 
	{
	"2DO***"
	}



<#
.SYNOPSIS
~

Get Last N elements



>String-Head
>String-Slice

ATT*** 
AAA/[string]::Tail
no break error if insufficient elements

// SAMPLES
String-Tail "12345679"
String-Tail "12345679" 5

~
#>
function String-Tail( [string]$xString, [int]$xSize=1) 
	{ $xString.Tail( $xSize ) }



