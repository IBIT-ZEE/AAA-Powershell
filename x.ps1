# AAA-Log
# DATA
$x = @( 1, 22, 333, 4444, 55555, 666666, 7777777 )
$xx = @{ 'one' = 1; 'two' = 22; 'three' = 333; 'four' = 4444; 'five' = 55555;  }

# AAA-Menu( $x );
# Array-WhereBeginWith( $x, "2" );

$a = @(); 
$x | % { $a += New-Button $_ }
#Show-UI  { UniformGrid $a }
#Show-UI { StackPanel { $a } }
#Show-UI { WrapPanel { $a } }

# UniformGrid $a -margin 5 -background yellow -ShowUI
# -Margin 5 -Padding 10
# -FontFamily Consolas -FontSize 24 -FontWeight Bold -FontStyle Italic
# -Background Yellow -Foreground Crimson
#


New-Window -AllowDrop `
    -On_Drop { $videoPlayer.Source = @( $_.Data.GetFileDropList() )[0]; $videoPlayer.Play() } `
    -On_Loaded { } `
    -On_Closing { $videoPlayer.Stop() } `
    -Content { New-MediaElement -Name VideoPlayer -LoadedBehavior Manual } `
    -Show
