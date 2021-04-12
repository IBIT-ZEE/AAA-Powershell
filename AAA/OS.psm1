

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#  |O|S|
#
#
<#
.SYNOPSIS
OS Related Functionality


#>
function OS-(){ AAA-Functions }




<#
.SYNOPSIS
OS Information (see alse System-info)

Microsoft Windows 10 Pro 10.0.18363, 18363/Multiprocessor Free 64-bit SP=0.0
33397252/28038924 (Memory/Free) 
2019-12-20 20:57:59, 2020-01-23 18:42:03 (Install/Last-Boot)
\Device\HarddiskVolume5 <> \Device\HarddiskVolume4 (Device System <> Boot)
C:Windows, Debug is Off
OS-SKU=48, 00331-10000-00001-AA303
MUILanguages={en-GB, pt-PT}/0809/1252/44/2057
OEM (2/0)

...
Name                                      :Microsoft Windows 10 Pro|C:\Windows|\Device\Harddisk4\Partition1
SystemDirectory                           : C:\Windows\system32
SystemDrive                               : C:
Status                                    : OK
Description                               : 
CreationClassName                         : Win32_OperatingSystem
CSCreationClassName                       : Win32_ComputerSystem
LocalDateTime                             : 2020-01-23 20:32:16
MaxNumberOfProcesses                      : 4294967295
MaxProcessMemorySize                      : 137438953344
SizeStoredInPagingFiles                   : 4980736
TotalSwapSpaceSize                        : 
TotalVirtualMemorySize                    : 38377988
FreeSpaceInPagingFiles                    : 4980736
FreeVirtualMemory                         : 33093656
CSName                                    : ZEE-PC
CurrentTimeZone                           : 0
Distributed                               : False
NumberOfProcesses                         : 167
OSType                                    : 18
OtherTypeDescription                      : 
CSDVersion                                : 
DataExecutionPrevention_32BitApplications : True
DataExecutionPrevention_Available         : True
DataExecutionPrevention_Drivers           : True
DataExecutionPrevention_SupportPolicy     : 2
EncryptionLevel                           : 256
ForegroundApplicationBoost                : 2
LargeSystemCache                          : 
Manufacturer                              : Microsoft Corporation
Organization                              : 
PAEEnabled                                : 
PlusProductID                             : 
PlusVersionNumber                         : 
PortableOperatingSystem                   : False
Primary                                   : True
ProductType                               : 1
OSProductSuite                            : 256
SuiteMask                                 : 272
PSComputerName                            : 
CimClass                                  : root/cimv2:Win32_OperatingSystem
CimInstanceProperties                     : {Caption, Description, InstallDate, Name...}
CimSystemProperties                       : Microsoft.Management.Infrastructure.CimSystemProperties

#>
function OS-Info()
	{
	$xData = Get-CimInstance Win32_OperatingSystem

	"{0} {1} {2}, build {3}, {4}, SP={5}.{6} " -f `
		$xData.Caption, $xData.Version, $xData.BuildNumber, $xData.BuildType, $xData.OSArchitecture, $xData.ServicePackMajorVersion, $xData.ServicePackMinorVersion;
	
	"Memory {0}/{1} (Total/Free)" -f $xData.TotalVisibleMemorySize, $xData.FreePhysicalMemory;

	"Moments {0} / {1} (Installed/Last-Boot)" -f $xData.InstallDate, $xData.LastBootUpTime;

	"Devices {0} <> {1} (System<>Boot)" -f $xData.SystemDevice, $xData.BootDevice;

	"Installed in {0} ~> Debug={1}" -f $xData.WindowsDirectory, ( "Off", "On" )[$xData.Debug];

	"SKU={0}; Serial={1}" -f $xData.OperatingSystemSKU, $xData.SerialNumber; 

	"Language {0}, Locale {1}, Codeset {2}, Country {3}, MUI {4}" -f `
		$xData.OSLanguage, $xData.Locale, $xData.CodeSet, $xData.CountryCode, ($xData.MUILanguages -join "+");

	"Current user is {0}; users {1}; Licensed {2}" -f $xData.RegisteredUser, $xData.NumberOfUsers, $xData.NumberOfLicensedUsers;
	""
	""
	
	}


<#
.SYNOPSIS
Get Users Account

Name | Domain | Status | Local | Enabled | PW-Ex/Ch/Rq
#>

function OS-Users()
	{
	Get-CimInstance Win32_UserAccount
	}


<#
.SYNOPSIS
Is a OS restart pending?
get info from registry
#>
function OS-PendingRestart()
	{ 
	Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" 
	}

