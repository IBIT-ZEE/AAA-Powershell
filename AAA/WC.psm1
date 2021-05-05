# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |_|_| * AAA/WC Windows Components
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
	Catch ....
	Grab .....



~
#>
function WC- { AAA-Functions }



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
	# or passed to the "_WC-Owner-Object" constructor and set there
	[string] $xName;
	[datetime] $xDate = (Get-Date)
	[pscredential] $xCredential = $AAA.System.Credential;

	# for now a constructor is not need
	# _AA(){}

	}




# to RENAME to SPECIFIC [??_]::$object
class WC_
	{
	# holds the current SPECIFIC [??_]::$object
	# and interactive functionality 
	static [WC_] $object = $null;

	# this is for AA metadata
	[_AA]$_AA = [_AA]::new();


	# SPECIFIC CLASS/TYPE PROPERTIES


	# ctor expose for clean AV object return
	# in v5 PS has no constructor chainning
	# so no overloads here has not much advantage
	# let's opt-in for basic constructor
	WC_() 
		{ 
		# SHARED/STATIC holds the last/current object	
		[WC_]::Object = $this;

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
is called from AWC-Functions
before listing available methods...

~
#>
function WC-About()
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
function WC-Help( )
	{ 
	Get-Help -Category function -Name WC- -ShowWindow;
	}






<#
.SYNOPSIS
~

Create a new object of this kind...
and make it current

Return the newly created reference...

~
#>
function WC-New()
	{
	# object inception/instantiation
	# SHARED $this::object and other METADATA/_AA (time, credential, ...)
	# is assigned in the contructor
	$x = [WC_]::new()

	# ...+OBJECT INITIATION

	return $x; 
	}




<#
.SYNOPSIS
~

GET/SET the current object

Return the current new WC_ object 
[WC_]::$object

~
#>
function WC-Object( $xObject = $null )
	{ 
	
	if ( $null -eq $xObject  ) 
		{ 
		# no argument...
		# so... get the Current object
		if ( $null -eq [WC_]::object ){ "No current WC- object" }; 
		return [WC_]::object;
	
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
function WC-On( [WC_]$xObject = [WC_]::object )
	{
	if( $null -eq $xObject ){ throw "WC-On ~> no Object defined..." }



	}


<#
.SYNOPSIS
~

Deactivate the object...

~
#>
function WC-Off( [WC_]$xObject = [WC_]::object )
	{ 
	

	}



<#
.SYNOPSIS
~

State display...

State refers to internal data

~
#>
function WC-State( [WC_]$xObject = [WC_]::object )
	{ 
	
	# 2DO***
	# Customize the STATE output for this object
	if ( $null -eq $xObject ){ throw "WC-State ~> no selected object..." }
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
function WC-Status( [WC_]$xObject = [WC_]::object )
	{ 
	
	# 2DO***
	# Customize the STATUS output for this object
	if ( $null -eq $xObject ){ throw "WC-State ~> no selected object..." }
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
function WC-Test( [WC_]$xObject = [WC_]::object )
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


# WC-New -xName "<aa-default>"
