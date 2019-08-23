<#

#>


Set-StrictMode -Version 5;


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |A|V| * Windows Defender
#

function AV- { AAA-List }

<#
Will return a AV object to hold state (currying)
and still use the VM-* functions
to control Windows Defender in a Local or Network PC
#>
function AV-New( $xHost=".", $xUser="", $xPass="" )
	{ 
	return [AV]::new( $xHost, $xUser, $xPass );  
	}

class AV 
	{ 
	[string]$xHost     = ".";
	[string]$xUser     = "";
	[string]$xPassword = "";

	# +ctor
	AV( [string]$xHost, [string]$xUser, [string]$xPass )
		{
		$this.xHost = $xHost;
		$this.xUser = $xUser;
		$this.xPassword = $xPass;

		"Created for {0} {1} {2}" -f  $this.xHost, $this.xUser, $this.xPassword;

		}


	# turn AV on
	On() 
		{ Write-Host "Turning on AV for {0}..." -f $this.xHost  }

	# turn AV off
	Off() 
		{ Write-Host "Turning off AV for {0}..." -f $this.xHost  }

	# Start a scan
	# 
	Scan( $xDrives )
		{
		
		}


	}




# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |M|Y|S|Q|L| * MySQL
#


function MySQL- { AAA-List }

function MySQL-On {}

function MySQL-Off {}


function MySQL-Open { "xxx" }



function AAA-Reload
	{
	Sound-Plim;

	Write-Host "Import-Module -Force " + $AAAX.Modules.Base;
	Write-Host "Import-Module -Force " + $AAAX.Modules.System;
	Write-Host "Import-Module -Force " + $AAAX.Modules.Extensions;
	Write-Host "Import-Module -Force " + $AAAX.Modules.Other;

	Sound-Plum;
	}



<#
-xString/auto="_" as the pattern to replicate
-xSize/auto=<console-width> ???implement
String-Replicate is invoked...
[string][char]196 ?ASCII ?UNICODE
#>
function String-Line( $xString = "_" ) 
	{ 
	[int]$xTimes = $Host.UI.RawUI.WindowSize.Width / $xString.Length
	return String-Replicate $xString $xTimes;
	}



function String-Pattern-Artifact( [int] $xSize ) 
	{

	$xData = "";
	for( $x = 0; $x -lt $xSize; $x++ )
		{  
		$a = Get-Random -Minimum 32 -Maximum 254;
		$xFinal += [char] $a;
		} 

	return $xFinal;
	}


function String-Pattern- { AAA-List }


function String-Pattern-Floor( [int] $xLines = 1 ) 
	{ return "__/" * ( $Host.UI.RawUI.WindowSize.Width / 3 * $xLines ) }



<#

#>
function String-Pattern-Hexer( $xLines = 1 )
	{ 
	[int]$x = $Host.UI.RawUI.WindowSize.Width / 4;
	$xLine = "";
	$xLine += "/  \" * $x; 	
	$xLine += "\__/" * $x;
	
	return $xLine * $xLines;
	}




<#
String-Pattern-Stair + String-Center
#>
function String-Pattern-Piramid( $xString = "*", $xLines = 3, $xWidth )
	{
	$xData = 0


	}


function String-Replicate( [string] $xString, [int] $xTimes )
	{ return ( $xString * $xTimes )	}



<#
String[] stair of pattern
-xLines
-xwidth
#>
function String-Pattern-Stair( $xString = "*", $xLines = 3, $xWidth )
	{
	
	# AUTO-WIDTH
	if ( $xWidth -eq $null){ $xWidth = $Host.UI.RawUI.WindowSize.Width }

	--$xLines;
	$xGrowth  = [Math]::Floor( $xWidth / $xLines );
	$xGrowing = [Math]::Floor( $xGrowth / $xString.Length );

	# 1ST LINE IS ALWAYS 1-PATTERN-UNIT
	$xData = @();
	$xData += $xString;

	for( $x = 1; $x -lt $xLines; $x++ )
		{ $xData += ( $xString * $xGrowing ) * $x;	}

	# 1ST LINE IS ALWAYS FULL-LINE-LENGHT
	# EXCEED THEN TRUNCATE TO FIX DIVISION ROUND FAULTS
	$xData += ( $xString * $xGrowing * ++$xLines ).Substring( 0, $xWidth );
	return $xData;
	}



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |V|M| * Hyper-V
#

function VM- { AAA-List }
	
<#
Will return a VM object to hold state (currying)
and still use the VM-* functions
#>
function VM-New { return [VM]::new();  }

class VM 
	{ 
	[string]$xHost     = ".";
	[string]$xUser     = "";
	[string]$xPassword = "";

	# Startup the VM
	On() {}

	# Shutdown the VM
	Off() {}

	# Connect the console
	Show(){}

	# Disconnect the console
	Hide(){}


	}

