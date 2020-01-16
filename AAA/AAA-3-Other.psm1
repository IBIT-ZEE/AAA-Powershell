<#

#>


Set-StrictMode -Version 5;








# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |D|A|T|A|B|A|S|E|
#
<#
Generic interface (façade) for MSSQL, MySQL, PostGRES, MongoDB, ...

Database-
	@( -host xHost )
	+
	-List ....... ask DB engine for databases
	-Open ....... -name ~> create object and store propertties
	-Insert ..... -name -> create a new Database
	-Remove ..... -name -> delete a database 
	-TransOn .... Transaction open
	-TransOff ... Transactioon close

Database-Table- | xDB.Table( <name> )
	@( -host xHost, -table xTable )
	+
	-FieldId ... field used for Id/unique (none means not unique)
	-Get ....... get one object
	-Find ...... -name/regex
	-List ...... get collection of objects
	-Insert .... -name
	-Remove .... -name

Database-Table-Record- | Database-Record | xDB.Table( <name> ).Record
	@( -host xHost, -table xTable)
	+
	-Active ... ?last
	-Get ...... by ID, use Table.FieldId
	-Find ..... { Q.e.D }

Database-Table-Record-Field- | Database-Field | xDB.Field( <name> )
	@( -host xHost, -table xTable, -record id )
	* atomic value
	+
	-List
	-Find
	-Value ... 

#>


function Database- { AAA-Functions }



function Database-Object 
	{  

	}





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |M|O|N|G|O|
#


function Mongo- { AAA-Functions }



<#

#>
function Mongo-Object 
	{  

	}



<#

#>
function Mongo-Database- { AAA-Functions }



<#

#>
function Mongo-Database-List 
	{ 
	
	}



<#

#>
function Mongo-Database-Open
	{ 
	
	}








# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |M|S|S|Q|L| * MSSQL
#


function MSSQL- { AAA-Functions }



function MSSQL-Object 
	{  

	}












# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |M|Y|S|Q|L| * MySQL
#


function MySQL- { AAA-Functions }

function MySQL-On {}

function MySQL-Off {}


function MySQL-Open { "xxx" }



<#
-xString/auto="_" as the pattern to replicate
-xSize/auto=<console-width> ???implement
String-Replicate is invoked...
[string][char]196 ?ASCII ?UNICODE
#>
function String-Line( $xString = "_" ) 
	{ 
	[int]$xTimes = $Host.UI.RawUI.WindowSize.Width / $xString.Length
	return String-Replicate $xString $xTimes;
	}



function String-Pattern-Artifact( [int] $xSize ) 
	{

	$xData = "";
	for( $x = 0; $x -lt $xSize; $x++ )
		{  
		$a = Get-Random -Minimum 32 -Maximum 254;
		$xFinal += [char] $a;
		} 

	return $xFinal;
	}


function String-Pattern- { AAA-List }


function String-Pattern-Floor( [int] $xLines = 1 ) 
	{ return "__/" * ( $Host.UI.RawUI.WindowSize.Width / 3 * $xLines ) }



<#

#>
function String-Pattern-Hexer( $xLines = 1 )
	{ 
	[int]$x = $Host.UI.RawUI.WindowSize.Width / 4;
	$xLine = "";
	$xLine += "/  \" * $x; 	
	$xLine += "\__/" * $x;
	
	return $xLine * $xLines;
	}




<#
String-Pattern-Stair + String-Center
#>
function String-Pattern-Piramid( $xString = "*", $xLines = 3, $xWidth )
	{
	$xData = 0


	}



<#
String[] stair of pattern
-xLines
-xwidth
#>
function String-Pattern-Stair( $xString = "*", $xLines = 3, $xWidth )
	{
	
	# AUTO-WIDTH
	if ( $xWidth -eq $null){ $xWidth = $Host.UI.RawUI.WindowSize.Width }

	--$xLines;
	$xGrowth  = [Math]::Floor( $xWidth / $xLines );
	$xGrowing = [Math]::Floor( $xGrowth / $xString.Length );

	# 1ST LINE IS ALWAYS 1-PATTERN-UNIT
	$xData = @();
	$xData += $xString;

	for( $x = 1; $x -lt $xLines; $x++ )
		{ $xData += ( $xString * $xGrowing ) * $x;	}

	# 1ST LINE IS ALWAYS FULL-LINE-LENGHT
	# EXCEED THEN TRUNCATE TO FIX DIVISION ROUND FAULTS
	$xData += ( $xString * $xGrowing * ++$xLines ).Substring( 0, $xWidth );
	return $xData;
	}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |V|M| * Hyper-V
#

function VM- { AAA-List }
	
<#
Will return a VM object to hold state (currying)
and still use the VM-* functions
#>
function VM-New { return [VM]::new();  }

class VM 
	{ 
	[string]$xHost     = ".";
	[string]$xUser     = "";
	[string]$xPassword = "";

	# Startup the VM
	On() {}

	# Shutdown the VM
	Off() {}

	# Connect the console
	Show(){}

	# Disconnect the console
	Hide(){}


	}





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |W|W|W| * WWW
#


function WWW- { AAA-Functions }


function WWW-Info { Invoke-RestMethod -Uri http://ipinfo.io }


