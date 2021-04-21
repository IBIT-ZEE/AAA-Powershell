<#

#>


Set-StrictMode -Version 5;












# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
#  |S|O|F|T|W|A|R|E| 
#

function Software- { AAA-List }

function Software-XXX 
	{
@'
Get-Command -Module PackageManagement
Find-Package -Provider chocolatey
Find-Package -Provider chocolatey -name notepad*
Find-Package -Provider chocolatey -name notepadplusplus | Install-Package
Install-Package -Name ".\7z920.msi" -force
Get-Package -Provider Programs -IncludeWindowsInstaller
Get-Package -Provider Programs -IncludeWindowsInstaller -Name "7-Zip*"
Get-Package -Provider Programs -IncludeWindowsInstaller -Name "7-Zip*" | Uninstall-Package
Get-Package -Provider MSU | fl -Property name, summary
'@
	}

function Software-Help
	{

	} 

function Software-Install {} 


function Software-Installed {} 

function Software-Uninstall {} 










