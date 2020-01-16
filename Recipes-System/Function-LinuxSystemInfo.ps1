#region LinuxSystemInfo
function LinuxSystemInfo
{
    $LsCPUInfo = lscpu
    $MemoryInfo = vmstat -s
    $LinuxOSInfo = Get-Content /etc/*-release
    $MyNameis = (hostname)
    [int]$TotalMemory = ((($MemoryInfo.split("\r\n")[0]).trim()).Split()[0]) / 1000

    $MachineArchitechure = [PSCustomObject]@{
        'Host Name: '             = $MyNameis
        'OS Name: '               = (($LinuxOSInfo.split("\r\n")[0]).trim())
        'OS Version: '            = (($LinuxOSInfo | Select-String 'Version=')[0]).ToString().split('"')[1]
        'Model name: '            = (($LsCPUInfo.split("\r\n")[12]).Split(':')[1]).trim()
        'CPU MHz: '               = (($LsCPUInfo.split("\r\n")[14]).Split(':')[1]).trim()
        'Total Physical Memory: ' = "$TotalMemory MB"
    }
    $MachineArchitechure 
}
#endregion LinuxSystemInfo
