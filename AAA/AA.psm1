# QUIRK*** so we can use the [_AA]/METADATA type 
# QUIRK*** see final code-line if desired MODULE-INCLUDE-1ST-INITIALIZATION
# using module C:\dat\PowerShell\AAA\AA.psm1;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |_|_| * AAA Code/Data Interface Template
#


<#
.SYNOPSIS
>

AAA/Advanced Artifact Template

	About .... Objective/Usage quick overview
	New ...... Creates a new object, put at use, return reference
	Object ... Returns current object reference
	Test .....	Quick test framework (assert for...)

	State .... ?
	Status ... ?

	On/Off ... Activate/Deactivate object (for event processors, ...)

#>
function AA- { AAA-Functions }

Set-StrictMode -Version 5;
# Add-Type -AssemblyName "System.Web"; # for Mime types



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
	[pscredential] $xCredential = $AAA.System.Credential;

	# for now a constructor is not need
	# _AA(){}

	}




class AA_
	{
	# holds the current object
	# for all methods
	# and interactive functionality [WS_]::$object
	static [AA_] $object = $null;
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

		$this._AA.xDate = Get-Date;
		$this._AA.xCredential = global:AAA.System.Credential;
		
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

If defined...
is called from AAA-Functions
before listing available methods...


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
Show the help page...

#>
function AA-Help( )
	{ 
	Get-Help -Category function -Name AA- -ShowWindow;
	}






<#
.SYNOPSIS
Create a new object of this kind...
and make it current

Return the newly created reference...

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
GET/SET the current object

Return the current new AA_ object 
[AA_]::$object

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
Start listening for requests...

#>
function AA-On( [AA_]$xObject = [AA_]::object )
	{
	if( $null -eq $xObject ){  }
	


	}


<#
.SYNOPSIS
Stop listening for requests...

#>
function AA-Off( [AA_]$xObject = [AA_]::object )
	{ 
	

	}



<#
.SYNOPSIS
State display...

State refers to internal data


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
Status display...

Status refers to external usage

* default is current object
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
Tests
to provide a simple test framework
and assert for incoherences

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
