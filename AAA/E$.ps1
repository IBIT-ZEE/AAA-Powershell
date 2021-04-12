<#

Euro$ Analyzer/Projector


Draws
	id
	Date
	Ball 1..5 as byte
	Star 1..2 as byte
	Hit-Balls
	Hit-Stars

Bets
	id
	*Relation Draws.id 1..n
	Ball 1..5
	Star 1..2

#>


$xKeys = [System.Data.DataTable]::new( "Draws" );
$xBets = [System.Data.DataTable]::new( "Bets" );


$xID = [System.Data.DataColumn]::new( "id", [Int32] );
$xID.AutoIncrement = true;              # *seed=0 *step=1
$xID.ReadOnly = $true;

$xName  = [System.Data.DataColumn]::new( "Date" , [datetime]  );
$xValue = [System.Data.DataColumn]::new( "Ball1", [byte]    );
$xValue = [System.Data.DataColumn]::new( "Ball2", [byte]    );
$xValue = [System.Data.DataColumn]::new( "Ball3", [byte]    );
$xValue = [System.Data.DataColumn]::new( "Ball4", [byte]    );
$xValue = [System.Data.DataColumn]::new( "Ball5", [byte]    );
$xValue = [System.Data.DataColumn]::new( "Star1", [byte]    );
$xValue = [System.Data.DataColumn]::new( "Star2", [byte]    );
$xFlag  = [System.Data.DataColumn]::new( "flag" , [boolean]  );
 $xKeys.Columns.Add( $xName )

$xTable.Columns.Add( $xId    );
$xTable.Columns.Add( $xName  );
$xTable.Columns.Add( $xDate  );
$xTable.Columns.Add( $xValue );
$xTable.Columns.Add( $xObs   );
$xTable.Columns.Add( $xFlag  );

