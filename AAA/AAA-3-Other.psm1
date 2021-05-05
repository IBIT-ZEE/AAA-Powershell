<#

#>


Set-StrictMode -Version 5;

# Add-Type -AssemblyName System.Data




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |D|A|T|A|*|
#  |D|A|T|A|S|E|T|
#  |D|A|T|A|T|A|B|L|E|
#  |D|A|T|A|C|O|L|U|M|N|
#
<#

#>


<#
.SYNOPSiS

#>
function Dataset- { AAA-Functions }




<#
.SYNOPSiS


#>
function Datatable- { AAA-Functions }


<#
.SYNOPSiS


#>
function Datatable-Load( $xName ) 
	{  }



function Datatable-Test- { AAA-Functions }


function Datatable-Test-T1Ent()
	{ 
	$xTable = [System.Data.DataTable]::new( "t1ent" );

	$xID = [System.Data.DataColumn]::new( "id", [Int32] );
	$xID.AutoIncrement = true;		# *seed=0 *step=1
	$xID.ReadOnly = $true;
	$xName  = [System.Data.DataColumn]::new( "name" , [string]   );
	$xValue = [System.Data.DataColumn]::new( "value", [int32]    );
	$xDate  = [System.Data.DataColumn]::new( "date" , [datetime] );
	$xObs   = [System.Data.DataColumn]::new( "Obs"  , [string]   );
	$xFlag  = [System.Data.DataColumn]::new( "flag" , [boolean]  );
	
	$xTable.Columns.Add( $xId    );
	$xTable.Columns.Add( $xName  );
	$xTable.Columns.Add( $xDate  );
	$xTable.Columns.Add( $xValue );
	$xTable.Columns.Add( $xObs   );
	$xTable.Columns.Add( $xFlag  );
		
	return ,$xTable;
	}


function Datatable-Test-T2Obj()
	{
	$xTable = [System.Data.DataTable]::new( "t2obj" );

	$xID = [System.Data.DataColumn]::new( "id", [Int32] );
	$xID.AutoIncrement = true;		# *seed=0 *step=1
	$xID.ReadOnly = $true;
	$xName  = [System.Data.DataColumn]::new( "name" , [string]   );
	$xValue = [System.Data.DataColumn]::new( "value", [int32]    );
	$xDate  = [System.Data.DataColumn]::new( "date" , [datetime] );
	$xObs   = [System.Data.DataColumn]::new( "Obs"  , [string]   );
	$xFlag  = [System.Data.DataColumn]::new( "flag" , [boolean]  );
	
	$xTable.Columns.Add( $xId    );
	$xTable.Columns.Add( $xName  );
	$xTable.Columns.Add( $xDate  );
	$xTable.Columns.Add( $xValue );
	$xTable.Columns.Add( $xObs   );
	$xTable.Columns.Add( $xFlag  );
		
	return ,$xTable;
	}

function Datatable-Test-T3Doc()
	{

	}


function Datatable-Test-T4DocX()
	{
	
	}

function Datatable-Test-T5Tabs()
	{
	
	}


<#
.SYNOPSiS


#>
function Datatable-Column( $xName, $xType = [string] ) 
	{  
	
	}


<#
.SYNOPSiS

#>
function Datatable-Columns( $xName ) 
	{  
	
	}



<#
.SYNOPSiS


#>
function Datagrid- { AAA-Functions }



<#
.SYNOPSiS


#>
function Datagrid-New( $xTable )
	{ 

	# Formm
	$xForm = [System.Windows.Forms.Form]::new();

	# Datagrid
	$xGrid = [System.Windows.Forms.DataGridView]::new()
	$xGrid.Dock = [System.Windows.Forms.DockStyle]::Fill
	$xGrid.DataSource = $xTable

	# PopUp
	$xPopup = [System.Windows.Forms.ContextMenuStrip]::new()
	$xGrid.ContextMenuStrip = $xPopup

	$xForm.Controls.Add( $xGrid );
	$xForm.ShowDialog();

	}




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |H|A|S|H
#



<#
RSA
sha1 SHA256/32b SHA512
...

#>
function Hash- { AAA-Functions }



function Hash-sha256( [string]$x )
	{
	return `
		[System.Convert]::ToHexString( 
			[System.Security.Cryptography.SHA256]::HashData( $x.ToCharArray() )
			)
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




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |S|T|R|I|N|G|
#
#
<#
.SYNOPSIS.
? Grow 
? Invert sinle/multiple
? Inflate/Deflate
? Clone/Cloner -vs- Replicate ?! single/multiple
? Add/Subtract -vs- Append/Remove

? Strings-* or String overload ??

#>
function Pattern-  { AAA-Functions }


<#
-xString/auto="_" as the pattern to replicate
-xSize/auto=<console-width> ???implement
String-Replicate is invoked...
[string][char]196 ?ASCII ?UNICODE
#>
function Pattern-Line( $xString = "_" ) 
	{ 
	[int]$xTimes = $Host.UI.RawUI.WindowSize.Width / $xString.Length
	return String-Fit $xString $xTimes;
	}



<#

#>
function Pattern-Artifact( [int]$xSize ) 
	{
	return "2DO***";
	}




<#
.SYNOPSIS
Text/ASCII pattern
Simulating isometric perspective floor

* argument how many screen (actual console width) lines you want

#>
function Pattern-Floor( [int] $xLines = 1 ) 
	{ return "__/" * ( $Host.UI.RawUI.WindowSize.Width / 3 * $xLines ) }



<#

#>
function Pattern-Hexer( $xLines = 1 )
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
function Pattern-Piramid( $xString = "*", $xLines = 3, $xWidth )
	{
	$xData = 0


	}


<#

#>
function Pattern-Random( [int]$xSize ) 
	{

	$xData = "";
	for( $x = 0; $x -lt $xSize; $x++ )
		{  
		$a = Get-Random -Minimum 32 -Maximum 254;
		$xData += [char] $a;
		} 

	return $xData;
	}



<#
String[] stair of pattern
-xLines
-xwidth
#>
function Pattern-Stair( $xString = "*", $xLines = 3, $xWidth )
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
#  |W|W|W| * WWW
#


function WWW- { AAA-Functions }


function WWW-Info { Invoke-RestMethod -Uri http://ipinfo.io }


