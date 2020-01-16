#Create a New Registry entry, let's create a key.  
New-Item -Path HKCU:\SOFTWARE\Techsnips

#Create Registry values
Set-ItemProperty HKCU:\Software\Techsnips -Name Username -Value "Techsnips User" -Type String
Set-ItemProperty HKCU:\Software\Techsnips -Name Version -Value "20" -Type Dword
#We can also use Set-Item... to modify a value
Set-ItemProperty HKCU:\Software\Techsnips -Name Version -Value "30" -Type Dword

#Create an entry to multiple locations, I'll create another key first. 
New-Item -Path HKCU:\Software\Test
New-ItemProperty -Path HKCU:\Software\Test, HKCU:\Software\Techsnips -Name Binaries -PropertyType String -Value "c:\techsnips"

#Rename Registry value
Rename-ItemProperty -Path HKCU:\Software\Techsnips -Name Username -NewName ID