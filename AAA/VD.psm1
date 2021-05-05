# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |V|D| * Virtual Drivers / VHD/VHDX ...
#




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |_|_| * AAA Code/Data Program/REPL Interface Template
#
#	1.	Copy all code below to new *.psm1 library
#	2.	replace all "VD-" with the new Class-Name
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
	+
	Create ... use for sub-object... New is for <this> objects
	Select ...



~
#>
function VD- { AAA-Functions }



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
	# or passed to the "_VD-Owner-Object" constructor and set there
	[string] $xName;
	[datetime] $xDate = (Get-Date)
	[pscredential] $xCredential = $AAA.System.Credential;

	# for now a constructor is not need
	# _AA(){}

	}




# to RENAME to SPECIFIC [??_]::$object
class VD_
	{
	# holds the current SPECIFIC [??_]::$object
	# and interactive functionality 
	static [VD_] $object = $null;

	# this is for AA metadata
	[_AA]$_AA = [_AA]::new();


	# SPECIFIC CLASS/TYPE PROPERTIES


	# ctor expose for clean AV object return
	# in v5 PS has no constructor chainning
	# so no overloads here has not much advantage
	# let's opt-in for basic constructor
	VD_() 
		{ 
		# SHARED/STATIC holds the last/current object	
		[VD_]::Object = $this;

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
is called from AVD-Functions
before listing available methods...

~
#>
function VD-About()
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
function VD-Help( )
	{ 
	Get-Help -Category function -Name VD- -ShowWindow;
	}






<#
.SYNOPSIS
~

Create a new object of this kind...
and make it current

Return the newly created reference...

~
#>
function VD-New()
	{
	# object inception/instantiation
	# SHARED $this::object and other METADATA/_AA (time, credential, ...)
	# is assigned in the contructor
	$x = [VD_]::new()

	# ...+OBJECT INITIATION

	return $x; 
	}




<#
.SYNOPSIS
~

GET/SET the current object

Return the current new VD_ object 
[VD_]::$object

~
#>
function VD-Object( $xObject = $null )
	{ 
	
	if ( $null -eq $xObject  ) 
		{ 
		# no argument...
		# so... get the Current object
		if ( $null -eq [VD_]::object ){ "No current VD- object" }; 
		return [VD_]::object;
	
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
function VD-On( [VD_]$xObject = [VD_]::object )
	{
	if( $null -eq $xObject ){ throw "VD-On ~> no Object defined..." }



	}


<#
.SYNOPSIS
~

Deactivate the object...

~
#>
function VD-Off( [VD_]$xObject = [VD_]::object )
	{ 
	

	}



<#
.SYNOPSIS
~

State display...

State refers to internal data

~
#>
function VD-State( [VD_]$xObject = [VD_]::object )
	{ 
	
	# 2DO***
	# Customize the STATE output for this object
	if ( $null -eq $xObject ){ throw "VD-State ~> no selected object..." }
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
function VD-Status( [VD_]$xObject = [VD_]::object )
	{ 
	
	# 2DO***
	# Customize the STATUS output for this object
	if ( $null -eq $xObject ){ throw "VD-State ~> no selected object..." }
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
function VD-Test( [VD_]$xObject = [VD_]::object )
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


# VD-New -xName "<aa-default>"
