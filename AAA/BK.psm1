# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
# BACKUP FILES/FOLDERS FILTER
#
# Backup files/Folders
# 
# Recurse
# up to $AAA.FilesMaxCount or -force
# Progress indicators
# ETA calc
#
#



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
function BK- { AAA-Functions }

Set-StrictMode -Version 5;
# Add-Type -AssemblyName "System.Web"; # for Mime types


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  _BK
#	Metaclass for AA/Type object 
#	so some general function/state can be hold in a AA/Object ( $x._AA )
#	providing some separation from the specific implementation (AV/DB/FS/VM/...)
#	like name, credential, date-of-creation, etc. 
#

class _BK
	{

	[string] $name;
	[pscredential] $credential;
	[datetime] $date

	[object] $xAA;

	}




class BK_
	{
	# holds the current object
	# for all methods
	# and interactive functionality [WS_]::$object
	static [ BK_ ] $object = $null;
	
	[ _BK ]$_AA = [ _BK ]::new();

	[object] $xAA;


	# ctor expose for clean AV object return
	# in v5 PS has no constructor chainning
	# so no overloads here has not much advantage
	# let's opt-in for basic constructor
	BK_() 
		{ 
		# SHARED/STATIC holds the last/current object	
		[BK_]::Object = $this;
		$this._AA.date = Get-Date;
		$this._AA.credential = global:AAA.System.Credential;

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
function BK-About
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
function BK-Help( )
	{ 
	Get-Help -Category function -Name BK- -ShowWindow;
	}






<#
.SYNOPSIS
Create a new object of this kind...
and make it current

Return the newly created reference...

#>
function BK-New( )
	{ 
	$Object = [ BK_ ]::new(); 

	#$Object.Host = $xHost;
	#$Object.Credential = $xCredential;


	}





<#
.SYNOPSIS
GET/SET the current object

Return the current new BK_ object 
[ BK_ ]::$object

#>
function BK-Object( $xObject = $null )
	{ 
	
	if ( $null -eq $xObject  ) 
		{ 
		# no argument...
		# so... get the Current object
		if ( $null -eq [AV_]::object ){ "No current AV object" }; 
		return [AV_]::object;
	
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
function BK-On( [ BK_ ]$xObject )
	{
	if( $null -eq $xObject ){  }
	


	}


<#
.SYNOPSIS
Stop listening for requests...

#>
function BK-Off( [ BK_ ]$xObject )
	{ 
	

	}



<#
.SYNOPSIS
State display...

State refers to internal data

#>
function BK-State( [ BK_ ]$xObject )
	{ 
	

	}




<#
.SYNOPSIS
Status display...

Status refers to external usage

#>
function BK-Status( [ BK_ ]$xObject )
	{ 
	

	}



<#
.SYNOPSIS
Tests
to provide a simple test framework
and assert for incoherences

#>
function BK-Test(  )
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





