<#

#>


Set-StrictMode -Version 5;






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
#  |T|T|S| * Text To Speech
#
#
#		System.Speech.Synthesis
#		System.Speech.Recognition
#		System.Speech.AudioFormat
#

<#
.SYNOPSIS
initialize AAA.TTS

has a Classs,,,
TTS-Object will build and return an object...
a AAA.TTS socket can hold a System-Wide object for resource economy...

#>
function TTS- { AAA-Functions }

<#
.SYNOPSIS
Class for Text-To-Speech works

#>
class TTS 
	{
	$engine = $null;
	$text = "";

	Say( $x ){ }
	Clipboard(){ }
	Test(){ }
	
	<#
	.SYNOPSIS
	Select a TTS profile
	{ voice,  language, culture, rate, pauses, ... }
	#>
	Profile( $x ){  }
	}




<#
.SYNOPSIS
builds and returns 
a AAA/Class TTS object for persistency of work

.NOTES

#>
function TTS-Object() { return [TTS]::new(); }


function TTS-Say( $x = "Nothing..." )
	{
	# use AAA.TTS
	# if AAA.TTS -is $NULL message/GUI
	$xTTS = [System.Speech.Synthesis.SpeechSynthesizer]::new();
	$xTTS.Rate = -2;

	[void] $xTTS.SpeakAsync( $x ) ;
	}


function TTS-Clipboard()
	{
	$x = Get-Clipboard  
	TTS-Speak $x;
	}


function TTS-Test
	{
	
	# use AAA.TTS
	# if AAA.TTS -is $NULL message/GUI
	$xTTS = [System.Speech.Synthesis.SpeechSynthesizer]::new();
	$xTTS.Rate = -2;

	$xTTS.Speak( 
		"
		Hello...
		This routine will state all installed Voices in this device...
		" 
		) 

	$x = 0;
	Foreach ( $xVox in $xTTS.GetInstalledVoices() )
		{
		""
		$xTTS.Speak( ( "{0}{1}" -f ( $x += 1), ( Math-Ordinalex $x ) ) );
		$xVox.VoiceInfo;
		$xTTS.Speak( $xVox.VoiceInfo.Name );
		$xTTS.Speak( $xVox.Voiceinfo.Description );
		""
		}
	
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
