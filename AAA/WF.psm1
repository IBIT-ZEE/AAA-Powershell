# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |W|F| * Windows Forms
#

# QUIRK*** so we can use the [_AA]/METADATA type
using module C:\dat\PowerShell\AAA\AA.psm1;

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
function WF- { AAA-Functions }

Set-StrictMode -Version 5;
# Add-Type -AssemblyName "System.Web"; # for Mime types

# FLAGS/ENUMS
enum WF_Type { Free; Flow; Table; }


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  _WF
#	Metaclass for AA/Type object 
#	so some general function/state can be hold in a AA/Object ( $x._WF )
#	providing some separation from the specific implementation (AV/DB/FS/VM/...)
#	like name, credential, date-of-creation, etc. 
#
#	Holds metadata for current object,,,  at least:
#	xData is the object date of inception
#	xName is the object name
#	xCredential is obtained from the AAA/System default credential (if defined)
#
class WF_
	{
	# holds the current object
	# for all methods
	# and interactive functionality [WS_]::$object
	static [WF_] $object = $null;
	[_AA]$_AA = [_AA]::new();

	# SPECIFIC CLASS/TYPE PROPERTIES
	[System.Windows.Forms.Form]            $xWindow;
	[System.Windows.Forms.MenuStrip]       $xMenu;
	[System.Windows.Forms.StatusStrip]     $xStatus
	# [System.Windows.Forms.Panel]           $xBody
	$xBody

	[int32]$xBackground	= 0xFF000000;
	[int32]$xForeground	= 0xFFFFFFFF;


	# ctor expose for clean AV object return
	# in v5 PS has no constructor chainning
	# so no overloads here has not much advantage
	# let's opt-in for basic constructor
	WF_() 
		{ 
		# SHARED/STATIC holds the last/current object	
		[WF_]::Object = $this;
		$this._AA.xDate = Get-Date;
		$this._AA.xCredential = $global:AAA.System.Credential;

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
is called from AAA-Functions
before listing available methods...


#>
function WF-About
	{
	"
	WF -> Windows Forms (GDI+)


	* Also 'previsto' the WPF Version...
	* be bold!!! ?What about a GTK and a QT version???
	* what the heck... wxWidgets or similar...
	...
	"
	}




<#
.SYNOPSIS
Show the help page...

#>
function WF-Help( )
	{ 
	Get-Help -Category function -Name WF- -ShowWindow;
	}




<#
.SYNOPSIS
Controls

#>
function WF-Controls( [WF_]$xObject = [WF_]::object )
	{ 
	$xObject.$xWindow.Controls;	
	}




<#
.SYNOPSIS
Add/Return a Top-Menu

#>
function WF-Controls-Button( [WF_]$xObject = [WF_]::object, $xText = "Button" )
	{
	if ( $null -eq $xObject.xBody ){ throw "WF-Controls-Button ~> no available body..."  }

	$x = [System.Windows.Forms.Button]::new() 
	$x.Text = $xText;
	$x.AutoSize = $true;
	$x.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink;
	$x.BackColor = $xObject.xBackground;
	$x.ForeColor = $xObject.xForeground;

	$xObject.xBody.Controls.Add( $x );
	return $x;
	}



<#
.SYNOPSIS
Add/Return a Top-Menu

#>
function WF-Controls-Menu( [WF_]$xObject = [WF_]::object )
	{
	$xObject.xMenu = [System.Windows.Forms.MenuStrip]::new() 
	$xObject.xWindow.Controls.Add( $xObject.xMenu );
	return $xObject.xMenu;
	}


<#
.SYNOPSIS
Add/Return a Status bar

#>
function WF-Controls-Status( [WF_]$xObject = [WF_]::object )
	{
	$xObject.xStatus = [System.Windows.Forms.StatusStrip]::new() 
	$xObject.xWindow.Controls.Add( $xObject.xStatus );
	return $xObject.xStatus;
	}


<#
.SYNOPSIS
?menu exists -OR- create one
?is hidding then showit
return it

#>
function WF-Menu-On( [WF_]$xObject = [WF_]::object )
	{
	# ?NULL -then- add a new---
	if ( $null -eq $xObject.xMenu ){ WF-Controls-Menu -xObject $xObject  } 

	# ?HIDDEN -then- show it...
	if ( -not $xObject.xMenu.Visible ){ $xObject.xMenu.Show() }

	return $xObject.xMenu;
	}



<#
.SYNOPSIS
?is there a existing menu then hide it
return it -OR- $null

#>
function WF-Menu-Off( [WF_]$xObject = [WF_]::object )
	{
	if ( $null -ne $xObject.xMenu ) { $xObject.xMenu.Hide() }
	return $xObject.xMenu;
	}




<#
.SYNOPSIS
Returns a window object
With the most common 'presets' configured


Create a new object of this kind...
and make it current

Return the newly created reference...

#>
function WF-New( $xName = ( Date-Filename ) )
	{ 

	$x = [WF_]::new(); 

	$x.xWindow = [System.Windows.Forms.Form]::new();
	$x.xWindow.Name = $xName;
	$x.xWindow.Text = $xName;

	# Don't... if you want to inherit default styles
	# $x.xWindow.ForeColor = [System.Drawing.Color]::FromArgb( $x.xForeground );
	# $x.xWindow.BackColor = [System.Drawing.Color]::FromArgb( $x.xBackground );

	# WF-Type-*  for xBody
	# WF-Style-* for xStyle

	# self body/form for now
	$x.xBody = $x.xWindow

	return $x;
	}




<#
.SYNOPSIS
GET/SET the current object

Return the current new WF_ object 
[WF_]::$object

#>
function WF-Object( $xObject = $null )
	{ 
	
	if ( $null -eq $xObject  ) 
		{ 
		# no argument...
		# so... get the Current object
		if ( $null -eq [WF_]::object ){ "No current WF- object" }; 
		return [WF_]::object;
	
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
function WF-On( [WF_]$xObject = [WF_]::object )
	{
	if( $null -eq $xObject ){  }
	
	}


<#
.SYNOPSIS
Stop listening for requests...

#>
function WF-Off( [WF_]$xObject = [WF_]::object )
	{ 
	

	}


<#
.SYNOPSIS
Show...

#>
function WF-Show( [WF_]$xObject = [WF_]::object )
	{ 
	# 2DO***
	# use Thread to inteact with window
	# without blocking console

	# Create a Thread
	$xThread = [RunspaceFactory]::CreateRunspace()
	$xThread.ApartmentState = [System.Threading.ApartmentState]::STA
	$xThread.Open()
	
	# Create a Runspace for the thread
	$xPS = [Powershell]::Create()
	$xPS.Runspace = $xThread
	$xPS.AddScript( { $xObject.xWindow.ShowDialog() } )
	$xPS.BeginInvoke()

	return $xPS;

	# return $xObject.xWindow.ShowDialog();
	}



<#
.SYNOPSIS
State display...

State refers to internal data

#>
function WF-State( [WF_]$xObject = [WF_]::object )
	{ 
	
	if ( $null -eq $xObject ){ throw "AA-State ~> no selected object..." }
	$xObject;

	}




<#
.SYNOPSIS
Status display...

Status refers to external usage

#>
function WF-Status( [WF_]$xObject = [WF_]::object )
	{ 
	
	if ( $null -eq $xObject ){ throw "AA-State ~> no selected object..." }
	$xObject;

	}


<#
.SYNOPSIS
?menu exists -OR- create one
?is hidding then showit
return it

#>
function WF-Status-On( [WF_]$xObject = [WF_]::object )
	{
	# ?NULL -then- add a new---
	if ( $null -eq $xObject.xStatus ){ WF-Controls-Status -xObject $xObject  } 

	# ?HIDDEN -then- show it...
	if ( -not $xObject.xStatus.Visible ){ $xObject.xStatus.Show() }

	return $xObject.xStatus;
	}



<#
.SYNOPSIS
?is there a existing menu then hide it
return it -OR- $null

#>
function WF-Status-Off( [WF_]$xObject = [WF_]::object )
	{
	if ( $null -ne $xObject.xStatus ) { $xObject.xStatus.Hide() }
	return $xObject.xStatus;
	}



<#
.SYNOPSIS
Tests
to provide a simple test framework
and assert for incoherences

#>
function WF-Test( [WF_]$xObject = [WF_]::object )
	{ 
	
	$xObject = WF-New -xName "WF-Test";
	$xMenu = WF-Menu-On -xObject $xObject;
	$xStat = WF-Status-On -xObject $xObject;

	# ?OK/Cancel/...
	$x = WF-Show $xObject;

	# Menu-top
	# Statusbar
	# FlowControl
	# $x.Controls.Add()
	
	return $xObject;
	}


function WF-Test-Reposition-Controls( [WF_]$xObject = [WF_]::object )
	{ 
	$x = 0;
	$y = 0;
	$xPad = 10;
	$yPad = 10;
	
	foreach ( $e in $xObject.xWindow.Controls ) 
		{
		$e.Left = $x; 
		$e.Top  = $y;
		$x += $e.Width  + $xPad;
		$y += $e.Height + $yPad;
		
		}
	
	return $xObject;
	}




<#
.SYNOPSIS
?is there a existing menu then hide it
return it -OR- $null

#>
function WF-Status-Off( [WF_]$xObject = [WF_]::object )
	{
	if ( $null -ne $xObject.xStatus ) { $xObject.xStatus.Hide() }
	return $xObject.xStatus;
	}



<#
.SYNOPSIS
~

Load a style
Pre-defined or argumented...

Colors Back/Front + Font + ...

~
#>
function WF-Style ( [WF_]$xObject = [WF_]::object )
	{ 
	
	$xObject.xBackground = 0xFF123456;
	$xObject.xForeground = 0xFFFEDCBA;

	WF-Style-Apply $xObject
	
	return $xObject;
	}


<# 

#>
function WF-Style-Apply ( [WF_]$xObject = [WF_]::object )
	{ 

	$xObject.xWindow.ForeColor = `
		[System.Drawing.Color]::FromArgb( $xObject.xForeground );

	$xObject.xWindow.BackColor = `
		[System.Drawing.Color]::FromArgb( $xObject.xBackground );


	return $xObject;
	}


<#
.SYNOPSIS
~

Contrast current style...

~
#>
function WF-Style-Contrast ( [WF_]$xObject = [WF_]::object )
	{ 
	
	$xObject.xForeground = ( -bnot $xObject.xBackground -band 0x00FFFFFF -bor 0xFF000000 );
	WF-Style-Apply $xObject
	
	return $xObject;
	}


<#
.SYNOPSIS
~

Invert current style...

~
#>
function WF-Style-Invert ( [WF_]$xObject = [WF_]::object )
	{ 
	
	$x = $xObject.xBackground
	$xObject.xBackground = $xObject.xForeground;
	$xObject.xForeground = $x;
	WF-Style-Apply $xObject

	return $xObject;
	}


<#
.SYNOPSIS
~

Randomize a style...

~
#>
function WF-Style-Random ( [WF_]$xObject = [WF_]::object )
	{ 

	$xObject.xBackground = `
		[System.Drawing.Color]::FromArgb(( Get-Random -Minimum 0 -Maximum 0xFFFFFF ));

	$xObject.xForeground = `
		[System.Drawing.Color]::FromArgb(( Get-Random -Minimum 0 -Maximum 0xFFFFFF ));
	
	WF-Style-Apply $xObject

	return $xObject;
	}





<#
.SYNOPSIS
Type FLOW/TABLE/FREE

#>
function WF-Type( [WF_]$xObject = [WF_]::object, [WF_Type] $xType = [WF_Type]::Flow )
	{

	if ( $null -eq $xObject ) { throw "WF-Type ~> no selected object..." }

	switch ( $xType ) 
		{
		# FREE/CANVAS
		( [WF_Type]::Free )
			{ 
			$x = [System.Windows.Forms.Panel ]::new(); 
			break; 
			}

		#FLOW
		( [WF_Type]::Flow )
			{ $x = [System.Windows.Forms.FlowLayoutPanel]::new(); break; }

		#TABLE
		( [WF_Type]::Table )
			{ $x = [System.Windows.Forms.TableLayoutPanel]::new(); break; }


		Default { throw "WF-Type/WF_Type something wrong!" }

		}

	$x.Dock = [System.Windows.Forms.DockStyle]::Fill;
	$x.BackColor = $xObject.xBackground;
	
	$xObject.xWindow.Controls.Add( $x)
	$xObject.xBody = $x;

	return $x;
	}

