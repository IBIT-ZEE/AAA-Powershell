<#
.SYNOPSIS

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

#>

Param(
	$xFilter = 'http://localhost:88/',
	$xRouter = @{},
	$xStyles = "", 
	$xHome = $HOME
	)

# Mime types
Add-Type -AssemblyName "System.Web";

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


