. .\Core\Function-LinuxSystemInfo.ps1
. .\Core\Function-WindowsSystemInfo.ps1

$InventoryFile = 'c:\temp\ServerInventory.csv'

if (test-path $InventoryFile)
{Remove-Item $InventoryFile}

$Servers = "TuxSnips", "Datacenter"

New-PSSession -HostName $Servers -UserName 'scott' -ErrorAction SilentlyContinue -ErrorVariable EV 

$allFunctionDefs = "function ForLinux { ${function:LinuxSystemInfo} }; function ForWindows { ${function:WindowsSystemInfo} }"

$DataString = Invoke-Command -ArgumentList $allFunctionDefs -Session (Get-PSSession | Where-Object {$_.State -like 'Opened'}) -ScriptBlock {
    Param( $allFunctionDefs )
    . ([ScriptBlock]::Create($allFunctionDefs))
    if ($IsLinux)
    {
        ForLinux
    }
    if ($IsWindows)
    {
        ForWindows
    }
} -ErrorAction SilentlyContinue -AsJob | Get-Job | Wait-Job

$data = Receive-Job -Job $DataString

$data | Export-Csv $InventoryFile -Append 

Invoke-Item $InventoryFile


# Cleanup of Open Sessions
$RemoveSession = Get-PSSession 
$RemoveSession | Remove-PSSession