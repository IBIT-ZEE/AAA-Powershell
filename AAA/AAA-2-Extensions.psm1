<#

#>


Set-StrictMode -Version 5;


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |I|P| * Network
#


function IP- { AAA-List }


# GET TCP/IP DEFAULT GATEWAY
function IP-Gateway
	{
	$x = Get-NetRoute -DestinationPrefix "0.0.0.0/0";
	return $x[0].NextHop;
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
#  |P|O|R|T| * Network
#

function Port- { AAA-List }


function Port-Scan {  }


function Port-Read {  }


function Port-Write {  }


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |I|S|C|S|I| * Network
#


function iSCSI- { AAA-List }

function iSCSI-On {  }

function iSCSI-Off {  }



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |S|O|F|T|W|A|R|E| 
#

function Software- { AAA-List }

function Software-XXX 
	{
@'
Get-Command -Module PackageManagement
Find-Package -Provider chocolatey
Find-Package -Provider chocolatey -name notepad*
Find-Package -Provider chocolatey -name notepadplusplus | Install-Package
Install-Package -Name ".\7z920.msi" -force
Get-Package -Provider Programs -IncludeWindowsInstaller
Get-Package -Provider Programs -IncludeWindowsInstaller -Name "7-Zip*"
Get-Package -Provider Programs -IncludeWindowsInstaller -Name "7-Zip*" | Uninstall-Package
Get-Package -Provider MSU | fl -Property name, summary
'@
	}

function Software-Help
	{

	} 

function Software-Install {} 


function Software-Installed {} 

function Software-Uninstall {} 







# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |W|O|L| * Network
#

function WOL- { AAA-List }

'''
38-60-77-2A-4F-9D	Demo1
'''
function WOL-Go (){}


'''
WOL packet send to an IP address
usually the broadcast address in a subnet. 
To use this script, you need to specify the MAC address of the device that you need to wake 
using -mac parameter.  The
default UDP port is 9 but using other port number as 7 is not uncommon. 
Specify a different port using the -port parameter.
The script takes a mac address either separated with -nothing- ":", "-" or "." 

Send-WOL -mac 00:11:32:21:2D:11 -ip 192.168.8.255 -port 7 
Send-WOL -mac 00-11-32-21-2D-11 -ip 192.168.8.255 -port 7 
Send-WOL -mac 0011.3221.2D11 -ip 192.168.8.255 -port 7 
Send-WOL -mac 001132212D11 -ip 192.168.8.255 -port 7 
Send-WOL -mac 001132212D11 
'''
function WOL-Send
{
<# 
  .SYNOPSIS  
    Send a WOL packet to a broadcast address
  .PARAMETER mac
   The MAC address of the device that need to wake up
  .PARAMETER ip
   The IP address where the WOL packet will be sent to
  .EXAMPLE 
   Send-WOL -mac 00:11:32:21:2D:11 -ip 192.168.8.255 
#>

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
