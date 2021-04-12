

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



