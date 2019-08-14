
# load aaa system
. "c:\dat\powershell\aaa.ps1"


[reflection.assembly]::LoadWithPartialName("system.windows.forms")

$f0 = New-Object windows.forms.form
$b0 = New-Object windows.forms.button

$f0.Text = "MyForm#0"
$b0.Text = "MyButton0"

$f0.Controls.Add($b0)
$b0.Dock = "fill"
$b0.add_click( { $f0.Close() } )
$f0.ShowDialog()





