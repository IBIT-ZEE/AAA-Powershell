




# 
Get-ChildItem -Path $env:windir -Filter *.log |
  Out-GridView -PassThru -Title "123" |
	  ForEach-Object { notepad $_.FullName } 
