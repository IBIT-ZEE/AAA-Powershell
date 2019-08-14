# Script for checking PS3 on Amazon$smtpserver = "smtp.nospam.com"

cls
$email = "zee@clix.pt"
$awskey = "106DGKQ375F3A7FXNC02"
$asin = "B0009VXAM0" #60GB
# $asin = "B000IZWNLG" #20GB

	$url = "" +
	"http://webservices.amazon.com/onca/xml?Service=AWSECommerceService" +
	"&AWSAccessKeyId=" + $awskey +
	"&Operation=ItemLookup" +
	"&ItemId=" + $asin +
	"&ResponseGroup=Offers"
$rxml = [xml](new-object Net.WebClient).DownloadString("$url")
$price =  $rxml.ItemLookupResponse.Items.Item.Offers.Offer.OfferListing.Price.Amount
$price = $price/100   

if ($price -gt 0) 
	{
    $textbody = "Playstation 3 is now $" + $price + " at Amazon "
	}
	
	
	
	
# http://webservices.amazon.com/onca/xml?Service=AWSECommerceService&AWSAccessKeyId=106DGKQ375F3A7FXNC02&Operation=ItemLookup&ItemId=B0009VXAM0&ResponseGroup=Offers
