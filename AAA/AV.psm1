
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |A|V| * Windows Defender
#

Set-StrictMode -Version 5;

<#
.SYNOPSIS



#>
class AV_
	{ 
	static [AV_] $object = $null;
	
	[string]		$name;
	[string]		$host;
	[pscredential]	$credential;
	[datetime]		$date
	[CIMSession]	$session

	<#
	ctor expose for clean AV object return
	in v5 PS has no constructor chainning
	so no overloads here has not much advantage
	let's opt-in for basic constructor
	#>
	AV_() 
		{ 	
		
		# is there already a default-valid-object??
		# or should we put there this one
		if ($null -eq [AV_]::Object) { [AV_]::Object = $this };

		$this.date = Get-Date;
		}

	

	<#
	getter/setter for static AV_.Object
	#>
	Active( [AV_]$xObject )
		{
		if ( $null -eq $xObject) { Throw 'AV_/Active... $null object...' };

		[AV_]::Object = $xObject;

		}
	



	<#
	.SYNOPSIS
	Catalog of known threaths...

	Get-MpThreatCatalog		Gets known threats from the definitions catalog.

	#>
	Catalog( $xObject = [AV_]::object )
		{
		if ( $null -eq $xObject) { Throw 'AV_/Catalog... $null object...' };

		Get-MpThreatCatalog;

		} 




	<#
	.SYNOPSIS

	* Get-MpThreatDetection
		Gets active and past malware threats that Windows Defender detected.

	#>	
	Detections( [AV_]$xObject = [AV_]::object )
		{
		if ( $null -eq $xObject) { Throw 'AV_/Detections... $null object...' };

		# ?asJob
		# ?use CIM-Session if $this has one (remoting)
		Get-MpThreatDetection;

		} 
	

	
	# turn AV on
	On()
		{ "Turning on AV for {0}..." -f $this.Host  }


	# turn AV off
	Off() 
		{ "Turning off AV for {0}..." -f $this.Host  }


	# Start a scan
	# 
	Scan( $xDrives )
		{
		
		}

	
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

	
	
	<#
	.SYNOPSIS
	Threats detected on this computer...

	* Get-MpThreat
		Gets the history of threats detected on the computer.

	#>	
	Threaths( [AV_]$xObject = [AV_]::object )
		{
		if ( $null -eq $xObject) { Throw 'AV_/Detections... $null object...' };

		# ?asJob
		# ?use CIM-Session if $this has one (remoting)
		Get-MpThreat;

		} 
	
	
	

	<#
	.SYNOPSIS
	checking if object is not NULL
	
	can also implements checks if current object is not valid anymore
	#>
	[bool]
	Valid( $xObject = [AV_]::object )
		{
		if ( $null -eq $xObject) { return $false }
		return $true;
		}
		

	}



<#
.SYNOPSIS
AV (Anti-Virus) Object controller
Controls the Active AV Object (AV-Active to get/set)

AV-Host to set a host (default id local)
AV-Path to set path (default is OS boot drive)
AV-scan to start scan
AV-Status to query corrent state


// Windows Defender
Add-MpPreference		Modifies settings for Windows Defender.
Get-MpComputerStatus	Gets the status of antimalware software on the computer.
Get-MpPreference		Gets preferences for the Windows Defender scans and updates.
Get-MpThreat			Gets the history of threats detected on the computer.
Get-MpThreatCatalog		Gets known threats from the definitions catalog.
Get-MpThreatDetection	Gets active and past malware threats that Windows Defender detected.
Remove-MpPreference		Removes exclusions or default actions.
Remove-MpThreat			Removes active threats from a computer.
Set-MpPreference		Configures preferences for Windows Defender scans and updates.
Start-MpScan			Starts a scan on a computer.
Start-MpWDOScan			Starts a Windows Defender offline scan.
Update-MpSignature		Updates the antimalware definitions on a computer.
#>
function AV- { AAA-Functions }



<#
.SYNOPSiS

#>
function AV-About
	{
	"
	AV function
	Control Anti-Virus engine in local/remote machine
	Receive remote data

	* AV.psm1
	* is loaded by .profile
	* proposed future remoting host features
	* has a DOS/batch counterpart for out-Powershell funcionality

	...
	"
	}



<#
.SYNOPSiS
Getter/Setter default object
???CREATE IF INEXISTENT???

#>
function AV-Active( [AV_]$xObject )
	{

	# ?is Getting
	if ( $null -eq $xObject )
		{ 
		if ( $null -eq [AV_]::object ){ Throw "AV_/Active default object is null" } 

		return [AV_]::object;
		}

	# ?or Setting...
	[AV_]::object = $xObject; 

	return [AV_]::object
	}




<#
.SYNOPSIS
Return a new AV object 
to control Windows Defender in a Local or Network PC
Set this as the AV-Active object ~> [AV_]::$object 

Use the [VM]::*/VM.* methods and properties...
-OR- 
use VM-* functions and provide a object...

#>
function AV-New `
	( 
	$xHost=".", 
	[pscredential]$xCredential = $AAA.System.Credential 
	)

	{ 
	
	$Object = [AV_]::new(); 

	$Object.Host = $xHost;
	$Object.Credential = $xCredential;

	return $Object;
	}





<#
.SYNOPSIS
Catalog of known threaths...

Get-MpThreatCatalog		Gets known threats from the definitions catalog.

#>
function AV-Catalog( $xObject = [AV_]::object )
	{ 
	$xObject.Catalog();
	}





<#
.SYNOPSIS
Detections

* Get-MpThreatDetection
	Gets active and past malware threats that Windows Defender detected.

#>
function AV-Detections( $xObject = [AV_]::object )
	{ 
	$xObject.Detections();
	}





<#
.SYNOPSIS
GET/SET the current object

Return the current new AV object 
[VM_]::$object

#>
function AV-Object( $xObject = $null )
	{ 
	
	# ?get the current object
	if ( $null -eq $xObject  ) 
		{ 
		# no argument...
		# so... return the Current object
		if ( $null -eq [AV_]::object ){ Throw "AV-/AV_ No current AV object" }; 
		return [AV_]::object;
		}
	else
		{
		# ?set the current object
		[AV_]::object = $xObject;
		return [AV_]::object;
		}
	
	throw "AV-/AV_ -/::Object fault..."

	}




<#
.SYNOPSIS
Turn AV engine on

#>
function AV-On( [AV_]$xObject )
	{
	# recursive syntax solver
	# ?no paramenter -then- get default/AV-Active
	if( $null -eq $xObject ){  }
	


	}


<#
.SYNOPSIS
Turn AV engine off

#>
function AV-Off( [AV_]$xObject )
	{ 
	

	}


<#
.SYNOPSIS
get/set scanning path
2/Overloads
#>
function AV-Path( [AV_]$xObject)
	{ 
	AAA-Alert 'AV-Path( [AV_]$xObject)'

	# AAA-Alert 'AV-Path( [AV_]$xObject, [string]$xPath )'
	}



<#
.SYNOPSIS
Remote login
using default creadentials


#>	
function AV-Remote( $xPC )
	{
	"""
	***2IMPLEMENT
	instance a remote connection / CIM-Session
	to control a remote AV
	"""

	}




<#
.SYNOPSIS
Scan,,,

#>	
function AV-Scan( [AV_]$xObject, [string] $xPath )
	{ 
	"""
	***2IMPLEMENT
	"""


	}


<#
.SYNOPSIS
State,,,

#>	
function AV-Status()
	{
	# ?is current object valid?? of type [AV_]???
	if ( [AV_]::Object -is [AV_] ) { return $true; }

	# or not???
	$x = "";
	$x += ( String-Replicate "/*\" );
	$x += "`n`n";
	$x += String-Center ( "AV-Object not initialized..." ); 
	$x += "`n`n";
	$x += String-Center ( "use AV-New to initialize a new object!" ); 
	$x += String-Center ( "then check the object with AV-State..." );
	$x += String-Center ( "use AV-Path, AV-Host, AV-Credentials to configure..." ); 
	$x += "`n`n";
	$x += ( String-Replicate "\*/" );

	Write-Host ( $x );

	Sound-Beep;
	return $false;

	}




<#
.SYNOPSIS
Threads identified

Get-MpThreat			Gets the history of threats detected on the computer.
Get-MpThreatCatalog		Gets known threats from the definitions catalog.

* Get-MpThreatDetection
	Gets active and past malware threats that Windows Defender detected.

#>
function AV-Threaths( $xObject = [AV_]::object )
	{ 
	$xObject.Threaths();
	}




<#
.SYNOPSIS
Check if a object is valid (.T.)

#>	
function AV-Valid( [AV_]$xObject = [AV_]::object )
	{ 
	if ( $null -eq $xObject ){ return $false }

	# ?check other object validity aspects
	# ...

	return $true
	}
