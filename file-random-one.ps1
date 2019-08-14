

$xFolder = 'D:\(audio) %MP3'
$xType   = '*.mp3'
Get-ChildItem -Recurse -Path $xFolder -Filter $xType `
    | Select-Object Name, Length, DirectoryName, CreationTime, LastAccessTime `
    | Out-GridView

# $x = [System.IO.Directory]::GetFiles($xFolder, $xType ).Count

# Out-GridView -inputobject $x

# Read-Host -Prompt $x.Count


