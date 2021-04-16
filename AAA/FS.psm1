# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |F|I|L|E|
#


<#
.SYNOPSIS
File operations

#>
function File- { AAA-Functions }




<#
.SYNOPSIS
*Moniker ~> File-ACL-Get

#>
function File-ACL( $xFile )	{ File-ACL-Get $xFile }


<#
.SYNOPSIS
ACL

#>
function File-ACL-Get( $xFile )
	{
	$xEntity = [System.Security.Principal.NTAccount];
	# $xEntity = [System.Security.Principal.SecurityIdentifier]; 

	$x = Get-Acl $xPath;
	$x.GetAccessRules( $true, $true, $xEntity ) 

	# $x.SetAccessRulesProtection( $true, $false ) 

	#	$xSID = $xACL.Access.identityreference 
	#		.translate -> 'S-1-.*' 
	#		.isinherited

	}



	<#
.SYNOPSIS
ACL

#>
function File-ACL-Set( $xFile )
{
# $xEntity = [System.Security.Principal.SecurityIdentifier]; 

$x = Get-Acl $xPath;
# $x.SetAccessRulesProtection( $true, $false ) 
$xAdmin = [System.Security.Principal.NTAccount]::new( "Administrators" );
#	$xSID = $xACL.Access.identityreference 
#		.translate -> 'S-1-.*' 
#		.isinherited

}




<#
.SYNOPSIS

$xFile should be an absolute path 
otherwise will default to the home directory 

#>
function File-Blocked( [string]$xFile )
	{
	$xFile = Resolve-Path $xFile
	try { [IO.File]::OpenWrite( $xFile ).Close(); $False }	catch { $True }
	}


<#
.SYNOPSIS


#>
function File-Copy
	{
	Get-Command *file* -CommandType function
	Get-Command *file* -CommandType cmdlet
	Get-Command *file* -CommandType alias
	}


<#
.SYNOPSIS
Check if file exits
SMB paths allowed

.NOTES
see also Folder-*

#>
function File-Exist( [string]$xFile )
	{
	return ( Test-Path -Path $xFile -PathType Leaf );
	}



<#
.SYNOPSIS

	???File-Path ???File-Info 
	.Name
	.Extension
	.Parents
	.Drive
	.Full
	?Rights
	?Owner
	?Owner
	?Size
#>





<#
.SYNOPSIS
Get file/object from folder
Optional recurse subfolders (-xRecurse)
Filter controled by regex/match
Folders excluded (use Folder-Get)
Return array/$null of found files

File-Get
File-Get -xFolder .
File-Get -xFolder . -xMatch *.txt

#>
function File-Get ( $xFolder = ".", $xFilter = "*.*", [switch]$xRecurse )
	{

	# splat simplifies [switch] processing
	$xSplat = @{ 
		Path    = $xFolder; 
		Filter  = $xFilter; 
		File    = $true;     # [switch] for get-files-only
		Recurse =  $xRecurse # [switch] default is no-recurse
		}

	# Catch errors to fill $AAA.Error ?and throw??
	# Clean AAA.Errors from previous operations
	$xErrors = $null;

	$xItems = `
		Get-ChildItem `
			@xSplat `
			-ErrorAction SilentlyContinue `
			-ErrorVariable xErrors

	# to avoid THROW annoyance
	# verify ( return -is $null ) -AND- ( $AAA.Error -isnot $null )
	$AAA.Error = $xErrors;

	return $xItems;

	}





function File-Info( $xFile = "." )
	{
	if ( -not ( Test-Path $xFile ) ){ return $null }
	if ( Test-Path $xFile -PathType Container ){ return $null }

	$xData = @{ Full=""; Name=""; Extension="";  Path=""; Drive="" }

	# ATT*** Resolve-Path 
	# can returns collections for wildcards
	# not a single file

	$x = Split-Path $xFile -Leaf
	$xData.Name      = $x.Substring( 0, $x.LastIndexOf( "." ) );
	$xData.Extension = $x.Substring( $x.LastIndexOf( "." ) + 1 );

	$x = Split-Path $xFile -Resolve -Parent
	$xData.Path  = $x.Substring(2) ;
	$xData.Drive = $x.Substring(0,2);
	$xData.Full  = $xData.Drive + "\" + $xData.Path + "\" + $xData.Name + "." + $xData.Extension;

	return $xData;
	}




<#
.SYNOPSIS
List files from folder
Controled by regex/match
Display Title and #Count/#All

return number of found files (0 if none)

#>
function File-List ( $xFolder = ".", $xMatch = ".*", [switch]$xRecurse )
	{

	# get all files to a List<FileInfo>
	$xAll = Get-ChildItem -Path $xFolder
	$xFiles = @();
	$xFiles += $xAll | Where-Object { $_.Name -match $xMatch }

	# ATT*** @() is not $null
	# exit if no matches 
	if ( $xFiles.Length -eq 0 ) { return 0; }

	# ATT*** REFACTOR FOR 
	# . File-Infoline( xFileInfo ) Name/Size/Age/Updated/Attrs ?owner
	# . String-Bisection( s1, s2 ) /Trisection( s1, s2, s3 )

	# QUIRK*** 
	# WRITE-HOST FIX FUNCIONAL-LANGUAGE OUTPUT SIDE EFFECTS
	# OF 'GRABBING' SPUREOUS OUTPUT ALONG FUNCTION
	ForEach( $x in $xFiles) 
		{ 
		Write-Host ( String-Edge $x.BaseName (File-Propertyline $x.FullName ) ) 
		};
	#$xFiles | ForEach-Object { String-Edge $_.BaseName  };
	

	return $xFiles.Length;
	}





<#
.SYNOPSIS

#>
function File-Path- { AAA-Functions }



<#
.SYNOPSIS

Determine if path represents:
	1 : File
	2 : Folder
	0 : Error/Invalid or wildcards in path


ATT*** WORKS WITH SMB


.NOTES
File-Path-Type 'c:\xxx\chrome'  ~>  2
File-Path-Type 'c:\xxx\chrome\(all)\LocalState'  ~>  1

#>
function File-Path-Type ( [string]$xPath )
	{

	# ? is valid path
	
	try 
		{
		# get info -OR- error...
		# -Force accounts for hidden folders
		$x = Get-Item -Force -Path $xPath;

		# ? File:1 
		# path was able to grab only-and-only 1 file in this folder
		# ATT*** could have more hits in sub-folders
		if ( $x -is [System.IO.FileInfo] ) { return 1 }

		# ? Folder:2
		# path was able to grab only-and-only 1 folder in this folder
		# ATT*** could have more hits in sub-folders
		if ( $x -is [System.IO.DirectoryInfo] ) { return 2 }

		# path is not bad but has Wilcards
		# that not grab files in this folder
		# but can eventually grab files in subfolders
		return 3
		}
		
	catch 
		{
		# Powershell 5.x $ErrorActionPresference must be Stop
		# to catch Commandlets exception
		# (define in AAA/profile.ps1)

		# bad path
		return 0;
		}

	}

function File-Path-Type-old ( $xElement )
	{
	# ? is valid path
	if ( -not ( Test-Path -Path $xElement ) ) { return 0 };

	# ? File/1 or Folder/2
	if ( Test-Path -Path $xElement -PathType Leaf ) { return 1 }

	# if it is not white... ;-)
	return 2

	}




<#
.SYNOPSIS

PSPath/Microsoft.PowerShell.Core\FileSystem::<file>
PSParentPath/Microsoft.PowerShell.Core\FileSystem::<parent>
PSChildName/<file>
PSDrive/<drive>
PSProvider/Microsoft.PowerShell.Core\FileSystem
Mode/<???> -a----
Attributes
VersionInfo/File + InternalName + OriginalFilename + FileVersion + ...
BaseName
Target
LinkType
Name
Length
DirectoryName
Directory
IsReadOnl
Exists
FullName
Extension
CreationTime + CreationTimeUtc
LastAccessTime + LastAccessTimeUtc + LastWriteTime + LastWriteTimeUtc

#>
function File-Properties ( $xFile )
	{
	if ( -not ( File-Exist $xFile ) ){ return $null }
	$x = Get-ItemProperty -Path $xFile
	return $x;
	}


<#
String of Size + Created + Updated-Span + Attrs
#>
function File-Propertyline( [string]$xFile ) 
	{
	# Read File-Properties struncture
	$xProps = Get-ItemProperty $xFile;

	# Size/Created/Updated-Span/attrs
	$xLine = `
		"{0} {1} {2}" -f `
			( Math-Bytes $xProps.Length ), `
			( Date-Agely $xProps.LastWriteTime ), `
			( Get-Date -Date $xProps.CreationTime -Format "yyyy.MM.dd" );

	return $xLine;
	}


function File-Read( [string]$xFile )
	{
	# collection of string
	[System.IO.File]::ReadAllBytes( (Resolve-Path $xFile) )
	}

function File-ReadAsText( [string]$xFile )
	{
	# collection of strings
	# full-path or tries to get file in System32
	[System.IO.File]::ReadAllText( (Resolve-Path $xFile) )
	}

function File-ReadAsLines( [string]$xFile )
	{
	# collection of strings
	# same as -> Get-Content -path $xFile
	# full-path or tries to get file in System32
	[System.IO.File]::ReadAllLines( (Resolve-Path $xFile) )
	}



# Reset file rights and change owner to ?Everyone
function File-Reset( [string] $x )
	{
	
	}


<#
$x = [system.diagnostics.fileversioninfo]::getversioninfo( <fullpath> )

#>
function File-Version( $xFile )
	{
	

	}


function File-Write( [string]$xFile )
	{
	# same as ~> Set-Content
	# full-path or tries to get file in System32
	try
		{
		$stream = [System.IO.StreamWriter]::new( $Path )
		$data | ForEach-Object{ $stream.WriteLine( $_ ) }
		}
	finally
		{ $stream.close() }
	}





	

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |F|O|L|D|E|R|
#
#
<#
.SYNOPSIS
Folder utilities...

#>
function Folder- { AAA-Functions }


<#
.SYNOPSIS
Folder ACL...

#>
function Folder-ACL-Get( $xFolder )
	{
	$xEntity = [System.Security.Principal.NTAccount];
	# $xEntity = [System.Security.Principal.SecurityIdentifier]; 
	
	$xACL = Get-Acl $xFolder;
	$x.GetAccessRules( $true, $true, $xEntity );

	}




<#
.SYNOPSIS
~

Get file/object from folder
Optional recurse subfolders (-xRecurse)
Filter controled by regex/match
Folders excluded (use Folder-Get)
Return array/$null of found files
Errors drop in $AAA.Error

Folder-Get
Folder-Get -xFolder .
Folder-Get -xFolder . -xFilter *.txt

ATT***
?limit files by ?AAA.fs.max
?throw if errors

~
#>
function Folder-Get ( 
			$xFolder = ".", 
			$xFilter = "*.*", 
			[switch]$xRecurse,
			[switch]$xSymlinks
			)
	{

	# splat simplifies [switch] processing
	$xSplat = @{ 
		Path          = $xFolder; 
		Filter        = $xFilter; 
		Directory     = $true;     # [switch] for get-folders-only
		Recurse       = $xRecurse
		FollowSymlink = $xSymlinks  # [switch] for follow-symlinks
		}
	
	# Catch errors to fill $AAA.Error ?and throw??
	# Clean AAA.Errors from previous operations
	$xErrors = $null;

	$xItems = `
		Get-ChildItem `
			@xSplat `
			-ErrorAction SilentlyContinue `
			-ErrorVariable xErrors

	# to avoid THROW annoyance
	# verify ( return -is $null ) -AND- ( $AAA.Error -isnot $null )
	$AAA.Error = $xErrors;

	return $xItems

	}






function Folder-Go( [string] $x )  
	{

	}


function Folder-Reset( [string] $x )  
	{
	
	}


<#
.SYNOPSIS
Folder traverse

ATT***
PS REPARSE POINT ERROR FIX
if no "-Reparse" switch...
this has to be a #3 phase process to drop reparse points
(reparse point drop-out is solved in PS7)
because of Powershell 5.1 error 
1. get all reparse points
2. get all folders
3. drop all paths matching reparse points

return
	$null for INVALID-PATH
	{} for ZERO-ELEMENTS filtered

#>
function Folder-List( [string]$xPath, [switch]$xRecurse, [switch]$xReparse )
	{
	
	# null means path was not valid
	if ( ( File-Path-Type $xPath ) -ne 2 ) { return $null }	

	Write-Progress `
		-Activity "Scanning..." `
		-Status "Initializing" `
		-PercentComplete 0

	$xFolders  = @{};
	$xReparses = $null
	$xErrors   = $null;

	# GET ALL FOLDERS UNDER PATH 
	# FORCE INCLUDE ALL HIDDEN FILE/FOLDERS
	# (including reparse points EVEN to be removed)
	# 
	Write-Progress `
		-Activity "Scanning..." `
		-Status "Getting all folders (including reparse-points)..." `
		-PercentComplete 25

	$xFolders = `
		Get-ChildItem -Force -Recurse `
			-Path $xPath `
			-Attributes Directory `
			-ErrorAction SilentlyContinue `
			-ErrorVariable xErrors

	# GET ALL SYMLINKS UNDER PATH
	# PREPARE TO FILTER PREVIOUS PATH-LIST
	# TRAVERSAL ERRORS REPORTED WILL BE THE SAME AS PREVIOUS TRAVERSE
	Write-Progress `
		-Activity "Scanning..." `
		-Status "Getting all reparse-points..." `
		-PercentComplete 50

	$xReparses = `
		Get-ChildItem -Force -Recurse `
			-Path $xPath `
			-Attributes Reparse `
			-ErrorAction SilentlyContinue `

	
	# IF NO REPARSES RETURN
	if (  $null -eq $xReparses ){ return $xFolders; }


	# REMOVE REPARSE-POINTS FROM LIST
	Write-Progress `
		-Activity "Cleanning..." `
		-Status "Removing all reparse-points from result..." `
		-PercentComplete 75

	# $xReparses
	$xCF = $xFolders.Count;
	$xCR = $xReparses.Count;

	$xMap = ,$true * $xCF;

	# MAP REPARSES -vs- FOLDERS
	for( $x = 0; $x -lt $xCR; $x++ )
		{ 
		$xTest = $xReparses[ $x ].FullName;

		for( $xx = 0; $xx -lt $xCF; $xx++ )
			{
			if ( $xFolders[ $xx ].FullName.StartsWith( $xTest ) )
				{  
				$xMap[ $xx ] = $false;

				Write-Progress `
					-Activity $xTest `
					-Status $xFolders[ $xx ].FullName `
					-PercentComplete ( ( $x * $xx ) % 100 );
				}
			
			}

		}


	# COLLECT VALID FOLDERS FROM MAP
	return $xFoldersX
	
	for( $x = 0; $x -lt $xCF; $x++ )
		{
		if( $xMap[ $x ] ) { $xFoldersX += $xFolders[ $x ] }
		}


	# , $xReparses, $xErrors, $xMap
	return $xFoldersX
	
	}





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  F I L E - S Y S T E M
#


<# 
-processor ?executor-path on selection
?recurse
?hidden files
?system files

#>


Function FS-XXX ( [string]$xFilter='*.exe', [string]$xPath='.' )
	{

	# CHECK*** if path is valid
	if ( -not ( Test-Path -Path $xPath -PathType Container ) )
		{
		"Path is not valid..."
		return -1
		}


	# Get files with filter
	# CHECK*** if any files to process
	$xFiles = Get-ChildItem -Path $xPath -Filter $xFilter -Recurse

	if ( -not $xFiles.Length -gt 0 )
		{  
		"no files to process..."
		return -2
		}


	$xFilter
	$xPath
	$xFiles


	}




