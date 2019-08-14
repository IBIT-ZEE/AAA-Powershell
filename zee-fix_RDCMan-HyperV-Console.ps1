<#
// FIX RDCMAN<->HYPER-V CONSOLE CONNECT FAIL
* Also add user to "Hyper-V Administrators Group"

#>

try   { aaa-check } catch { Read-Host "*****ERROR: AAA System absent!!!"; exit  }

function _get() { foreach( $e in $a ) {Get-ItemProperty -Path ( $x + $e ) } }
function _set() { foreach( $e in $a ) { New-ItemProperty -Path ( $x + $e ) -Name Hyper-V -PropertyType String -Value "Microsoft Virtual Console Service/*" -Force } }
function _del() { foreach( $e in $a ) { Remove-ItemProperty -Path ( $x + $e ) -Name Hyper-V } }


Clear-Host
Print ( "*"*80 )
Print "`n"
Print "ArteWare Software"
Print "ZEE/2018"
Print "AAA/Sys"
Print "`n"
Print ( "*"*80 )
Print "`n"

$x= "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Credssp\PolicyDefaults\"

$a=@()
$a += "AllowDefaultCredentials"
$a += "AllowDefaultCredentialsDomain"
$a += "AllowFreshCredentials"
$a += "AllowFreshCredentialsDomain"
$a += "AllowFreshCredentialsWhenNTLMOnly"
$a += "AllowFreshCredentialsWhenNTLMOnlyDomain"
$a += "AllowSavedCredentials"
$a += "AllowSavedCredentialsDomain"
$a += "AllowSavedCredentialsWhenNTLMOnly"


$xx=""

Print "Fix RDCMan permission for Hyper-V access as Console..."
Print "`n"
Print "`t1. Check current"
Print "`t2. Inject fixes"
Print "`t3. Remove fixes"
Print "`n"
Print "`n"

$xx = Input "`tOption(0/1..3)... "

switch ($xx) 
	{
	1 { Print "Getting..."  ; _get }
	2 { Print "Setting..."  ; _set }
	3 { Print "Deleting..." ; _del }
	Default { Print "Invalid option...`n`n" }
	}

Print "`n"
Print "`n"

Input "Fininshed... "

exit


