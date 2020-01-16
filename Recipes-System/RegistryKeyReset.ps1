


[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$vb = [Microsoft.VisualBasic.Interaction] 
$xLib = [System.Security.Principal.SecurityIdentifier]

$xPath = $vb::InputBox( "Key to reset to Admin/S-1-5-32-544", "Name")

switch -wildcard ( $xPath )
    { 
    "HKEY_CLASSES_ROOT\*"	{ $x = $x -replace "HKEY_CLASSES_ROOT\\"  , "hkcr:\" } 
    "HKEY_CURRENT_USER\*"	{ $x = $x -replace "HKEY_CURRENT_USER\\"  , "hkcu:\" } 
    "HKEY_LOCAL_MACHINE\*"	{ $x = $x -replace "HKEY_LOCAL_MACHINE\\" , "hklm:\" } 
    "HKEY_USERS\*"			{ $x = $x -replace "HKEY_USERS\\"         , "hku:\"  } 
    "HKEY_CURRENT_CONFIG\*"	{ $x = $x -replace "HKEY_CURRENT_CONFIG\\", "hkcc:\" } 
    default { Exit }
    }

Write-Output "`n`n"
Write-Output "Will reset this key and subkeys : $xPath"
Write-Output "Press * to continue..."

$xKey = [System.Console]::ReadKey($true)
if ( $xKey -ne "*" ) { Exit }

$x = get-acl -path $xPath
$xOwner = new-object $xLib -ArgumentList "S-1-5-32-544"
$x.SetOwner( $xOwner )
set-acl -path $xPath -AclObject $x

Exit