#!/usr/bin/perl 
use DBI; # database connection ;
use Cwd;

$dbname="cbmonitor";
$user="root";
$pass="CB302IMC";
#connect to the database 

$dbh = DBI->connect("DBI:mysql:$dbname",$user,$pass);

#retrieve the accounting_region data
$sth = $dbh->prepare("select regionid, CONCAT(prefix,regioncode),prefix from accounting_region order by prefix,regioncode desc;");
$sth->execute or print "couldn't execute statement" .$sth->errstr; 
$i_counter=0;
$last_save=0;
$last_counter=0;
while (@row = $sth->fetchrow_array) {
	$region_data[$i_counter][0]=$row[0];
	$region_data[$i_counter][1]=$row[1];
	$region_data[$i_counter][2]=$row[2];
	if (not ($last_save eq $row[2]))
	{
		$region_start[$last_counter][0]=$row[2];
		$region_start[$last_counter][1]=$i_counter;
		$last_save=$row[2];
		$last_counter=$last_counter + 1;
	}
	$i_counter=$i_counter + 1 ;

}

sub calcregidprim {
$RegionID1=$_[0];
$regionidprim1="";
$CountryCode1="";
if ($RegionID1 =~ /^90392/) { #cyprus north
		$CountryCode1 = substr ($RegionID1, 0, 3);
		}
		elsif ($RegionID1 =~ /^1204|^1242|^1246|^1250|^1264|^1268|^1284|^1289|^1306|^1340|^1345|^1403|^1416|^1418|^1438|^1441|^1450|^1473|^1506|^1514|^1519|^1604|^1613|^1647|^1649|^1664|^1671|^1684|^1705|^1709|^1758|^1767|^1778|^1780|^1784|^1787|^1807|^1808|^1809|^1819|^1829|^1849|^1867|^1868|^1869|^1876|^1902|^1905|^1907|^1939|^61891006|^61891007|^61891008|^61891010|^61891011|^61891012|^6189162|^6189164|^6721/) {
		$CountryCode1 = substr ($RegionID1, 0, 4);
	}
	
	elsif ($RegionID1 =~ /^20|^27|^30|^31|^32|^33|^34|^36|^39|^40|^41|^43|^44|^45|^46|^47|^48|^49|^51|^52|^53|^54|^55|^56|^57|^58|^60|^61|^62|^63|^64|^65|^66|^81|^82|^84|^86|^87|^90|^91|^92|^93|^94|^95|^98/) {
	$CountryCode1 = substr ($RegionID1, 0, 2);
	}

	elsif ($RegionID1 =~ /^1|^7/) {
	$CountryCode1 = substr ($RegionID1, 0, 1);
	}

	else { $CountryCode1 = substr ($RegionID1, 0, 3);
	}
	
	#calculate the regionidprim
	#find the first entry related to the country
	$find_s=0;
	for ($i=0; $i < @region_start; $i++)
	{if ($region_start[$i][0] eq $CountryCode1) 
	 {
	   $start_s=$region_start[$i][1];
	   $find_s=1;
	   last;
	  }
	}
 	if( $find_s == 1) 
	{
	 for( $i = $start_s; $i < @region_data; $i++ )
	{ $regionidprim1=0;
	$regiontemp=substr ($RegionID1,0,length($region_data[$i][1]));
	#print "$i 1 : $region_data[$i][1],substring : $regiontemp , $region_data[$i][0]  \n" ;
		if ($region_data[$i][1] eq $regiontemp)
		{
		  $regionidprim1=$region_data[$i][0];
		  last;
		}
	}
	}
	#end regionidprim
	
	return ($regionidprim1,$CountryCode1);


}

sub IsLeapYear
{
   my $year = shift;
   return 0 if $year % 4;
   return 1 if $year % 100;
   return 0 if $year % 400;
   return 1;
}


sub dec2hex {
    # parameter passed to the subfunction
    my $decnum = $_[0];
    # the final hex number
    my $hexnum;
    my $tempval;
    $hexnum='';
    while ($decnum != 0) {
   	 # get the remainder (modulus function) by dividing by 16
    	$tempval = $decnum % 16;
    	# convert to the appropriate letter if the value is greater than 9
    	if ($tempval > 9) {
    		$tempval = chr($tempval + 55);
    	}
   	# 'concatenate' the number to what we have so far in what will be the final variable
   	$hexnum = $tempval . $hexnum ;
    	# new actually divide by 16, and keep the integer value of the answer
    	$decnum = int($decnum / 16); 
    	# if we cant divide by 16, this is the last step
    	if ($decnum < 16) {
    		# convert to letters again..
    		if ($decnum > 9) {
    			$decnum = chr($decnum + 55);
    		}
    
   		# add this onto the final answer.. reset decnum variable to zero so loop will exit
    		$hexnum = $decnum . $hexnum; 
    		$decnum = 0 
    	}
    }
    return $hexnum;
    } # end sub
sub compareDbDateTime
    {
    	# answers how does date1 compare to date2
    	# (greater than "1", less than "-1", or equal to "0")
    	my ($dt1, $dt2) = @_;
    	
    	my @datetime1;
    	my @datetime2;
    	my $limit = 0;
    	
    	my ($date1, $time1) = split(/ /, $dt1);
    	push(@datetime1, split(/-/, $date1));
    	push(@datetime1, split(/:/, $time1));
    	
    	my ($date2, $time2) = split(/ /, $dt2);
    	push(@datetime2, split(/-/, $date2));
    	push(@datetime2, split(/:/, $time2));
    	
    	# compare up to the lesser number of elements
    	# (like if one datetime only has a date and no time, don't try to compare time)
    	if(@datetime1 == @datetime2) { $limit = @datetime1 }
    	elsif (@datetime1 > @datetime2) { $limit = @datetime2 }
    	elsif (@datetime1 < @datetime2) { $limit = @datetime1 }
    	
    	for (my $i = 0; $i < $limit; $i++)
    	{
    		if ($datetime1[$i] > $datetime2[$i]) { return 1; last; }# date1 greater than date2
    		if ($datetime1[$i] < $datetime2[$i]) { return -1; last; }# date1 less than date2
    	}
    	return 0;# dates are equal
    }

1;
