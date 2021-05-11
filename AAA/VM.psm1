# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |V|M| * Virtual Machine
#
#  |V|M| * Hyper-V
#


Set-StrictMode -Version 5;
# Add-Type -AssemblyName "System.Web"; # for Mime types
# Assemblies used
# Add-Type -AssemblyName Microsoft.HyperV.PowerShell
# RequiredAssemblies = @( "Microsoft.HyperV.PowerShell.Objects" );



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
	# or passed to the "_VM-Owner-Object" constructor and set there
	[string] $xName;
	[datetime] $xDate = (Get-Date)
	[pscredential] $xCredential = $AAA.System.Credential;

	# for now a constructor is not need
	# _AA(){}

	}




<#
.SYNOPSIS
~

AAA/Advanced Artifact Template

	About .... Objective/Usage quick overview
	New ...... Creates a new object, put at use, return reference
	Object ... Returns current object reference
	Test .....	Quick test framework (assert for...)

	State .... ?
	Status ... ?

	On/Off ... Activate/Deactivate object (for event processors, ...)

~
#>
function VM- { AAA-Functions }




# to RENAME to SPECIFIC [??_]::$object
class VM_
	{
	# holds the current SPECIFIC [??_]::$object
	# and interactive functionality 
	static [VM_] $object = $null;

	# this is for AA metadata
	[_AA]$_AA = [_AA]::new();


	# SPECIFIC CLASS/TYPE PROPERTIES
	$VM = $null;


	# ctor expose for clean AV object return
	# in v5 PS has no constructor chainning
	# so no overloads here has not much advantage
	# let's opt-in for basic constructor
	VM_() 
		{ 
		# SHARED/STATIC holds the last/current object	
		[VM_]::Object = $this;

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

If defined...
is called from VM-Functions
before listing available methods...


#>
function VM-About()
	{
	"
	VM ~> Virtual Machine Control 
	(Hyper-V is the default)
	
	...
	"
	}




<#
.SYNOPSIS
~

Create a new VM
if VMName is not specified 
a automatic AAA/Date-Filename is solicited (YYYYMMDDhhmmssxx)
and is assigned to current object
*defauls are 0HD 1cpu 2GbMem noCheckpoints | Gen1/DefaultSwitch

>VM-Grab
>VM-Get/Set

~
#>
function VM-Create( [string]$xName = (Date-Filename), [VM_]$xObject = [VM_]::object )
	{
	# initialize if necessaire...
	if ( $null -eq $xObject ){ $xObject = [VM_]::new() };

	AAA-Progress -xPercent 0

	# ?Gen1/Gen2 DefaultSwitch 
	# 0HD 1cpu 2GbMem
	$x = `
		New-VM `
			-Name $xName `
			-Generation 1 `
			-Switchname (Get-VMSwitch)[0].name `
			-MemoryStartupBytes 2048MB `
			-NoVHD 

	# 2CPUs
	# noCheckpoints 
	set-vm $x -ProcessorCount 2
	set-vm $x -AutomaticCheckpointsEnabled $false

	# try   {  }  catch { throw "AAA/VM-Create ~> $xName creation failed..." }

	# VM in control
	$xObject.VM = $x;

	return $xObject;
	}



<#
.SYNOPSIS
~

Get a VM on system (one only)
from the argumented VM-Name (supports Wildcards)
return a VM- object with $this.VM as current object...

>VM-List
>VM-Get/Set

~
#>
function VM-Grab( [string]$xName, [VM_]$xObject = [VM_]::object )
	{
	# initialize if necessaire...
	if ( $null -eq $xObject ){ $xObject = [VM_]::new() };
	
	try   { $x = (Get-VM $xName)[0] } 
	catch { throw "AAA/VM-Catch ~> Get-VM ~by~ name..." }

	# VM in control
	$xObject.VM = $x;

	return $xObject;
	}



<#
.SYNOPSIS
~

Get a VM Sub-Object from a VM- controler...

~
#>
function VM-Get( [VM_]$xObject = [VM_]::object )
	{
	if ( $null -eq $xObject ) { throw "AAA/VM-Set ~> No current VM- object" };
	
	# VM in control
	return $xObject.VM;
	}


<#
.SYNOPSIS
~

Show the help page...

~
#>
function VM-Help( )
	{ 
	Get-Help -Category function -Name VM- -ShowWindow;
	}




<#
.SYNOPSIS
~

Show the help page...

~
#>
function VM-List( )
	{ 
	Get-VM
	}






<#
.SYNOPSIS
Create a new object of this kind...
and make it current

Return the newly created reference...

#>
function VM-New()
	{
	# object inception/instantiation
	# SHARED $this::object and other METADATA/_AA (time, credential, ...)
	# is assigned in the contructor
	$x = [VM_]::new()

	# ...+OBJECT INITIATION

	return $x; 
	}




<#
.SYNOPSIS
GET/SET the current object

Return the current new VM_ object 
[VM_]::$object

#>
function VM-Object( $xObject = $null )
	{ 
	
	if ( $null -eq $xObject  ) 
		{ 
		# no argument...
		# so... get the Current object
		if ( $null -eq [VM_]::object ){ throw "AAA/VM-Object ~> No current object" }; 
		return [VM_]::object;
	
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

...
Turn on the current Virtual-Machine...

>VM-List
>VM-Get/Set

~
#>
function VM-On( [VM_]$xObject = [VM_]::object )
	{
	if( $null -eq $xObject    ){ throw 'VM-On ~> no Object defined...' }
	if( $null -eq $xObject.VM ){ throw 'AAA/VM-On ~> $this.VM is not valid...' }

	Start-VM -VM $xObject.VM;

	}


<#
.SYNOPSIS
~

Turn off the current Virtual-Machine

>VM-List

~
#>
function VM-Off( [VM_]$xObject = [VM_]::object )
	{ 
	if( $null -eq $xObject    ){ throw 'VM-On ~> no Object defined...' }
	if( $null -eq $xObject.VM ){ throw 'AAA/VM-On ~> $this.VM is not valid...' }

	Stop-VM -VM $xObject.VM;
		

	}





<#
.SYNOPSIS
~

Connect via RDP/RDC protocol

~
#>
function VM-RDC( [VM_]$xObject = [VM_]::object )
	{ 
	if ( $null -eq $xObject ) { throw "AAA/VM-Set ~> No current VM- object" };

	# ??? $xObject.VM = $xVm;
	}





<#
.SYNOPSIS
~

Get a VM Sub-Object from a VM- controler...

~
#>
function VM-Set( $xVM = $null, [VM_]$xObject = [VM_]::object )
	{ 
	if ( $null -eq $xObject ) { throw "AAA/VM-Set ~> No current VM- object" };
	if ( $null -eq $xVM )     { throw "AAA/VM-Set ~> xVM is not valid to assign..." }

	$xObject.VM = $xVm;
	}



<#
.SYNOPSIS
State display...

State refers to internal data


#>
function VM-State( [VM_]$xObject = [VM_]::object )
	{ 
	
	# 2DO***
	# Customize the STATE output for this object
	if ( $null -eq $xObject    ){ throw 'VM-State ~> no selected object...' }
	if ( $null -eq $xObject.VM ){ throw 'AAA/VM-State ~> $this.VM is null...' }

	Out-Default -InputObject $xObject;
	# Out-Default -InputObject ( String-Fit "-" ) ;
	Out-Default -InputObject ( String-Pad-Center '[$this.VM]' '-' );
	Out-Default -InputObject $xObject.VM;

	return $null;
	}




<#
.SYNOPSIS
Status display...

Status refers to external usage

* default is current object
#>
function VM-Status( [VM_]$xObject = [VM_]::object )
	{ 
	
	# 2DO***
	# Customize the STATUS output for this object
	if ( $null -eq $xObject ){ throw "VM-State ~> no selected object..." }
	$xObject;

	}



<#
.SYNOPSIS
Tests
to provide a simple test framework
and assert for incoherences

#>
function VM-Test( [VM_]$xObject = [VM_]::object )
	{ 
	'
	Simple test framework

	1.	Show all VMs (this is Agnostic/no [VM_] need...)
	2.	Initalize VM-*
	3.	Set the last VM as active
	4.	VM-State

	'

	# 1
	String-Fit "-"; '1.'
	VM-List

	# 2
	String-Fit "-"; '2.'
	VM-New

	# 3
	String-Fit "-"; '3.'
	VM-Set (VM-List)[-1]

	# 4
	String-Fit "-"; '4.'
	VM-State;

	}




<#
.SYNOPSIS
~

Default OD/UI for VM Management

~
#>
function VM-UI( )
	{ 

	Start-Process `
		-FilePath "virtmgmt.msc"
		# -ArgumentList ([System.Environment]::MachineName), $xObject.VM.Name

	}



<#
.SYNOPSIS
~

Present the VM
with the default Hyper-V Console
vmconnect.exe <host-pc> <vm-name>		// *C:\Windows\System32

~
#>
function VM-View( [VM_]$xObject = [VM_]::object )
	{ 
	if ( $null -eq $xObject ) { throw "AAA/VM-Set ~> No current VM- object" };

	Start-Process `
		-FilePath "vmconnect.exe" `
		-ArgumentList ([System.Environment]::MachineName), $xObject.VM.Name

	}



# VM-New -xName "<aa-default>"



<#

#>