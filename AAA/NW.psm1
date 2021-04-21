# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |N|E|T|W|O|R|K|
#
#
#



<#
.SYNOPSIS
TCP operations
#>




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |D|N|S| * Domain Name System
#
# 

<#
.SYNOPSIS
DNS protocol routines
#>
function DNS- { AAA-Functions }




<#
.SYNOPSIS
Get Address from host name (standard DNS lookup)
#>
function DNS-Address( $xName ) 
	{
	# if FAIL... return $null
	try { $x = [System.Net.DNS]::GetHostByName( $xName )  } catch { return $null }
	# [System.Net.DNS]::GetHostEntry() 
	
	# SUCCESS... we got a name
	# return the object with name and other information
	return $x
	}


<#
.SYNOPSIS
DNS reverse query

#>
function DNS-AddressX( $xName )
	{ 
	return [System.Net.Dns]::GetHostAddresses( $xName )
	}



<#
.SYNOPSIS
Get Host name from Address 
(Reverse lookup)

.NOTES
[System.Net.DNS]::GetHostByAddress()
[System.Net.DNS]::GetHostEntry() do not rely on DNS

#>
function DNS-Host( $xIP ) 
	{
	# if FAIL... return $null
	try { $x = [System.Net.DNS]::GetHostByAddress( $xIP )  } catch { return $null }
	# [System.Net.DNS]::GetHostEntry() 
	
	# SUCCESS... we got a name
	# return the object with name and other information
	return $x
	}



<#
.SYNOPSIS
DNS Server set

#>
function DNS-Server( $xName )
	{ 
	Get-DnsClientServerAddress | Out-GridView -title "DNS Serveres" -PassThru
	}








# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |F|I|R|E|W|A|L|L|
#
#

<#
.SYNOPSIS

Firewall...

#>
function Firewall- { AAA-Functions }


<#
.SYNOPSIS

Firewall rules...

#>
function Firewall-Rule- { AAA-Functions }


<#
.SYNOPSIS

Firewall find rules by name...

#>
function Firewall-Rule-Find( $xName )
	{ 
		if ( $null -eq $xName )
		{
		"Indique um filtro", "Wildcards admited...";
		return
		} 
	
	Get-NetFirewallRule -DisplayName $xName `
		| Format-Table -Property DisplayName, Direction, Action, PrimaryStatus, Profile, Owner -AutoSize 
	
		
	}

<#
.SYNOPSIS

Firewall rules in GridView...

#>
function Firewall-Rule-GUI( $xName="*" )
	{ 

	# AAA-Progress -xPercent 50

	Write-Progress `
		-Activity "Grabbing data..." `
		-Status "Inspecting rules..." `
		-CurrentOperation "running..." `
		-SecondsRemaining -1 `
		-PercentComplete 50

	$x = Get-NetFirewallRule -DisplayName $xName 
	
	Write-Progress -Completed

	#Format-Table -Property DisplayName, Direction, Action, PrimaryStatus, Profile, Owner -AutoSize 
	$x | Out-GridView -Title "Firewall rules" -PassThru

	}






# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |H|T|T|P! * Hyper Text Transfer Protocol
#
# 
<#
.SYNOPSIS
http protocol routines

.NOTES

#>
function HTTP- { AAA-Functions }



<#
.SYNOPSIS
return the IP of URL if live...
argument any URL


.NOTES
2do... handle when domain is a IP

uses HTTP-Head to verify the site is live
(shared IP sites turn-around, ...)

#>
function HTTP-Ping( $xURL ) 
	{
	
	# get the domain
	$xURI = URI-Break $xURL

	# if we get a header the site is active	
	# HTTP-Head catches errors
	$x = HTTP-Head -xURL ( $xURI.Domain )
	if ( !$x ) { return $null };


	$x = DNS-Address -xName $xURI.Domain;
	if ( !$x ) { return $null };
	
	# then get the IP Adress of the domain
	return $x.AddressList[0].IPAddressToString
	}




<#
.SYNOPSIS
Get Head data of the URL

.NOTES

#>
function HTTP-Head( $xURL ) 
	{
	try 
		{
		$x = `
			Invoke-WebRequest `
				-Uri $xURL `
				-UseBasicParsing `
				-DisableKeepAlive `
				-Method Head
			
		}
	catch 
		{ return $null }

	return $x
	
	}

<#
.SYNOPSIS
Demo .net use...

.NOTES

#>
function HTTP-Demo( $xURL ) 
	{
	$x = `
		[System.Net.WebRequest]::Create( $xURL);
		$x = $request.GetResponse()
		$x.StatusCode
		$x.Close()
	
	return $x;
	}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |I|P| * Network
#
<#
.SYNOPSIS
IP Routines
domain is net-*

#>
function IP- { AAA-Functions }


<#
.SYNOPSiS
System existent IP adresses

#>
function IP-Addresses
	{
	Get-NetIPAddress | Out-GridView -Title "System IP Addresses" -PassThru
	}



<# 
.SYNOPSiS
Get IP DEFAULT GATEWAY

#>
function IP-Gateway
	{
	$x = Get-NetRoute -DestinationPrefix "0.0.0.0/0";
	return $x[0].NextHop;
	}


<# 
.SYNOPSiS
ICMP Ping 
using internal Test-Connection

return
	<ip> if succeeded
	$null if unreachable

.NOTES


#>
function IP-Ping( $xDomain )
	{

	try
		{
		$x = Test-Connection -ComputerName $xDomain -Count 1 # -ErrorAction Ignore;
		}
	catch 
		{
		return $null;
		}
	
	return $x.ProtocolAddress;
	}




function IP-Scan( [string] $xIP )
    {
	# get ip network from Gateway 
	if ( $xIP -eq "" ) { $xIP = IP-Gateway }

	# get the first 3 octets + "."
	# is valid IP or break with error
	$xMatch = $xIP -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\."
	if ( ! $xMatch ){ return "$xIP is an invalid IPv4 format..." }
	$xNet = $Matches[0]
	
	"Testing $($xNet)<?> for 255 addresses..."

	$xTest = $null
	$xValids = @()

    for( [int] $x = 1; $x -lt 255; $x += 1 )
        {
		$xIP = $xNet + $x;

        $xTest = `
            Test-Connection  `
            	-ErrorAction SilentlyContinue `
            	-ComputerName $xIP `
            	-Count 1 `
				-TimeToLive 1
				# -Delay 1 

		if ( !$? ) 
			{ 
			Write-Host -NoNewline "."; 
			Continue;
			}
		
		""
		# $xTest.ProtocolAddress
		# $xTest.Address
		$xIP

		$xValids += $xIP
		# Write-Host "$xTest.Address"     
		}
	return $xValids
    }


function IP-ScanX
	{ "~ nmap -sn- 10.0.0.0" }


# WOL
# The magic packet is a broadcast frame 
# containing anywhere within its payload 
# 6 bytes of all 255 ( FF FF FF FF FF FF )
# followed by 16 repetitions 
# of the target computer MAC address ( 48-bit)
# in a total of 102 bytes.
function IP-WOL( $xMAC ) 
	{

	$xMAC = $xMAC.ToUpper();
	$xMAC = $xMAC.Replace( ":", "-" );
	$xMAC = [ Net.NetworkInformation.PhysicalAddress ]::Parse( $xMAC ) 

	$xBroadcast = ( [System.Net.IPAddress]::Broadcast )
	$xPacket =  [ Byte[] ] ( ,0xFF*6 ) + ( $xMAC.GetAddressBytes() * 16 )

	# sender IP:port
	$xIP = New-Object Net.IPEndPoint $xBroadcast, 9		


	$xUDP = New-Object Net.Sockets.UdpClient
	$xReturn = $xUDP.Send( $xPacket, $xPacket.Length, $xIP )

	$xUDP.Close()
	$xUDP.Dispose()

	# $x = @($mac.split(":""-") | foreach {$_.insert(0,"0x")})
	# $target = [byte[]] ( $x[0], $x[1], $x[2], $x[3], $x[4], $x[5] )
	# $xPacket = [byte[]] (,0xFF * 102)
	# 6..101 |% { $packet[$_] = $target[($_%6)]}
	#
	# .NET framework lib para sockets
	# $UDPclient.Connect( ( [System.Net.IPAddress]::Broadcast), 4000 )
# $UDPclient.Send( $packet, $packet.Length )
	}




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |I|C|M|P| * ICMP
#

<#
.SYNOPSIS

#>
function ICMP-Test( $xHost = "127.0.0.1" )
	{ 
	Test-NetConnection -ComputerName $xHost
	}




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |I|S|C|S|I| * Network
#


function iSCSI- { AAA-List }

function iSCSI-On {  }

function iSCSI-Off {  }









# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |T|C|P|
#
#
#

<#
.SYNOPSIS
TCP operations
#>
function TCP- { AAA-Functions }



<#
.SYNOPSIS
TCP testing...
#>
function TCP-Port- { AAA-Functions }



<#
.SYNOPSIS
Test a remote Endpoint (IP+Port)

Notable usual ports
20/21 53 68/69 
139=SMB, 445=MS/Multiplexed, 3389=MSTS/RDP, ...
80=HTTP, 1433=MSSQL-Server, 3306/8=MySQL/MariaDB, ...


ATT***
	Test-NetConnection (PS#6x) 	replaces
	Get-NetTCPConnection (PS5x)) deprecated test

#>
function TCP-Connection( $xHost = "127.0.0.1",  $xPort = 80 )
	{
	# deprecated PS6
	# Get-NetTCPConnection -RemoteAddress $xHost -RemotePort $xPort
	Test-NetConnection -ComputerName $xHost -Port $xPort -loc
	}




<#
.SYNOPSIS
Traceroute
AAA.Net.Hops for default hop count???
#>
function TCP-Traceroute( $xHost = "127.0.0.1" )
	{ 
	Test-NetConnection -ComputerName $xHost -TraceRoute -Hops 16
	}





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |U|R|I| * Universal Resource Indicator
#
<#
.SYNOPSIS
|U|R|I| * Universal Resource Indicator routines


.NOTES

#>
function URI- { AAA-Functions }


<#
.SYNOPSIS
Break a URI in Protocol/Domain/Resources
return object or null


.NOTES
2DO
expand to recognize local names (no protocol and no TLD)
expand to get variables ( *?a=1&b=22&... )

#>
function URI-Break( [string]$xURI )
	{ 
	
	$xResult = @{ Protocol=""; Domain=""; Resource="" }

	# Protocol
	if ( $xURI -match "^\w+://" ) { $xResult.Protocol = $Matches[0] }


	#Domain 
	$xResult.Domain = `
		$xURI `
		-replace ( "^" + $xResult.Protocol ) `
		-replace "(?<=\.\w*)/.*"

	$xResult.Resource = $xURI -replace ( "^" + $xResult.Protocol + $xResult.Domain  )


	return $xResult
	# if ( $xURI -replace "^http.?://" -replace "(?<=\.\w*)/.*"

	}





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |W|O|L| * Wake-On-LAN
#
<#
.SYNOPSIS
|W|O|L| * Wake-On-LAN routines


.NOTES

#>
function WOL- { AAA-Functions }

'''
38-60-77-2A-4F-9D	Demo1
'''

<#
.SYNOPSIS
WOL go---

.NOTES

#>
function WOL-Go (){}


<#
.SYNOPSIS
WOL packet send to an IP address
usually the broadcast address in a subnet. 
To use this script, you need to specify the MAC address of the device that you need to wake 
using -mac parameter.  The
default UDP port is 9 but using other port number as 7 is not uncommon. 
Specify a different port using the -port parameter.
The script takes a mac address either separated with -nothing- ":", "-" or "." 

Send a WOL packet to a broadcast address
	$xMAC is the address of the device that need to wake up
	$xIP  is the address where the WOL packet will be sent to

.NOTES
Send-WOL -mac 00:11:32:21:2D:11 -ip 192.168.8.255 -port 7 
Send-WOL -mac 00-11-32-21-2D-11 -ip 192.168.8.255 -port 7 
Send-WOL -mac 0011.3221.2D11 -ip 192.168.8.255 -port 7 
Send-WOL -mac 001132212D11 -ip 192.168.8.255 -port 7 
Send-WOL -mac 001132212D11 

#>
function WOL-Send
	{

	[CmdletBinding()]
	param(
	[Parameter(Mandatory=$True,Position=1)]
	[string]$mac,
	[string]$ip="255.255.255.255", 
	[int]$port=9
	)
	$broadcast = [Net.IPAddress]::Parse($ip)
	
	$mac=(($mac.replace(":","")).replace("-","")).replace(".","")
	$target=0,2,4,6,8,10 | % {[convert]::ToByte($mac.substring($_,2),16)}
	$packet = (,[byte]255 * 6) + ($target * 16)
	
	$UDPclient = new-Object System.Net.Sockets.UdpClient
	$UDPclient.Connect($broadcast,$port)
	[void]$UDPclient.Send($packet, 102) 

	}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |W|S|
#
#
#

<#
.SYNOPSIS
WSMan/WinRM test

-Credential
-

#>
function WSMan-Test( $xHost = "127.0.0.1" )
	{ 
	Test-WSMan -ComputerName $xHost 
	}



