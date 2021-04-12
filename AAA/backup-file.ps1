<#
.SYNOPSIS
Backup files to backup-folder 
Destination folder is argumented or got from AAA.Folders.Backup
Conserve tree structure in destination folder, recursivity is implicit
+
adds newly created files
updates existing files that are newer
alert of obsolete files (do not delete them)
SMB paths are allowed "\\*"
+
Reports new files, updated files, removed files
+
ATT***
Only for PowerShell version greater than 7
because of previois version Symlink bad handling...


_Syntax_________________________________________________________

backup-file <file/*?> [<destination-folder>] [-stamp]

	- file to backup accepting widcards
	- <destination-folder> or automatic from AAA
	- -stamp to add a *_<aaa16date> to files (new repository)


_Process________________________________________________________

1. Check argument is a valid path (file/folder/wildcards)
2. Get operable file list using arguments
3. 

backup-file
	-xFile *mandatory
	-xOrigin or "."
	-xDestimation or "<!!!!BAKS>"
	-xStamp for a *_<aaa16date+time>

_Examples_______________________________________________________

backup-file 'c:\DAT\AAA\_notes.$kb'
backup-file 'c:\DAT\AAA\_notes.$kb' -stamp

backup-file '\\server1\docs'
backup-file '\\server1\docs' -stamp	
backup-file '\\server1\docs' 'D:\!!!!BAKS\Server1'

#>


Param( [string]$xFile, [string]$xDestination, [switch]$xDated )


AAA-Log


# 1st argument is mandatory
if ( -not $xFile )
	{
# or help text to DOS/Powershell console

	AAA-Script-Help;
	Exit;

	}


# backup to <destination-folder-as-root>\? build tree from here

switch ( File-Path-Type $xFile ) 
	{
	0 	# bad path
		{  
		AAA-Alert "Bad path...", "$xFile";
		Exit;
		}
	
	1	# file or wilcards-hits-here
		{
		$xRoot = Split-Path -Path $xFile -Parent; 
		$xLeaf = Split-Path -Path $xFile -Leaf; 
		break;
		}
	
	2	# folder
		{
		$xRoot = $xFile; 
		$xLeaf=""
		break;
		}

	3	# folder+wilcards-no-hits-here (possible hits in subfolders)
		{
		$xRoot = Split-Path -Path $xFile -Parent; 
		$xLeaf = Split-Path -Path $xFile -Leaf; 
		break;
		}


	Default 
		{
		AAA-Alert "???What happend???"
		Exit;
		}
	}

	# QUIRKS***
	# to detect solve problem of Bad-Folder-as-leaf
	# and also detect bad-folder even with file-wild-cards
	# not even serve to detect the number of files for processing
	# because has no -recurse
	#
	# Split-path gaves you a folder and a leaf
	# even from a bad/invalid path

# get files
# ErrorAction here is here for ACL access deny
$xError = "";


# use FOLDER-LIST -xPath [-xRestart]

$xFiles = `
	Get-ChildItem `
		-Path $xRoot `
		-Filter $xLeaf `
		-ErrorAction SilentlyContinue `
		-ErrorVariable xError `
		-Recurse
		# -Attributes !reparse
		;


$xNew = 0
$xUpdated = 0
$xObsolete = 0
foreach( $e in $xFiles )
	{
	$e.FullName

	

	# ?date compare $xNew++
	# ?updated destination file was older
	# ?deleted ( not present in destination )

	}

""
""
$xError


#############################
Get-Variable x*; #Read-Host;
#############################


