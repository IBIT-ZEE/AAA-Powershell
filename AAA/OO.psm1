
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
.SyNOPSIS
~

...

~
#>
function Object-isNull( $xObject ) { $null -eq $xObject }


<#
.SyNOPSIS
~

Array of object properties names

~
#>
function Object-Properties( $xObject ) 
	{ return (  $xObject | Get-Member -Type NoteProperty ).name }


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
~

for AAA/DataX parser
Flat-Table~Text/IO processor

1st line has object <grouper> field name/descriptor
2nd line has restant object fields name/descriptors

Elements after <New-Line> is a <group>er
Tab delimits fields
+
Comments are ignored
Empty lines are discarded
Whitespace at beginning is ignored (can indent at will)
+
Non present text element results in a $null (PS will convert to 'default' value)
Extra text elements are discarded

>Array-Load/Save

// SAMPLE
	Object-Flatin $xText


~
#>
function Object-Flatin( [string]$xString )
	{
	$x = "";
	$xx = @();

	# get 1st + 2nd lines to inceptualize object model
	#

	#Process lines
	foreach ( $x in $xString ) 
		{ 
		# discard comments
		if ( $x -match '^\s+//' ){ continue }


		}; 

	return $x;
	}



<#
.SYNOPSIS
~

Fold/Unfold hierarchyc text (tab ranked)
into a object tree...

comments "//" are ignored


// SAMPLE
	String-Fold $x
	$x = String-Unfold


~
#>
function Object-Flatout( [string]$xString )
{
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
	
