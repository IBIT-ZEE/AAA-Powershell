# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |A|R|R|A|Y|
#
#


<#
.SYNOPSIS
Array functionality

?hold Array_ global state??
?implements [_AA]
?Array_Last
?Array_LastX
?Array-Status ~> Show Array_

#>
function Array- { AAA-Functions }



<#
.SYNOPSIS

Add an element to array

// SAMPLES
Array-Add $a "1"
Array-Add $a "22"
Array-Add $a "333"


#>
function Array-Add ( $xArray )
	{
	"2DO***"

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
~

Gets a single colum from a multicolumn array 
and returns as a single column array

~
#>
function Array-Column( $xArray )
	{
	$xTemp = @();
	
	foreach( $x in $xArray ){  }
	}



<#
.SYNOPSIS
~

T/F 
implemented for easy discoverability/explorability/expression/example

~
#>
function Array-Contains( $xArray, $xItem )
	{
	return ( $xArray -contains $xItem )
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
~

Extract a syb-array

Return an array extracted from the argumented array
filtered by the argumented lamda


// SAMPLES
$a = Array-Extract $a1 { $_[0].EndsWith( "~" ) }

~
#>
function Array-Extract( $xArray )
	{
	
	"2do***"

	}




<#
.SYNOPSIS
~

Scan the array
Build a 
Build a Result-Array from Source-Array 
of indexes of change Points (inflexions)

// SAMPLE
Array-Inflexions $a
Array-Inflexions -xArray $a

~
#>
function Array-Inflexions( $xArray )
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


<#
.SYNOPSIS

Loads a table (.dat) into a HashTable

AAA -> 
	Strips extra \t
	Strips extra \crlf

#>
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



<#
.SYNOPSIS

Return a integer wuth dimensions of array

// SAMPLES
$x = Array-Rand $a


#>
function Array-Rank ( $xArray )
	{
	"2DO***"

	}





<#
.SYNOPSIS

Remove an element to array
if element exists in array
return index of removed element or -1 for none

// SAMPLES
Array-Remove $a "1"
Array-Remove $a "22"
Array-Remove $a "333"


#>
function Array-Remove ( $xArray, $xItem = $null )
	{
	# ArrayList remove is 'silent'
	# no error if $xItem is not in list
	# return as array
	$x = [System.Collections.ArrayList]$xArray;
	$x.Remove( $xItem )
	return , $x;
	}



# Saves a HashTable into a table (.dat) 
function Array-Save()
	{
	
	}



<#
.SYNOPSIS

CIRCULAR	

RETURN
	$xPos if match
	-1 is no match ( ?REFACTOR to ?-1 )

#>
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



<#
.SYNOPSIS

CIRCULAR	

#>
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
.SYNOPSIS
~

Sort an Array
Faster then Sort-Object

ATT** REFACTOR
Clone to avoid mutating the paramenter until best solution is found
skip overloading functions but elements should be all of the same type
or STRAGENESS will appear

alternative...
[linq.enumerable]::orderby( [int[]]$, [func[int,int]]{ $args[0] } )
[linq.enumerable]::orderby( [string[]]$, [func[string,string]]{ $args[0] } )

~
#>
function Array-Sort( $xArray )
	{
	$xTemp = $xArray.Clone();
	[System.Array]::Sort( $xTemp );
	return $xTemp;
	}



<#
.SYNOPSIS
~

Convert to ArrayList
so methods like Add/Remove can be used on data
ATT*** ArrayList is an array of objects
so less efficient

// SAMPLE
$l = Array-toArrayList $a


~
#>
function Array-toArrayList( $xArray )
	{
	return ,[System.Collections.ArrayList]$xArray
	}


<#
.SYNOPSIS
~

so .net List Methods/Funcionality 
can be used on data...

// SAMPLE
$l = Array-toList $a

~
#>
function Array-toList( $xArray )
	{
	# return [LINQ.Enumerable]::Distinct( [object[]] $xArray )
	"2do***"

	}




<#
.SYNOPSIS
~

Return a Hashtable/Buckets of objects in array
grouped by/from a object-data-member
Group property is removed from objects in sub-arrays

// SAMPLES
$aa = Array-Group $a "Group"
$aa = Array-Group -xArray $a -xMember "Group"

~
#>
function Array-toHashgroup( $xArray, $xItem )
	{
	
	# ?xArray has elements || break
	if ( $null -eq $xArray ){ throw "AAA/Array-Group ~> Array is null or empty..."  }

	# Get Array of existing Fields/Properies in first object
	$xProps = Object-Properties $xArray[0]

	# ?xItem is valid || exit
	if ( $xItem -notin $xProps ){ "AAA/Array-Group ~> item field not in Array objects..."  } 

	#	1.	Grab an array of unique items for buckets
	#	2.	Get a hashtable of unique buckets
	#	3.	Remove "Grouping-item" from fields to produce sub-arrays
	#
	$xItems  = Array-Unique      -xArray $xArray.$xItem;
	$xHash   = Array-toHashtable -xArray $xItems;
	$xFields = Array-Remove      -xArray $xProps -xItem $xItem;

	each `
		-xData $xArray `
		-xLambda { $xHash[ $_.Group ] += @( $_ | Select-Object -Property $xFields ) }
	
	return $xHash;
	}



<#
.SYNOPSIS
~

Produce a hashtable/ordered from a array
Optionally pass a argument for elements initialization (default is null)

// SAMPLE
$h = Array-toHashtable $a
$h = Array-toHashtable $a $item

~
#>
function Array-toHashtable( $xArray, $xItem = $null )
	{
	$x = [ordered]@{};
	$xArray.foreach( { $x.Add( $_, $null) } );
	return $x;
	}



<#
.SYNOPSIS
~

Drop repetead elements
first fount elements are maintainded
last elements are dropped

~
#>
function Array-Unique( $xArray )
	{
	return [LINQ.Enumerable]::Distinct( [object[]] $xArray )
	}
