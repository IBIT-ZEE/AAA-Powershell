# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |W|S| * Web Server / HTTP-Server
#

Set-StrictMode -Version 5;
Add-Type -AssemblyName "System.Web"; # for Mime types


<#
.SYNOPSIS

Simple HTTP Server
leveraging on .net [System.Net.HttpListener] Context/Request/Response 



#>
class WS_
	{
	# holds the current object
	# for all methods
	# and interactive functionality [WS_]::$object
	static [WS_] $object = $null;
	
	[string] $name;
	[string] $host;
	[pscredential] $credential;
	[datetime] $birth

	$xFilter = 'http://localhost:88/'
	$xRouter = @{}
	$xStyles = "" 
	$xHome = $HOME

	# ctor expose for clean AV object return
	# in v5 PS has no constructor chainning
	# so no overloads here has not much advantage
	# let's opt-in for basic constructor
	WS_() 
		{ 	
		[WS_]::Object = $this;
		$this.birth = Get-Date;


		}

	

	# turn listening On...
	On()
		{   }


	# turn listening Off...
	Off() 
		{   }



	# Attend a DYNAMIC request
	ServeDynamic()
		{

		}

	# Attend a STATIC request
	ServeStatic()
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
.SYNOPSIS
Return a new AV object 
to control Windows Defender in a Local or Network PC
Set this as the AV-Active object ~> [AV_]::$object 

HTTP-Server $xPath="." $xRouter=@{} $xStyles=""

Objective is a fast/small webserver
to resolve routes as dynamic content
and serve static content if present at fs

1. Start [System.Net.HttpListener] with URL filter
2. Loop/while .IsListening
3. ----Get the Context/.Request/.Response
4. ----Get the .request URI 
5. ----Check if is a known route || Check if a static resource exist
6. ----Echo to CONSOLE URI/Result
7. ----Serve dynamic path -OR- static resource

.NOTES

$xFilter = <url-filter-prefix-for-security>
$xRouter = @{ '<ACTION> <path>' = { <codeblock> }, ... }

???
Use the [VM]::*/VM.* methods and properties...
-OR- 
use VM-* functions and provide a object...

#>
function WS- { AAA-Functions }



<#
.SYNOPSIS


#>
function WS-About
	{
	"
	WS -> Web Server
	for in-process simple HTTP request/response

	* WS.psm1
	* is loaded by .profile
	* proposed future remoting host features
	* has a DOS/batch counterpart for out-Powershell funcionality

	...
	"
	}




<#
.SYNOPSIS


#>
function WS-New( 
	$xFilter = 'http://localhost:88/',
	$xRouter = @{},
	$xStyles = "", 
	$xHome = $HOME
	)
	 
	{ 
	$Object = [WS_]::new(); 

	#$Object.Host = $xHost;
	#$Object.Credential = $xCredential;


# ATT*** 
# QUIRK***
# this affects all environment
# so it must be REPLACED by a better solution...
# File system limmit for security
New-PSDrive -Name xSite -PSProvider FileSystem -Root $home | Out-Null

$xListen = [System.Net.HttpListener]::new()
# "http://localhost:88/"  ???"http://0.0.0.0:88/" 
$xListen.Prefixes.Add( $xFilter )
$xListen.Start()

"AAA HTTP-Web server..."
"- to end service..."
""
""

while ( $xListen.IsListening ) 
	{
	# process received request
	$xContext  = $xListen.GetContext()
	$xRequest  = $xContext.Request
	$xResponse = $xContext.Response

	# ?get URL path
	$xPath = $xRequest.Url.LocalPath;

	# ?Termination required
	if ( $xPath -eq "/-" ) 
		{
		# $xResponse.StatusCode = 404
		# $xData = 'page not available...'
		"Service terminated!"
		$xListen.Stop();
		Remove-PSDrive -Name xSite;
		Return;
		}

	# ?Route exists !get route data
	$xData = $xRouter[ "{0} {1}" -f $xRequest.HttpMethod, $xPath ];

	if ( $xData ) 
		{
		# Compose request URI
		# return the HTML to the caller
		$xBuffer = [Text.Encoding]::UTF8.GetBytes( $xData );
		$xResponse.ContentLength64 = $xBuffer.length;
		$xResponse.OutputStream.Write( $xBuffer, 0, $xBuffer.length );

		$xLog = "Route/Dynamic"
		}
	else
		{  
		# ?no successful Route 
		# ?? static resource present
		# read data from FS
		# set the correct mime type (usually test/html)
		# and write to the Response stream

		try 
			{
			# resolve a path limmited at the site filesystem
			$xPath = Join-Path -path xSite: -ChildPath $xPath -Resolve;

			$xData = Get-Content -Encoding Byte -Path $xPath;
			$xResponse.ContentType = [System.Web.MimeMapping]::GetMimeMapping( $xPath );
			$xResponse.OutputStream.Write( $xData, 0, $xData.Length );
			$xLog = "Static/Ok"
			}
		catch 
			{
			$xLog = "Static/Error"
			}

		}

	String-Edge (Date-Filename), $xLog $xRequest.RawUrl;

	$xResponse.Close()
	}


	return $Object;
	}





<#
.SYNOPSIS
GET/SET the current object

Return the current new AV object 
[VM_]::$object

#>
function WS-Object( $xObject = $null )
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
function WS-On( [AV_]$xObject )
	{
	# recursive syntax solver
	# ?no paramenter -then- get default/AV-Active
	if( $null -eq $xObject ){  }
	


	}


<#
.SYNOPSIS
Stop listening for requests...

#>
function WS-Off( [AV_]$xObject )
	{ 
	

	}




<#
.SYNOPSIS
Tests

#>
function WS-Test(  )
	{ 

	# Routes
	$xRouter = `
		@{
		'GET /'  =  `
			'<html><body>Powershell HTTP-Webserver</body></html>'
		
		'GET /processes' = 	`
			Get-Process | `
			Select-Object -Property Id, SessionId, StartTime, @{ Label="Name";  Expression={ if($_.path){$_.path}else{"( " + $_.name + " )"} }  } | `
			Sort-Object -Property SessionId, @{ Expression = "StartTime"; Descending=$true } | `
			ConvertTo-Html -precontent "<pre>" -postcontent "</pre>"
		
		'GET /services'  =  `
			Get-Service  | `
			Select-Object Name, Status, DisplayName, ServiceType | `
			Sort-Object -Property status -Descending | `
			ConvertTo-Html -precontent "<pre>" -postcontent "</pre>"
		}



	}






