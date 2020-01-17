



Set-StrictMode -Version 5;


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |A|V| * Windows Defender
#

class AV_
	{ 
	static [AV_] $Object = $null;
	
	[string] $Name;
	[string] $Host;
	[pscredential] $Credential;
	[datetime] $Birth

	# ctor expose for clean AV object return
	# in v5 PS has no constructor chainning
	# so no overloads here has not much advantage
	# let's opt-in for basic constructor
	AV_() 
		{ 	
		[AV_]::Object = $this;
		$this.Birth = Get-Date;
		}

	

	<#
	getter/setter for static AV_.Object
	#>
	Active( [AV_]$xObject )
		{
		if ( $null -eq $xObject) { Throw '$null...' };

		[AV_]::Object = $xObject;

		} #void
	

	# turn AV on
	On()
		{ Write-Host "Turning on AV for {0}..." -f $this.Host  }


	# turn AV off
	Off() 
		{ Write-Host "Turning off AV for {0}..." -f $this.Host  }


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


	}



<#
AV-* 
AAA System show all actions of this class
#>
function AV- { AAA-Functions }



<#
Getter/Setter default object
???CREATE IF INEXISTENT???
#>
function AV-Active( [AV_]$xObject )
	{
	# pseudo overload
	if ( -not $null -eq $xObject ){ [AV_]::Active( $xObject ) }

	# get class current active object
	return [AV_]::Object;
	}



function AV-Check()
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
AV (Anti-Virus) Object controller
Controls the Active AV Object (AV-Active to get/set)

AV-Host to set a host (default id local)
AV-Path to set path (default is OS boot drive)
AV-scan to start scan
AV-Status to query corrent state
#>
function AV-Help
	{
	
	}



<#
Will return a AV object to hold state (currying)
and still use the VM-* functions
to control Windows Defender in a Local or Network PC
#>
function AV-New( $xHost=".", [pscredential]$xCredential = $AAA.Credential )
	{ 
	$Object = [AV_]::new(); 

	$Object.Host = $xHost;
	$Object.Credential = $xCredential;

	return $Object;
	}



<#
Turn AV engine on
#>
function AV-On( [AV_]$xObject )
	{
	# recursive syntax solver
	# ?no paramenter -then- get default/AV-Active
	if( $null -eq $xObject ){  }
	


	}


<#
Turn AV engine off
#>
function AV-Off( [AV_]$xObject )
	{ 
	

	}


<#
get/set scanning path
2/Overloads
#>
function AV-Path( [AV_]$xObject)
	{ 
	AAA-Alert 'AV-Path( [AV_]$xObject)'

	# AAA-Alert 'AV-Path( [AV_]$xObject, [string]$xPath )'
	}



<#
Scan
#>	
function AV-Scan( [AV_]$xObject, [string] $xPath )
	{ 
	

	}


<#
Scan
#>	
function AV-State
	{
	# if ( $null -eq $xObject ) { $xObject = [AV_]::Active() } ;
	if ( -not (AV-Check) ){ return }

	[AV_]::Object.State();
	# (AV-Active).State();

	}


