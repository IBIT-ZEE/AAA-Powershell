# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#	|U|I|
#
#
# CONSOLE/GUI/WEB/...
#
#


Set-StrictMode -Version 5.0;






# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |G|U|I|
#
#
<#
.SYNOPSIS

GUI Interface functionality...

#>
function GUI- { AAA-Functions }


<#
State holder
#>
class GUI_Window 
	{
	$Form = $null;
	$Body = $null;

	<#
	1. add component to the Body
	2. try to style-it
	#>
	[System.Windows.Forms.Control] `
	Add( $xControl ) 
		{
		$this.Styler( $xControl );
		$this.Body.Controls.Add( $xControl );	

		# prevent Fluency...
		return $xControl;
		}

	<#
	
	#>
	Show() { $this.Form.ShowDialog(); }

	<#
	1 get component type
	2 if no styler available exit
	3 style the component
	#>
	Styler( $xControl ) 
		{
		$xControl.Backcolor = `
			[System.Drawing.Color]::FromArgb( 
				(Get-Random -Maximum 255), 
				(Get-Random -Maximum 255), 
				(Get-Random -Maximum 255) 
				)

		}

	}


<#
returns a form with hrlders & helpers:
	.Window ... the OS/Form container
	.Body ..... the container render area
	+
	.Build .... accept a control to reside in form and style-it (.Styler)
	.Styler ... accept a control and style-it if style available


$xWindow.Build $xMenu
$xWindow.Build $xStatusBar

$xWindow.Styler $xLabel1
$xWindow.Styler $xTextbox1

#>
function GUI-Window()
	{
	$xWindow = [GUI_Window]::New();

	# FORM
	$xWindow.Form = [System.Windows.Forms.Form]::New();
	$xWindow.Form.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font

	# FLOWLAYOUTPANEL
	$xWindow.Body = [System.Windows.Forms.FlowLayoutPanel]::New()
	$xWindow.Body.BackColor = "#FAFE01";
	$xWindow.Body.Dock = [System.Windows.Forms.DockStyle]::Fill;

	$xWindow.Form.Controls.Add( $xWindow.Body );

	# EVENT MouseWheel Scale
	$xWindow.Form.add_mousewheel( 
		{ 
		$e = [System.Windows.Forms.MouseEventArgs]$_;

		$this.Font = 
			[System.Drawing.Font]::new( 
				$this.Font.FontFamily, 
				$this.Font.Size + ( [System.Math]::Sign( $e.Delta ))  
				)
		})

	
	return $xWindow;
	}





<# CONTROLS #>
function GUI-Control-Form( )  { return [System.Windows.Forms.Form]::New() }
function GUI-Control-Button( $xWindow )  { $xWindow.Add( [System.Windows.Forms.Button]::New() ) }
function GUI-Control-Label( $xWindow )   { $xWindow.Add( [System.Windows.Forms.Label]::New() ) }
function GUI-Control-Textbox( $xWindow ) { $xWindow.Add( [System.Windows.Forms.Textbox]::New() ) }
function GUI-Control-Combobox( $xWindow ) { $xWindow.Add( [System.Windows.Forms.Combobox]::New() ) }
function GUI-Control-Listbox( $xWindow ) { $xWindow.Add( [System.Windows.Forms.Listbox]::New() ) }

	

function GUI-Control-List ()
	{
	
	}




<#
.SYNOPSIS
Pick a filename/path


#>
function GUI-Shell-File ( $xFile = "." )
	{
	$xDialog = [System.Windows.Forms.OpenFileDialog]::new();

	# ?arg is file or folder??
	$xType = File-Path-Type $xFile;

	if ( $xType -eq 0 ) { Throw "Invalid path..."  }

	if ( $xType -eq 1 ) 
		{ $xFolder = Split-Path $xFile -Parent  }
	else 
		{ $xFolder = $xFile; $xFile = ""; }

	$xDialog.InitialDirectory = $xFolder;
	$xDialog.ShowDialog();


	return $xDialog.FileNames;

	}


<#
.SYNOPSIS
Shell properties dialog invocation
for a file


#>
function GUI-Shell-FileInfo( [string] $xFile )
	{

	if ( -not ( File-Path-Type $xFile -eq 1 ) ) 
		{ 
		AAA-Alert "Invalid file path..."; 
		return; 
		}

	$xPath   = Resolve-Path -Path $xFile
	$xFile   = Split-Path   -Path $xPath -Leaf; 
	$xFolder = Split-Path   -Path $xPath -Parent;

	$xShell   = New-Object -ComObject Shell.Application;
	$xShellX  = $xShell.NameSpace( $xFolder );
	$xShellXX = $xShellX.ParseName( $xFile );
	$xShellXX.InvokeVerb( "Properties" );

	}


<#
.SYNOPSIS
Shell properties dialog invocation
for a folder



#>
function GUI-Shell-FolderInfo( [string] $xFolder )
	{

	if ( -not ( File-Path-Type $xFolder -eq 2 ) ) 
		{ 
		AAA-Alert "Invalid folder path..."; 
		return; 
		}

	$xPath   = Resolve-Path -Path $xFolder;
	$xShell  = New-Object   -ComObject Shell.Application;
	$xShellX = $xShell.NameSpace( $xPath.ProviderPath );
	$xShellX.Self.InvokeVerb( "Properties" );	
	
	}




<#
.SYNOPSIS
System default Message Box

#>
function GUI-Shell-Message ( $xMessage )
	{
	$xDialog = [System.Windows.Forms.MessageBox]::Show( $xMessage  )

	$xDialog = $null;
	}




<#
.SYNOPSIS
Window with List items 
to pick one/various
funcionality

.NOTES

#>
function GUI-Window-Picker ()
	{
	
	}




<#
.SYNOPSIS
???
!!!

#>
function GUI-Window-Grid ()
	{
	
	}







<#
.SYNOPSIS

UI-
#>
function UI-( $xPath ){ AAA-Functions }





<#
.SYNOPSIS
File related menu

UI-

#>
function UI-File( $xPath ){ AAA-Functions }



<#
.SYNOPSIS
Show a menu of 
	files in argumented PATH (default is .)
	filtered by argumented filter (defaults to *.exe)

	UI-File-Alphabetic
	UI-File-Alphabetic . *.*					(defaut)
	UI-File-Alphabetic -xPath . -xFilter *.*	(defaut)


show Alphabetically from A..Z

?File-Picker-Alpha
returns the filename choosen or NULL
#>
function UI-File-Alphabetic( 
	[string]$xPath   = ".",  
	[string[]]$xFilter =  @("*.*")
	)
	{

	# EXIT IF INVALID PATH
	if( -not ( Test-Path -Path $xPath -PathType Container ) )
		{ Throw "AAA <> Path is not a container..." }

	# ATT*** WE ARE ASSUMING FILES COME SORTED BY NAME ELSE WE NEED TO SORT
	# to use multiple filters must use -INCLUDE 
	# -INCLUDE only works with -RECURSE
	# use -DEPTH 0 to process only current folder
	# ~old~$xFiles = Get-ChildItem -Path $xPath -Filter $xFilter;
	$xFiles = Get-ChildItem -Path $xPath -Include $xFilter -Recurse -Depth 0;

	# EXIT IF NO ELEMENTS 
	if ( -not $xFiles){ return $null }

	$xNames    = $xFiles.Name;
	$xAlphabet = Array-Alphadigit $xNames; 

	# ADD RETURN-EXCEPTION OPTION
	$xNames    += "<none>"
	$xAlphabet += "..."

	$x = AAA-Menu $xNames $xAlphabet

	# ?EXCEPTION SELECTED??
	if ( $x -eq $xNames.Length - 1 ){ return $null }

	# return the filename
	return $xNames[ $x ]

	}





<#
.SYNOPSIS
Show a menu of:
	files in argumented PATH (defaults to  .)
	filtered by argumented filter (defaults to *.exe)

Returns:
	full path of the selected file


2DO*** $AAA.FS.MaxDepth
#>
function UI-File-Classic
	( 
	[string]$xPath     = ".",
	[string[]]$xFilter = "*.exe"
	)
	{
	"***2implement"
	

	}





<#
.SYNOPSIS
Show a menu of:
	files in argumented PATH (defaults to  .)
	filtered by argumented filter (defaults to *.exe)

	UI-File-Tree . *.exe						(default)
	UI-File-Tree -xPath . -xFilter *.exe		(default)


Returns:
	full path of the selected file


2DO*** $AAA.FS.MaxDepth
#>
function UI-File-Tree
	( 
	[string]$xPath     = ".",
	[string[]]$xFilter = "*.exe"
	)
	{
	$xItems = `
		Get-ChildItem `
			-Path $xPath `
			-Include $xFilter `
			-Depth 16 `
			-Recurse;

	# extract OBJECT-NAMES 
	# and OBJECT-CONTAINERS
	$xFiles   = $xItems.BaseName;
	$xFolders = $xItems.Directory.Name | ForEach-Object { "[{0}]"  -f $_ };
	
	# ADD ESCAPE OPTION
	$xFiles   += "<exit>";
	$xFolders += "..."
	
	
	$x = AAA-Menu $xFiles $xFolders
	
	
	# ?USER ABORTED
	if ( $x -eq ( $xFiles.Length - 1 ) ) { return $null }
	
	
	return $xItems[ $x ].FullName;
	}



<#
.SYNOPSIS
Show a menu of 
	files in argumented PATH (defaultS TO .)
	filtered by argumented filter (defaults to *)

***2DO
	with 1 file only MENU acta as a string

#>
function UI-File-Type( 
	[string]$xPath      = ".",
	[string[]] $xFilter = "*"
	)
	{
	# EXIT IF INVALID PATH
	if( -not ( Test-Path -Path $xPath -PathType Container ) )
		{ Throw "Path is not a container..." }

	# $xFiles = Get-ChildItem -Path $xPath
	$xFiles = Get-ChildItem -Path $xPath -Include $xFilter -Recurse -Depth 0;

	# EXIT IF NO ELEMENTS 
	if ( -not $xFiles){ return $null }


	$xFilesX = $xFiles | Sort-Object -Property Extension

	<#
	$x = Get-ChildItem -Path . -Include @( "*.html", "*.png" )  -Recurse  -Depth 0; 
		$xx = $x | Sort-Object -Property Extension; 
		$xxx = $xx.BaseName; 
		$xxxx = $xx.Extension; AAA-Menu $xxx $xxxx

	#>

	$xNames = $xFilesX.BaseName;
	$xTypes = $xFilesX.Extension; 

	# ADD RETURN-EXCEPTION OPTION
	$xNames += "<Exit>"
	$xTypes += "..."

	$x = AAA-Menu $xNames $xTypes

	# ?EXCEPTION SELECTED??
	if ( $x -eq $xNames.Length - 1 ){ return $null }

	# return the filename
	return $xNames[ $x ]

	}

