# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |T|S| * Text To Speech
#
#
#		System.Speech.Synthesis
#		System.Speech.Recognition
#		System.Speech.AudioFormat
#


Set-StrictMode -Version 5;
function TTS- { "Use: TS-*..." }
# Add-Type -AssemblyName "System.Web"; # for Mime types


<#
.SYNOPSIS
~

initialize AAA.TS

has a Classs,,,
TS-Object will build and return an object...
a AAA.TTS socket can hold a System-Wide object for resource economy...


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
function TS- { AAA-Functions }



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  _TS
#
#

class _TS
	{

	# Name will be set by DB-New if necessaire
	# or passed to the "_TS-Owner-Object" constructor and set there
	[string] $xName;
	[datetime] $xDate = (Get-Date)
	[pscredential] $xCredential = $AAA.System.Credential;

	# for now a constructor is not need
	# _TS(){}

	$engine = $null;
	$text = "";


	}




class TS_
	{
	# holds the current object
	# for all methods
	# and interactive functionality [WS_]::$object
	static [TS_] $object = $null;
	[_TS]$_TS = [_TS]::new();


	# SPECIFIC CLASS/TYPE PROPERTIES


	# ctor expose for clean AV object return
	# in v5 PS has no constructor chainning
	# so no overloads here has not much advantage
	# let's opt-in for basic constructor
	TS_() 
		{ 
		# SHARED/STATIC holds the last/current object	
		[TS_]::Object = $this;

		$this._TS.xDate = Get-Date;
		$this._TS.xCredential = global:AAA.System.Credential;
		
		# constructor "default return" is the "instantiated object"
		}


	<#
	.SYNOPSIS
	~

	...

	~
	#>
	Clipboard(){ }	


	<#
	.SYNOPSIS
	~

	Select a TTS profile
	{ voice,  language, culture, rate, pauses, ... }
	
	~
	#>
	Profile( $x ){  }
	

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
function TS-About()
	{
	"
	.SYNOPSIS
	Class for Text-To-Speech works

	"
	}



<#
.SYNOPSIS
Show the help page...

#>
function TS-Help( )
	{ 
	Get-Help -Category function -Name TS- -ShowWindow;
	}






<#
.SYNOPSIS
Create a new object of this kind...
and make it current

Return the newly created reference...

#>
function TS-New()
	{
	# object inception/instantiation
	# SHARED $this::object and other METADATA/_TS (time, credential, ...)
	# is assigned in the contructor
	$x = [TS_]::new()

	# ...+OBJECT INITIATION

	return $x; 
	}




<#
.SYNOPSIS
GET/SET the current object

Return the current new TS_ object 
[TS_]::$object

#>
function TS-Object( $xObject = $null )
	{ 
	
	if ( $null -eq $xObject  ) 
		{ 
		# no argument...
		# so... get the Current object
		if ( $null -eq [TS_]::object ){ "No current TS- object" }; 
		return [TS_]::object;
	
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
function TS-On( [TS_]$xObject = [TS_]::object )
	{
	if( $null -eq $xObject ){  }
	


	}


<#
.SYNOPSIS
Stop listening for requests...

#>
function TS-Off( [TS_]$xObject = [TS_]::object )
	{ 
	

	}



<#
.SYNOPSIS
State display...

State refers to internal data


#>
function TS-State( [TS_]$xObject = [TS_]::object )
	{ 
	
	# 2DO***
	# Customize the STATE output for this object
	if ( $null -eq $xObject ){ throw "TS-State ~> no selected object..." }
	$xObject;

	}




<#
.SYNOPSIS
Status display...

Status refers to external usage

* default is current object
#>
function TS-Status( [TS_]$xObject = [TS_]::object )
	{ 
	
	# 2DO***
	# Customize the STATUS output for this object
	if ( $null -eq $xObject ){ throw "TS-State ~> no selected object..." }
	$xObject;

	}



<#
.SYNOPSIS
Tests
to provide a simple test framework
and assert for incoherences

#>
function TS-Test( [TS_]$xObject = [TS_]::object )
	{ 
	'''
	Simple test framework
	Asserting for incohereces

	Define your more critical 
	centralize here a global call 
	to all tests considered critical
	applied over the current object...
	'''

	}


# TS-New -xName "<aa-default>"











<#
.SYNOPSIS
builds and returns 
a AAA/Class TTS object for persistency of work

.NOTES

#>
function TS-Object() { return [TTS]::new(); }


function TS-Say( $x = "Nothing..." )
	{
	# use AAA.TTS
	# if AAA.TTS -is $NULL message/GUI
	$xTTS = [System.Speech.Synthesis.SpeechSynthesizer]::new();
	$xTTS.Rate = -2;

	[void] $xTTS.SpeakAsync( $x ) ;
	}


function TS-Clipboard()
	{
	$x = Get-Clipboard  
	TS-Speak $x;
	}



function TS-Test
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



<#

Add-Type -AssemblyName System.Speech
$x = New-Object System.Speech.Synthesis.SpeechSynthesizer
$x
$x | get-member

// test
	.voice
	.GetInstalledVoices()
	.GetInstalledVoices() | get-member
	.GetInstalledVoices().VoiceInfo
	.SelectVoice( "Microsoft Zira Desktop" )
	.Speak( "1 2 3..." )
	.SpeakAsync( "1 2 3..." )
	.Rate = -2


$t = (Get-Content "x.csv" ) | Get-Random


// Synthesis Markup Language (SSML).
$t = '
<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" 
    xml:lang="en-US">
    <voice xml:lang="en-US">
    <prosody rate="1">
        <p>Normal pitch. </p>
        <p><prosody pitch="x-high"> High Pitch. </prosody></p>
    </prosody>
    </voice>
</speak>
'
$x.SpeakSsml( $t )



#>
function zee-TS{}




