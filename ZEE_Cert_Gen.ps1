
# this script is to interact in CLI
Write-Host "ZEE SAID :: To excute interactively in CLI"
Return

# View certificates
Get-ChildItem cert:
Get-ChildItem cert:\CurrentUser\My
Get-ChildItem cert:\CurrentUser\Root

# Will prompt for passwords
# Create certificate for PC
makecert 
    -n "CN=ZEE Scripts (Computer)" 
    -a sha1 
    -eku 1.3.6.1.5.5.7.3.3 
    -r
    -sv root.pvk root.cer 
    -ss Root 
    -sr localMachine

# Create certificate for User
makecert
    -n "CN=ZEE Scripts (User)"  
    -pe
    -ss MY 
    -a sha1
    -eku 1.3.6.1.5.5.7.3.3
    -iv root.pvk 
    -ic root.cer

# Sign a script with a certificate
Set-AuthenticodeSignature C:\dat\PowerShell\_test.ps1 @(Get-ChildItem cert:\CurrentUser\My -CodeSigningCert)[0]


# SIG # Begin signature block
# MIIEFQYJKoZIhvcNAQcCoIIEBjCCBAICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUVB7GtN/hZapNFjefS0BMSnK1
# tV+gggIqMIICJjCCAZOgAwIBAgIQMj5iIaz+jYxP9A5z4FDpRjAJBgUrDgMCHQUA
# MCExHzAdBgNVBAMTFlpFRSBTY3JpcHRzIChDb21wdXRlcikwHhcNMTIwNDIxMTU1
# NzQwWhcNMzkxMjMxMjM1OTU5WjAdMRswGQYDVQQDExJaRUUgU2NyaXB0cyAoVXNl
# cikwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAM0LNuPXZkCT3bxAqe2ohew8
# Y8S1GRm+cET2gDrV2sfWadsNlH78KpGDgo63Y0TgbtDTz5bxyvnnjO4HmJcpPHFW
# e2E/SJ7dbq/+xluc3NlwLOux9h2Fk3e2JQSrgtLA8xLVYrCWibW6bGdFc5DK/E7X
# IwxunvNlmOAIeUcSdxtbAgMBAAGjazBpMBMGA1UdJQQMMAoGCCsGAQUFBwMDMFIG
# A1UdAQRLMEmAEOdV+96srWmydg8puAICgIehIzAhMR8wHQYDVQQDExZaRUUgU2Ny
# aXB0cyAoQ29tcHV0ZXIpghBQ2XpTiE05h0KzRJ2BDRu2MAkGBSsOAwIdBQADgYEA
# BllrhJ27LZJlZGw9sst5BxiFm4I2qjmQHOioPNdZol9HNHBf+8t9B6ol0cdUdZJ7
# pjOux+RN3fvEYQB0LCli1p6ZcqXfEFYFND75BNv/W5EsSNL+O78anVPiHOHDbXal
# PkdIpy2/u7lP+yM89xeKevjrbr+wmkrWAPMp1y/XK+wxggFVMIIBUQIBATA1MCEx
# HzAdBgNVBAMTFlpFRSBTY3JpcHRzIChDb21wdXRlcikCEDI+YiGs/o2MT/QOc+BQ
# 6UYwCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZI
# hvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcC
# ARUwIwYJKoZIhvcNAQkEMRYEFKE+yCEcsU61Mb+Lt4rRTAR53YppMA0GCSqGSIb3
# DQEBAQUABIGAaXqWftZgldldigX8Djgv71fXCVq6VOzNwsipwU8YnHzvbCE71QOZ
# 2tlMNeY6+52p5ZshoEI0fTbcJQW2yDgR0c2os+jZKlDjVcPRaAzNAIqcTiJrBk4p
# GgJmouwDsDrqkhCLEKoWN1GjLY+AN9IdTY4vr33AgE8FE7THCVJuR1s=
# SIG # End signature block
