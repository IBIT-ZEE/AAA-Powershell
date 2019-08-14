

function test( $a, $b )
{
# $aXML = new-object
([xml] (new-object net.webclient).downloadstring("http://blogs.mdsn.com/powershell/rss.aspx")).rss.channel.item | format-table title, link

}

