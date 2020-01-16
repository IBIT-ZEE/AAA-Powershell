Function WindowsSystemInfo
{
    $CimCPU1 = Get-CimInstance win32_processor -Property *

    $ToTalSystemInfo = systeminfo
    $TotalArchitechure = [PSCustomObject]@{
        'Host Name: '             = ($ToTalSystemInfo  | Select-String 'Host Name:').ToString().Split(':')[1].Trim()
        'OS Name: '               = ($ToTalSystemInfo  | Select-String 'OS Name:').ToString().Split(':')[1].Trim()
        'OS Version: '            = ($ToTalSystemInfo  | Select-String -pattern '^OS Version:').ToString().Split(':')[1].Trim()
        'Model name: '            = $CimCPU1.Name
        'CPU MHz: '               = $CimCPU1.MaxClockSpeed 
        'Total Physical Memory: ' = ($ToTalSystemInfo  | Select-String 'Total Physical Memory:').ToString().Split(':')[1].Trim()
    }
    $TotalArchitechure
}