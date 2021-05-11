# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |_|_| * AAA Code/Data Program/REPL Interface Template
#
#	1.	Copy all code below to new *.psm1 library
#	2.	replace all "AA-" with the new Class-Name
#	3.	Delete non-usable methods (mainly -On/-Off)
#	4.	Extend the Class as 
#


Set-StrictMode -Version 5;
# Add-Type -AssemblyName "System.Web"; # for Mime types
# RequiredAssemblies = @( "Microsoft.HyperV.PowerShell.Objects" );



# ATT***
#
# QUIRK*** so we can use the [_AA]/METADATA type 
#
# QUIRK*** 
# . see final code-line 
# . if desired OBJECT-DEFAULT-INITIALIZATION on MODULE-1ST-INCLUDE
# . alas a default object o
#
# ATT*** to module nesting
# remove comment only when in a new module
# using module C:\dat\PowerShell\AAA\AA.psm1;


<#
.SYNOPSIS
~

AAA/Advanced Artifact Template

	About .... Objective/Usage quick overview
	New ...... Creates a new object, put at use, return reference
	Object ... Returns current object reference
	Test ..... Quick test framework (assert for...)

	On/Off ... Activate/Deactivate object (for event processors, ...)

	State .... ?
	Status ... ?

	* AVAILABLE VERBS
	List ..... Display in Text/Tabular format
	Show ..... Bring to visibility
	View ..... 
	+
	Get/Set ...... use if controlling a sub-object (like a VM)
	Start/Stop ... if needs aditional control other then On/Off
	Load/Save .... Store/Retrieve state/data/...
	Read/Write ...
	Peek/Poke ....
	In/Out .......
	+
	Create ... use for sub-object... New is for <this> objects
	Select ...
	Catch ....
	Grab .....



~
#>
function AA- { AAA-Functions }



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  _AA
#	Metaclass for AA/Type object 
#	so some general function/state can be hold in a AA/Object ( $x._AA )
#	providing some separation from the specific implementation (AV/DB/FS/VM/...)
#	like name, credential, date-of-creation, etc. 
#
#	Holds metadata for current object,,,  at least:
#	xData is the object date of inception
#	xName is the object name
#	xCredential is obtained from the AAA/System default credential (if defined)
#
class _AA
	{

	# Name will be set by DB-New if necessaire
	# or passed to the "_AA-Owner-Object" constructor and set there
	[string] $xName;
	[datetime] $xDate = (Get-Date)
	[ipaddress] $xConnect;
	[pscredential] $xCredential = $AAA.System.Credential;

	# for now a constructor is not need
	# _AA(){}

	}




# to RENAME to SPECIFIC [??_]::$object
class AA_
	{
	# holds the current SPECIFIC [??_]::$object
	# and interactive functionality 
	static [AA_] $object = $null;

	# this is for AA metadata
	[_AA]$_AA = [_AA]::new();


	# SPECIFIC CLASS/TYPE PROPERTIES


	# ctor expose for clean AV object return
	# in v5 PS has no constructor chainning
	# so no overloads here has not much advantage
	# let's opt-in for basic constructor
	AA_() 
		{ 
		# SHARED/STATIC holds the last/current object	
		[AA_]::Object = $this;

		# Metadata
		$this._AA.xDate = Get-Date;
		$this._AA.xCredential = $global:AAA.System.Credential;
		
		# constructor "default return" is the "instantiated object"
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

If defined...
is called from AAA-Functions
before listing available methods...

~
#>
function AA-About()
	{
	"
	AA -> Advanced Artifact


	* notes
	* notes+
	...
	"
	}



<#
.SYNOPSIS
~

Show the help page...

~
#>
function AA-Help( )
	{ 
	Get-Help -Category function -Name AA- -ShowWindow;
	}






<#
.SYNOPSIS
~

Create a new object of this kind...
and make it current

Return the newly created reference...

~
#>
function AA-New()
	{
	# object inception/instantiation
	# SHARED $this::object and other METADATA/_AA (time, credential, ...)
	# is assigned in the contructor
	$x = [AA_]::new()

	# ...+OBJECT INITIATION

	return $x; 
	}




<#
.SYNOPSIS
~

GET/SET the current object

Return the current new AA_ object 
[AA_]::$object

~
#>
function AA-Object( $xObject = $null )
	{ 
	
	if ( $null -eq $xObject  ) 
		{ 
		# no argument...
		# so... get the Current object
		if ( $null -eq [AA_]::object ){ "No current AA- object" }; 
		return [AA_]::object;
	
		}
	else
		{
		# set new object
		# ?return former object
		}

	}






<#
.SYNOPSIS
~

Activate the object...

~
#>
function AA-On( [AA_]$xObject = [AA_]::object )
	{
	if( $null -eq $xObject ){ throw "AA-On ~> no Object defined..." }



	}


<#
.SYNOPSIS
~

Deactivate the object...

~
#>
function AA-Off( [AA_]$xObject = [AA_]::object )
	{ 
	

	}



<#
.SYNOPSIS
~

State display...

State refers to internal data

~
#>
function AA-State( [AA_]$xObject = [AA_]::object )
	{ 
	
	# 2DO***
	# Customize the STATE output for this object
	if ( $null -eq $xObject ){ throw "AA-State ~> no selected object..." }
	$xObject;

	}




<#
.SYNOPSIS
~

Status display...

Status refers to usage/relations with other objects

* default is current object

~
#>
function AA-Status( [AA_]$xObject = [AA_]::object )
	{ 
	
	# 2DO***
	# Customize the STATUS output for this object
	if ( $null -eq $xObject ){ throw "AA-State ~> no selected object..." }
	$xObject;

	}



<#
.SYNOPSIS
~

Tests
to provide a simple test framework
and assert for incoherences

~
#>
function AA-Test( [AA_]$xObject = [AA_]::object )
	{ 
	'''
	Simple test framework
	Asserting for incohereces

	Define your more critical 
	centralize here a global call 
	to all tests considered critical
	applied over the current object...
	'''

	}


# AA-New -xName "<aa-default>"
