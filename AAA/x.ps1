Sound-Plim;


$a = 1, 22, 333, 4444, 55555, 666666, 7777777;
$b = 1, 1, 1, 2, 2, 3, 4;

AAA-Menu $a $b;

# Wait-Debugger;

Sound-Plum;
break x12345678980;




################################################################################

# KWIKS
$a = 1, 22, 333, 4444, 55555, 666666, 7777777;
$a -is [array]
AAA-Alert $a;


# OOP class STATIC
class c1 
	{ 
	static [int] f1( [string]$x ) { return 111 }
	static [int] f1( [string[]]$x ) { return 222 }
	static [int] f1( [int]$x ) { return 333 }
	}

class c2 { 
	$p1=1; 
	static $p2=2; 
	m1(){ $this.p1++ } 
	static m2(){ [c2]::p2++ } 
	}


# AD-HOC FUNCTION OVERLOADING USING $PSCMDLET.PARAMETERSET
function f1_20190731() 
	{ 
	param( 
		[ Parameter( Position=0, ParameterSetName="set1" )] [int]$x,
		[ Parameter( Position=0, ParameterSetName="set2" )] [string]$xx
		) 

	return $PSCmdlet.ParameterSetName  
	}  


#String-Center <string> [size=<width>] [fill=" "]
String-Center "ABCDEF" '.qed5';

# AAA.Modules
$xBase   = (File-Path $AAAX.Modules.Base).Name;
$xSystem = (File-Path $AAAX.Modules.System).Name;


# Modules Import/Force
Remove-Module -Force -Name $xBase;
Import-Module -Force -Name $AAAX.Modules.Base;
Start-Sleep 1;

Remove-Module -Force -Name $xSystem;
Import-Module -Force -Name $AAAX.Modules.System;
Start-Sleep 1;





