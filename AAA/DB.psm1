# QUIRK*** so we can use the [_AA]/METADATA type
# QUIRK*** see final code-line for MODULE-INCLUDE 1st initialization
using module C:\dat\PowerShell\AAA\AA.psm1;


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |D|B|
#

<#
.SYNOPSiS
+

Generic REPL/Script interface (façade) for Databases
MSSQL, MySQL, PostGRES, MongoDB, ...

pattern <Dependency Injection> of Database engine
pattern <Factory for DB engine>

Mechanics
	* DB.psm1
	* is loaded by .profile
	* proposed future remoting host features
	* has a DOS/batch counterpart DB- for out-Powershell funcionality

Classes
	Dataset-
	Datatable-
	Datacolumn(s)
	Datarow(s)


DB-
	@( -host xHost )
	+
	-List ....... ask DB engine for databases
	-Open ....... -name ~> create object and store propertties
	-Insert ..... -name -> create a new Database
	-Remove ..... -name -> delete a database 
	-TransOn .... Transaction open
	-TransOff ... Transactioon close

DB-Table- | xDB.Table( <name> )
	@( -host xHost, -table xTable )
	+
	-FieldId ... field used for Id/unique (none means not unique)
	-Get ....... get one object
	-Find ...... -name/regex
	-List ...... get collection of objects
	-Insert .... -name
	-Remove .... -name

DB-Table-Record- | Database-Record | xDB.Table( <name> ).Record
	@( -host xHost, -table xTable)
	+
	-Get ...... by ID, use Table.FieldId
	-Set ......
	+
	-Active ... ?last
	-Find ..... { Q.e.D }


DB-Table-Record-Field- | Database-Field | xDB.Field( <name> )
	@( -host xHost, -table xTable, -record id )
	* atomic value
	+
	-List
	-Find
	-Value ... 

#>
function DB- { AAA-Functions }

Set-StrictMode -Version 5;
Add-Type -AssemblyName System.Data

#enums
enum DB_Field_Types { string; number; date; blob; }


class DB_
	{
	# holds the current object
	# for all methods and interactive functionality
	static [DB_] $object = $null;

	# metadata for current object,,,  at least:
	# xName is the object name
	# xDate is the object date of inception
	# xCredential is obtained from the AAA/System default credential (if defined)
	[_AA]$_AA = [_AA]::new();

	# Selected ~> Dataset | Table | Column | Row
	[System.Data.DataSet]    $xDataset
	[System.Data.DataTable]  $xTable;
	[System.Data.DataColumn] $xColumn;
	[System.Data.DataRow]    $xRow;

	# ctor expose for clean AV object return
	# in v5 PS has no constructor chainning
	# so no overloads here has not much advantage
	# let's opt-in for basic constructor
	DB_( $xName ) 
		{ 	
		[DB_]::Object = $this;
		$this._AA.xName = $xName;
		# constructor "default return" is the instantiated object
		}


	# turn listening On...
	On()
		{   }


	# turn listening Off...
	Off() 
		{   }


	<#
	
	#>
	State()
		{ 
		$x = "";
		$x += "Name is <{0}>`n" -f $this.Name;
		$x += "Created for <{0}\{1}>`n" -f  $this.Host, $this.Credential;
		$x += "at {0}`n" -f $this.Birth;
		$x += "alive for {0}`n" -f ( (Get-Date) - $this.Birth );

		Write-Host $x
		}
	
	Status() 
		{
		
		}


	}




<#
.SYNOPSIS
~

Information about current/sected/argumented Database

(i) informational only
return $true/$false

>DB-Dictionary
>DB-Dictionary-New

Samples:
	DB					* from current DB
	DB -xDB $xDB		* from argumented DB

~
#>
function DB( [DB_]$xDB = [DB_]::object )
	{
	if ( $null -eq $xDB ) 
		{
		throw "DB ~> no active database... ?Odd??";
		return $false
		}
	
	"{0} ({1})" -f $xDB._AA.xName, $xDB._AA.xDate;
	if( $xDB.xTable  ) { $xDB.xTable.TableName;  } else { "xTable  <none>..." };
	if( $xDB.xColumn ) { $xDB.xColumn.ColumnName } else { "xColumn <none>..." };
	if( $xDB.xRow    ) { $xDB.xRow }               else { "xRow    <none>..." }
	
	return $true;
	}




<#
.SYNOPSIS

If defined...
is called from ADB-Functions
before listing available methods...


#>
function DB-About
	{
	"
	DB -> Advanced Artifact

	DB-Help for more detailed assistance

	* notes
	* notes+
	...
	"
	}


<#
.SYNOPSIS
~

Information about current/selected column 

Database + Table + Data


Sample:
DB-Column					* from current DB
DB-Column -xDB $xDB			* from argumented DB

~
#>
function DB-Column( [DB_]$xDB = [DB_]::object )
	{
	if ( $null -eq $xDB.xColumn ) { throw "DB-Row ~> no active column..." }
	return $xDB.xColumn;
	}




<#
.SYNOPSIS
~

Create a new column with minimum properties ( name, type )
and add to current/selected table...
returns reference to the column

Samples:
	DB-Column-New
	DB-Column-New -xName id -xType [int32]

	Create/return a new Column object


~
#>
function DB-Column-New( [string]$xName, [System.Type]$xType = [string] )
	{
	# NAME is mandatory, type defaults to string
	if ( $null -eq $xName ){ throw "DB-Column ~> invalid name..." }
	if ( $null -eq [DB_]::object.xTable ){ throw "DB-Column ~> no selected table..." }

	# create and add to selected table
	$x = [System.Data.DataColumn]::new( $xName, $xType );
	[DB_]::object.xColumn = $x;
	[DB_]::object.xTable.Columns.Add( $x );
	return $x
	}



<#
.SYNOPSIS

Current database offline/cache dataset

#>
function DB-Dataset()
	{
	
	}


<#
.SYNOPSIS

Edit/Create the current data dictionary
Load

#>
function DB-Dictionary()
	{
	
	}



<#
.SYNOPSIS

Create a new current data dictionary
Name | Type | Size | Inc/Uniq/Lookup/??? | Mask

Uses:
	enum DB_Dictionary_Types { string; value; date; text; image; }
#>
function DB-Dictionary-New()
	{
	# $a = @( @( "id", 1, 0, "" ), @( "name", 0, 20, "@a" )  )
	
	
	}



<#
.SYNOPSIS
Show the help page...

#>
function DB-Help( ){ Get-Help -Category function -Name DB- -ShowWindow; }



<#
.SYNOPSIS
~

Create a new Database object
and set it as the current one!

Minimum command line use needs a <default> object instantiated
so the inclusion of the library creates one...

the reference is stored as a "shared member"
so it can be obtained via [DB_]::object;


Sample:
	DB-New
	DB-New -xName "db0"

~
#>
function DB-New( $xName )
	{
	# for the moment,
	# we will require the unique constructor has a name parameter...
	if ( [string]::IsNullOrEmpty( $xName) )
		{ throw "DB-New needs a name for the database..." }

	# permit Save in variable or chain
	return 	[DB_]::new( $xName );
	}




<#
.SYNOPSIS
GET/SET the current object

Return the current/selected object 
[??]::$object

#>
function DB-Object()
	{ 
	
	if ( $null -eq [DB_]::object ) 
		{ throw "DB-Object ~> No current object..." } 
	else 
		{ return [DB_]::object; }

	}






<#
.SYNOPSIS
Start listening for requests...

#>
function DB-On( [DB_]$xObject )
	{
	if( $null -eq $xObject ){  }
	


	}


<#
.SYNOPSIS
Stop listening for requests...

#>
function DB-Off( [DB_]$xObject )
	{ 
	

	}




<#
.SYNOPSIS
~

Information about current/selected row

Database + Table + Data


Sample:
	DB-Row					* from current DB
	DB-Row -xDB $xDB		* from a designated DB

~
#>
function DB-Row( [DB_]$xDB = [DB_]::object )
	{
	if ( $null -eq $xDB.xRow ) { throw "DB-Row ~> no active row..." }
	return $xDB.xRow;
	}


<#
.SYNOPSIS


Return <Current-Row> -at- <Curretn-Table> object


#>
function DB-Row-New( [DB_]$xObject )
	{ 
	

	}




<#
.SYNOPSIS
State display...

State refers to internal data

#>
function DB-State( [DB_]$xObject )
	{ 
	

	}




<#
.SYNOPSIS
~

Status display...

Status refers to external usage

~
#>
function DB-Status( [DB_]$xObject )
	{ 
	

	}



<#
.SYNOPSIS
~

Information about current/sected table

>DB-Dictionary
>DB-Dictionary-New

Samples:
	DB-Table				* from current DB
	DB-table -xDB $xDB		* from a designated DB
~
#>
function DB-Table( [DB_]$xDB = [DB_]::object )
	{
	if ( $null -eq $xDB.xTable ) { throw "DB-Row ~> no active table..." }

	# unrap or you will receive a [object]
	# instead of a [datatable]
	return ,$xDB.xTable;
	}




<#
.SYNOPSIS
~

Create/Select/Return a new table
Fields are built if a Dictionary is provided...

Samples:
	DB-Table-New "Table1"
	DB-Table-New "Table1", $xDic1

>DB-Dictionary-New

~
#>
function DB-Table-New( $xName = "Table", $xDic = $null )
	{
	# Create/Select current table
	$x = [System.Data.DataTable]::new( $xName );
	[DB_]::object.xTable = $x;

	# ATT***
	# QUIRK***
	# the Powershell collateral damage of try to unrap arrays...
	# apparently it considers the Datatable.Rows for unrap
	return ,$x;
	}




<#
.SYNOPSIS
~

Load a table from a file

~
#>
function DB-Table-Load(  )
	{ 

	}


<#
.SYNOPSIS

Save a table to a file
#>

function DB-Table-Save(  )
	{ 

	}




<#
.SYNOPSIS
Tests

#>
function DB-Test( [DB_]$xDB = [DB_]::object )
	{ 

	# Simple test framework
	# Assert for incohereces



	}


<#
Here DB_::object must exist (is the current DB)

and now defining this table we set the current table also
?or opt-to define the dictiory first and then the table


#>
function DB-Test-t1ent( [DB_]$xDB = [DB_]::object )
	{ 
	
	# Create/Select a table
	$x = DB-Table-New -xName 't1ent';

	# Create/Select columns
	DB-Column-New -xName id     -xType ([Int32 ]) | Out-Null;
	DB-Column-New -xName name   -xType ([string]) | Out-Null;
	DB-Column-New -xName value  -xType ([float ]) | Out-Null;

	DB-Column-New -xName valueX -xType ([float ]) | Out-Null;
	(DB-Column).Expression = "id * id";

	DB-Column-New -xName valueXX -xType ([float ]) | Out-Null;
	(DB-Column).Expression = "valueX * id";

	DB-Column-New -xName valueXXX -xType ([float ]) | Out-Null;
	(DB-Column).Expression = "count(id)";



	# $xx = DB-Column; $xx.Expression = "id * 2";
	# ([System.Data.DataColumn](DB-Column)).Expression = "id * 2";

	$x.Rows.Add( "1", "Maria" )
	$x.Rows.Add( "2", "Manela" )
	$x.Rows.Add( "3", "Jakina" )

	# prevent Powershell unfold rows
	return ,$x;
	}


DB-New -xName "<db-default>"

