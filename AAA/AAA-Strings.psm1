# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |S|T|R|I|N|G|S|
#
#




<#
.SYNOPSIS
String funcionality for collections


#>
function Strings-  { AAA-Functions }



<#
Uses String-Edge

Strings-Edge xEdgeLeft $xEdgeRight

returns String[]


#>
function Strings-Edge
	( 
	[string[]]$xEdgeA,
	[string[]]$xEdgeB
	)
	{
	
	$x = @();

	for( $f = 0; $f -lt $xEdgeA.Length; $f++ )
		{ 
		$x += String-Edge -xLeft $xEdgeA[ $f ] -xRight $xEdgeB[ $f ];
		}

	return $x;
	
	}




<#
.SYNOPSIS
.

String-Fit <xArray> [xAlign xSeparator xSize xContrast]

String-Fit "1", "22", "333"
String-Fit "1", "22", "333" 1

-xAlign 
	Alignment for elements
		0 = Centered *default
		1 = Left
		2 = Right

-xSeparator
	string for element separation

-xSize
	if no size argumented
	it will be deducted from screen size


Return a string from an array
with elements equally aligned
Adjusted to a given size
(if no size supplied assume console width)

.TESTS
Strings-Fit 1,22,333,4444,55555
Strings-Fit 1,22,333,4444,55555 -xAlignment 1
Strings-Fit 1,22,333,4444,55555 -xSeparator "|"
Strings-Fit 1,22,333,4444,55555 -xAlignment 0 -xSeparator "<>"

#>	
function Strings-Fit( 
	[String[]] $xStrings, 
	[string]   $xSeparator = "", 
	[int]      $xAlignment = 0,  
	[int]      $xSize      = $host.UI.RawUI.WindowSize.Width
	)

	{
	#***2DO replace with MACRO/INLINE ~> isNullable -variable $x 
	# ~> help($this) && halt program
	# ?show module and line number??
	if ( $null -eq $xStrings ) { Help Strings-Fit; return $null; }

	$xCol = ( $xSize - ( $xSeparator.length * ( $xStrings.Length - 1 ))) / $xStrings.Length;

	switch( $xAlignment )
		{
		0 { $x = Strings-Pad-Center $xStrings $xCol; Break; }
		1 { $x = Strings-Pad-Left   $xStrings $xCol; Break; }
		2 { $x = Strings-Pad-Right  $xStrings $xCol; Break; }
		}

	return $x -join $xSeparator;
	}





<#
.SYNOPSIS
~

Get the index of the longest string

~

#>	
function Strings-Longest( [string[]]$xArray )
	{ 
	$xSize=0; 

	for( $xx = 0; $xx -lt $xArray.length; $xx++ )
		{  if( $xArray[ $xx ].length -gt $xSize ) 
			{ 
			$x = $xx; 
			$xSize = $xArray[ $xx ].length;
			};  
		}; 

	return $x
	} 






function Strings-Pad-  { AAA-Functions }


<#
.SYNOPSIS
Center/Pad all strings in an array to a defined size
if size is not argumented 
get the size of the biggest element in the array


.NOTES
Strings-Align "1", "22", "333"
Strings-Align "1", "22", "333" 20

#>	
function Strings-Pad-Center ( [String[]]$xStrings, [int]$xSize = 0 )
	{

	# se $xSize for 0 centrar pelo maior item na lista
	if ( $xSize -eq 0 ){ $xSize = Strings-Size-Max $xStrings }

	
	$x = @();
	foreach( $e in $xStrings )
		{
		$xPad = $xSize - $e.Length
		if ( $xPad -lt 0 ){ $xPad = 0 }
		$xHalf = $xPad -shr 1;

		$x += `
			" " * $xHalf + `
			$e + 
			" " * ( $xPad - $xHalf )
					
		}

	return $x
	}



<#
.SYNOPSIS
Left/Pad all strings in an array to a defined size
if size is not argumented 
get the size of the biggest element in the array

.NOTES
Strings-Pad-Left "1", "22", "333"
Strings-Pad-Left "1", "22", "333" 20


#>	
function Strings-Pad-Left( [String[]]$xStrings, [int]$xSize = 0 )
	{
	
	# se $xSize for 0 alinhar pelo maior item na lista
	if ( $xSize -eq 0 ){ $xSize = Strings-Size-Max $xStrings }
	
	$x = @();
	$xFormat = "{{0,-{0}}}" -f $xSize;
	$x += $xStrings.foreach( { $xFormat -f $_ } )

	return $x
	}



<#
.SYNOPSIS
Right/Pad all strings in an array to a defined size
is size is not argumented 
get the size of the biggest element in the array


.NOTES
Strings-Pad-Right "1", "22", "333"
Strings-Pad-Right "1", "22", "333" 20


#>	
function Strings-Pad-Right( 
	[String[]]$xStrings = "<Strings-Pad-Right default>", 
	[int]$xSize = 0 
	)
	{

	# se $xSize for 0 alinhar pelo maior item na lista
	if ( $xSize -eq 0 ){ $xSize = Strings-Size-Max $xStrings }

	$x = @();
	$xFormat = "{{0,{0}}}" -f $xSize;
	$x += $xStrings.foreach( { $xFormat -f $_ } )

	return $x
	}





<#
.SYNOPSIS
Return the size in characters of a String or a Array of strings


#>	
function Strings-Size-Chars( [string[]] $x )
	{
	$xx = 0;
	Foreach( $e in $x ) { $xx += $e.length }
	return $xx
	}




<#
.SYNOPSIS
Return the size of the biggest string in array


#>	
function Strings-Size-Max( [string[]] $xStrings )
	{
	$x = 0; 
	$xStrings.ForEach( { if( $_.length -gt $x ){ $x = $_.length } } )
	return $x;
	}



<#
.SYNOPSIS
Return the size of the smallest string in array

[maxint] if none found

#>	
function Strings-Size-Min( [string[]] $xStrings )
	{
	$x = [int]::MaxValue; 
	$xStrings.ForEach( { if( $_.length -lt $x ){ $x = $_.length } } )
	return $x;
	}


