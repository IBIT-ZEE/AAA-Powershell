
"ATT***"
"(model) is only for reference..."
"`n`n"
"Not to be executed..."

Start-Sleep -seconds 10
return;
exit;



<#

AAA
TYPES TEXT 
ARRAYS
BLOCKS
COLLECTIONS
COMMENTS
FLOW

#>


<# AAA ########################################################################>



# ?load default command/functions

Set-Alias Alias		"Get-Alias"			# Alias command
Set-Alias Delete	"Remove-Item"
Set-Alias Print		"Write-Host"
Set-Alias Pause		"Start-Sleep"		# seconds/-milliseconds


# PROFILES * can use a symbolic link for PS!! (mklink.exe)
# %windir%\system32\WindowsPowerShell\v1.0\profile.ps1  ~  applies to all users and all shells.
# %windir%\system32\WindowsPowerShell\v1.0\ Microsoft.PowerShell_profile.ps1  ~  all users, but only to the Microsoft.PowerShell shell.
# %UserProfile%\My Documents\WindowsPowerShell\profile.ps1  ~  only to the current user, but affects all shells.
# %UserProfile%\My Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1  ~  current user and the Microsoft.PowerShell shell.

import-module <file> -???
read-host "?..." -assecurestring		# System.Security.SecureString



<# TYPES ######################################################################>

[int] $x = 1

[int[]] $a = (11, 22, 33)

[char]0

[string]"`n"									# new linw
"-"*80
"-="*40





<# COLLECTIONS ##############################################################>

?arrays
?dictionaries/hashtables
?...


$a = @()								# empty array, .lenght=0
$a = 11, 22, 33
$a = ( ( 11, 22 ), ( 33, 44, 55) )		# multimensional
[int] $a = 11, 22, 33					# typed

$a = (11..22)							# generate sequence into array
$x, $y = $a								# distribute to vars, last get restant array

# Operations
$a + 44									# append element
$a += 55								# append element 
$a[1..3]								# get a slice

# compare
-eq -gt -lt ...


$a.lenght
$a[1].lenght

.add
.address
.clear
.clone
.index
.remove






<# BLOCKS #####################################################################>

function x(){ }

function xxx( )
	{
	Print "ZEE/2018"
	Print "`n`n"
	# Print @"`n`n"
	}

$c = { "111"; "222"; "333"; Sound-Plim }
Invoke-Command $c
& c






<# COMMENTS ###################################################################>

# this is a single line commente

<#
this is a multiline comment
#>




<# FLOW #######################################################################>

if $x { }  else { }

switch ( $x ) { $x=1 {  }; $x=2 { }; Default { } }

for ( $i = 0; $i -lt $array.Count; $i++) {	}
foreach ( $e in $c ) { }




<# EXCEPTIONS #################################################################>

try     { Alias xxx -ErrorAction Stop }
catch   { Print "No ALIAS for xxx"  }
Finally { }




<# GUI ########################################################################>

# FORMS ~ add a flowLayout and input/output gadjets
$x = New-Object System.Windows.Forms.Forms
$x.ShowDialog()


# MESSAGEBOX
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show( "1. Go...`n2. Don't Go...`n", "Title", "YesNoCancel"  )

# INPUTBOX ~ use VB.net Library
# [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$x = $(
	Add-Type -AssemblyName Microsoft.VisualBasic
	[Microsoft.VisualBasic.Interaction]::InputBox(
		"1. Go...`n"+
		"2. Dont go...`n"+
		"3. Who cares...`n", 
		"Title", 
		"1"
		)
     )


	 $x = $ ( Add-Type -AssemblyName Microsoft.VisualBasic [Microsoft.VisualBasic.Interaction]::InputBox(		 "1. Go`n`n" + "2. Dont go`n`n",  "Titlebar Text",  "Default new york" ))
 

# FILE-OPEN DIALOG
[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") 
$x = New-Object System.Windows.Forms.OpenFileDialog
$x.initialDirectory = $home				# %userprofile%
$x.filter = "All files (*.*)| *.*"
$x.ShowDialog() | Out-Null
? $x.filename

# FILE-SAVE DIALOG
$x = New-Object System.Windows.Forms.OpenSaveDialog








<###############################################################################
VARIABLES
###############################################################################>




<###############################################################################
XXX
###############################################################################>

# -Verbose -Debug
# -ErrorAction -ErrorVariable -WarningAction -WarningVariable
# -OutBuffer -OutVariable


