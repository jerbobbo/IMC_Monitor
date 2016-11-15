#!/usr/bin/perl -w
use File::Copy;
use DBI; # database connection ; 
use Cwd;
use Net::FTP;
use Date::Calc qw(Today Add_Delta_Days);
use Win32;
use POSIX qw(ceil floor);
use RRDs;
require ("imcfunctions.pl");


sub main();
sub PrintHTMLFile();
sub CreatePL($$$$$$$);
sub CreateCFG($$$$$$);
sub MakeService($$);

main();


sub PrintHTMLFile() {

	$indexheader = 'c:\imc tel inc\monitor\Radius\IndexHeader.txt';
	$indexgw = 'c:\imc tel inc\monitor\Radius\IndexGW.txt';
	$indexactive = 'c:\imc tel inc\monitor\Radius\IndexActive.txt';
	$indexinactive = 'c:\imc tel inc\monitor\Radius\IndexInactive.txt';
	$index24 = 'c:\imc tel inc\monitor\Radius\Index24Hours.txt';
	$indexframesleft = 'c:\radiuslog\IndexFramesLeft.html';
	$inactiveframe = 'c:\inetpub\wwwroot\TrafficData\IMC\InactiveFrame.html';
	copy($indexframesleft,'c:\radiuslog\IndexFramesLeftold.html');
	#$indexframesleft = 'c:\imc tel inc\monitor\Radius\IndexFramesLeft2.html';


	open( INDHEAD, "<$indexheader") or die "Can't open $indexheader.\n";
	open( INDGW, "<$indexgw") or die "Can't open $indexgw.\n";
	open( INDACTIVE, "<$indexactive") or die "Can't open $indexactive.\n";
	open( INDINACTIVE, "<$indexinactive") or die "Can't open $indexinactive.\n";
	open( IND24, "<$index24") or die "Can't open $index24.\n";
	open( INDFRMLEFT, ">$indexframesleft") or die "Can't open $indexframesleft.\n";

	$localtime = localtime;

	print INDFRMLEFT '<p class=MsoNormal><b><font face="Verdana" style="font-size: 8pt" color="#0000FF">'.$localtime.'</font></b></p>';
	print INDFRMLEFT "\n";
	while($line = <INDHEAD>){
	print INDFRMLEFT "$line\n";
	}

	$Title = "GW";
	$htmlline1 = "</table><p class=MsoNormal><b><font face=\"Verdana\" style=\"font-size: 8pt\" color=\"#0000FF\">$Title</font></b></p>";
	
	print INDFRMLEFT "$htmlline1\n";
	print INDFRMLEFT '<table border=\'1\' cellpadding=\'1\' cellspacing=\'0\' style=\'font-size:8.0pt;font-family:Verdana\' bordercolor=\'#111111\'>';
	print INDFRMLEFT "<tr style=\'color:red\'><b><td></td><td>GW</td><td>Seiz</td><td>Ch</td><td>M/m</td><td>acd</td><td>asr</td><td>mod</td><td></td><td></td></b></tr>\n";

	while($line = <INDGW>){
	print INDFRMLEFT $line;
	}

	$Title = "Active";
	$htmlline1 = "</table><br><p class=MsoNormal><b><font face=\"Verdana\" style=\"font-size: 8pt\" color=\"#0000FF\">$Title</font></b></p>";
	
	print INDFRMLEFT $htmlline1;
	print INDFRMLEFT '<table border=\'1\' cellpadding=\'1\' cellspacing=\'0\' style=\'font-size:8.0pt;font-family:Verdana;color:#111111\' bordercolor=\'#111111\'>';
	print INDFRMLEFT "<tr style=\'color:red\'><b><td>Client</td><td>Country</td><td>G</td><td>Seiz</td><td>Ch</td><td>M/m</td><td>acd</td><td>asr</td><td>mod</td></b></tr>\n";

	while($line = <INDACTIVE>){
	print INDFRMLEFT $line;
	}
	
	$Title = "Active in Past 24 Hours";
	$htmlline1 = "</table><br><p class=MsoNormal><b><font face=\"Verdana\" style=\"font-size: 8pt\" color=\"#0000FF\">$Title</font></b></p>";
	print INDFRMLEFT $htmlline1;
	print INDFRMLEFT '<table border=\'1\' cellpadding=\'1\' cellspacing=\'0\' style=\'font-size:8.0pt;font-family:Verdana\' bordercolor=\'#111111\'>';
	print INDFRMLEFT "<tr style=\'color:red\'><b><td>Client</td><td>Country</td><td>GW</td><td>24H.Seiz</td></b></tr>\n";

	while($line = <IND24>){
	print INDFRMLEFT $line;
	}

	print INDFRMLEFT "</table></div> </body> </html>\n";	

	($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time) ; 

	if ($Hour == 15 && $Minute < 27){
		open ( INACTFRAME, ">$inactiveframe") or die "Can't open $inactiveframe.\n";	
		$Title = "Inactive";
		$htmlline1 = "<html><p class=MsoNormal><b><font face=\"Verdana\" style=\"font-size: 8pt\" color=\"#0000FF\">$Title</font></b></p>";
		print INACTFRAME $htmlline1;
		print INACTFRAME '<table border=\'1\' cellpadding=\'1\' cellspacing=\'0\' style=\'font-size:8.0pt;font-family:Verdana\' bordercolor=\'#111111\'>';
		print INACTFRAME "<tr style=\'color:red\'><b><td>Client</td><td>Country</td><td>GW</td></b></tr>\n";

			while($line = <INDINACTIVE>){
			print INACTFRAME $line;
			}
		print INACTFRAME "</table> </div> </body> </html>\n";
	}

}



sub CreatePl($$$$$$$) {
	($Name, $Country, $GW, $PrimaryKey, $VariableType, $InVal, $OutVal) = @_;
	$plfile = "c:\\mrtg-2.10.13\\Scripts\\$Name-$Country-$GW-$PrimaryKey-$VariableType\.pl";
	#$plfile = "c:\\imc tel inc\\monitor\\radius\\scripts\\$Name-$Country-$GW-$PrimaryKey-$VariableType\.pl";
	open( PLFILE, ">$plfile") or die "Can't open $plfile.\n";

	print PLFILE "\#1/usr/bin/perl\n";

	print PLFILE "print \"$InVal\\n\"\;\n";
	print PLFILE "print \"$OutVal\\n\"\;\n";
	print PLFILE "print \"0\\n\"\;\n";	
}

sub CreateCfg($$$$$$) {
	($Name, $FullName, $Country, $GW, $Gateway, $PrimaryKey) = @_;
	$mrtgDir = "c:\\mrtg-2\.10\.13\\bin\\";
	#$mrtgDir = "c:\\imc tel inc\\monitor\\radius\\bin\\";
	#$mrtgScriptDir = "c:\\mrtg-2\.10\.13\\Scripts\\";
	$DestName = "$Name-$Country-$GW-$PrimaryKey";
	$mrtgCFG = "$mrtgDir"."$DestName\.cfg";
	$mrtgTemplate = $mrtgDir."mrtgTemplate\.txt";
	$DestDesc = "$FullName $Country $Gateway";
	
	open( MRTGTEMP, "<$mrtgTemplate") or die "Can't open $mrtgTemplate.\n";
	open( CFGFILE, ">$mrtgCFG") or die "Can't open $mrtgCFG.\n";

	while($line = <MRTGTEMP>){
	
	if ($line =~ /Client/) {
	$line =~ s/Client/$Name/;
	}

	if ($line =~ /Destination/) {
	$line =~ s/DestinationName/$DestName/g;
	$line =~ s/DestinationDesc/$DestDesc/g;
	}
	
	print CFGFILE $line;
	}
}


sub MakeService($$){
	($TargetName, $CFGName) = @_;
	$FireDir = "c:\\Program Files\\Firedaemon\\";
	#$FireDir = "c:\\imc tel inc\\monitor\\radius\\FireDaemon\\";
	$XMLTemplate = $FireDir."XMLtemplate2\.txt";
	$XMLFile = $FireDir.$TargetName."\.xml";
	$FireControl = 'c:\FireStart.bat';
	open ( FIRECONTROL, ">>$FireControl");

	open( XMLTEMP, "<$XMLTemplate") or die "Can't open $XMLTemplate.\n";
	open( XMLFILE, ">$XMLFile") or die "Can't open $XMLFile.\n";

	while ($line = <XMLTEMP>) {
	
	$line =~ s/CFGName/$CFGName/g;
	$line =~ s/TargetName/$TargetName/g;

	print XMLFILE $line;
	}
	
	print FIRECONTROL "firedaemon -i $TargetName\n";
	print FIRECONTROL "firedaemon --start $TargetName\n";
}

sub main() {

($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time) ; 
$timestamp = "$Month$Day-$Hour:$Minute:$Second";

#1- Get the CDRS from the Sansays + select the fields to be used 


#calculate Today's date
@todayt=Add_Delta_Days( Today(), 0);# doit etre egal a 0 pour today
$ydayt =$todayt[1];
$ddayt=$todayt[2];
$ydayt = "0$ydayt" unless ($ydayt > 9);
$ddayt="0$ddayt" unless ($ddayt > 9);

$TodaydateDate= "$ydayt-$ddayt-$todayt[0]";




#calculate yesterday date 
@yesterday = Add_Delta_Days( Today(), -1);# doit etre egal a -1 pour yesterday
$yday =$yesterday[1];
$dday=$yesterday[2];
$yday = "0$yday" unless ($yday > 9);
$dday="0$dday" unless ($dday > 9);


#generate csv files: in , out and log files
$radiusinoutlogfile ="IMC_Monitor.log";
$radiusincsvfile ="Monitor.insansay.csv";
$radiusoutcsvfile = "Monitor.outsansay.csv";



#assign file handles

open( OUTFILEIN, ">$radiusincsvfile");
open( OUTFILEOUT, ">$radiusoutcsvfile");
open( OUTFILELOG, ">>$radiusinoutlogfile");





#test 
($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time) ; 
$Month=$Month+1;
$timestamp = "$Month$Day-$Hour:$Minute:$Second";
print OUTFILELOG "start time : $timestamp \n";
#test end 

#used for the bulkinsert to locate the csv files
$abs_path=cwd;
$abs_path=~ s#/#\\#g;
$abs_path=$abs_path."\\";

#SANSAYS-IP ADDRESS 
$softswitch[0]="209\.51\.180\.131";
$softswitch[1]="217\.14\.132\.206";


$softswitch[2]="209\.51\.180\.137";
$softswitch[3]="217\.14\.132\.202";

# LOOP on SANSAYs to get the CDRS
$switchcount=0;


#TOREMOVE
print('before boucle switchcount');
#Loop on sansays IPs
BOUCLE: while ($switchcount < 4 ) 
	{
		eval{
			$ftp = Net::FTP->new($softswitch[$switchcount],Debug => 3);
			
			#Login credentials
			$ftp->login("cdr","72NUJ21e") ;
		
			#change working directory
			$ftp->cwd("/CDR/"); 
		};

		if ($@) 
		{
		print OUTFILELOG "errors occured $@ : $timestamp \n";
		$switchcount=$switchcount +1 ;
		next;
		}
		$ftp->binary;
		
		#List Cdrs FILES UNDER /CDR
		@files=$ftp->ls("-t *.cdr");
		$radiuslog = $files[0];
		
		print('before boucle read @files');

				#print "$file $filetime\n";
				
					$ftp->get("$radiuslog")    or print  "error message :$ftp->message";
					
					print "processing file $radiuslog \n";
					#test 
					($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time) ; 
					$Month=$Month+1;
					$timestamp = "$Month$Day-$Hour:$Minute:$Second";
					print OUTFILELOG "file $radiuslog : $timestamp \n";
					#test end 

					eval { open( INFILE, "<$radiuslog") ; } ;
					if ($@) 
					{
					print OUTFILELOG "Can't open $radiuslog  : $timestamp \n";
					$switchcount=$switchcount +1 ;
					next BOUCLE;
					} 
					flock( INFILE, 2);
					
					
					
	($SetupDate, $SetupTime, $SetupTime2, $ConnectTime, $DisconnectTime, $CallingID, $CalledID, $Member, $CountryCode, $RegionID, $ConfID, $CallOrigin, $CallType, $GWip, $RxdCalledNumb, $RxdCallingNumb, $FinalCalledNumb, $FinalCallingNumb, $RemoteAddress, $RemoteMedAddress, $Username, $NAStrunk, $NASd, $SessionTime, $DisconnectCause, $OutPackets, $InPackets, $OutOctets, $InOctets, $AcctStatusType,$regionidprim,$v_t) = ("","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","");
	($SetupDatet, $SetupTimet, $SetupTime2t, $ConnectTimet, $DisconnectTimet, $CallingIDt, $CalledIDt, $Membert, $CountryCodet, $RegionIDt, $ConfIDt, $CallOrigint, $CallTypet, $GWipt, $RxdCalledNumbt, $RxdCallingNumbt, $FinalCalledNumbt, $FinalCallingNumbt, $RemoteAddresst, $RemoteMedAddresst, $Usernamet, $NAStrunkt, $NASdt, $SessionTimet, $DisconnectCauset, $OutPacketst, $InPacketst, $OutOctetst, $InOctetst, $AcctStatusTypet,$regionidprimt,$v_tt) = ("","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","");

	LIRE: while($line = <INFILE>){
		@cdr_values=split(";",$line); 
		next LIRE if (@cdr_values<3);#to avoid processing the last line of the file whcih is an empty line
		@setupdate_val=split(" " ,$cdr_values[6]);
		$SetupDate = $setupdate_val[1]." ".$setupdate_val[2]." ".$setupdate_val[4];
		$SetupTime =$SetupDate." ".$setupdate_val[3];
		$SetupTime2 = 0;
		next LIRE if ($setupdate_val[1] eq '');
		$SetupTimet =$SetupTime;
		$SetupTime2t = 0;
		$SetupDatet = $SetupDate;

		if (($cdr_values[7] eq 'NA') || ($cdr_values[7] eq '')) {
			$ConnectTime=$SetupTime;
			$ConnectTimet=$SetupTime;
		} else {
			@connectdate_val=split(" " ,$cdr_values[7]);
			$ConnectTime=$connectdate_val[1]." ".$connectdate_val[2]." ".$connectdate_val[4]." ".$connectdate_val[3];
			$ConnectTimet=$ConnectTime;
		}
		if (($cdr_values[8] eq 'NA') || ($cdr_values[8] eq '')) {
			$DisconnectTime=$SetupTime;
			$DisconnectTimet=$SetupTime;
		} else {
			@disconnectdate_val=split(" " ,$cdr_values[8]);
			$DisconnectTime=$disconnectdate_val[1]." ".$disconnectdate_val[2]." ".$disconnectdate_val[4]." ".$disconnectdate_val[3];
			$DisconnectTimet=$DisconnectTime;
			
		}

		#next LIRE if ($SetupDate =~ /2000/);
		$GWip =$cdr_values[18];
		$GWip =~ s/:1720//;

		$GWipt =$cdr_values[35];
		
		$ConfID =$cdr_values[57]; 
		
		$ConfIDt =$cdr_values[57];
		
		$CallOrigin='answer';
		$CallOrigint='originate';
		$CallType='VoIP';
		$CallTypet='VoIP';
		$v_t='v';
		$v_tt='v';

		$CalledNumb=$cdr_values[17];
		if (($CalledNumb eq 'NA' ) || (length($CalledNumb) <2) ) {
			$CalledNumb=0;
		}
		$CalledNumb=~ s/\+//;
		$CalledNumb=~ s/#//;
		$CalledNumb=~ s/\,//;
		$RxdCalledNumb=$CalledNumb;
		$FinalCalledNumb=$CalledNumb;
		$CalledID =$CalledNumb;
		
		
		$CalledNumbt=$cdr_values[36];
		if (($CalledNumbt eq 'NA' ) || (length($CalledNumbt) <2) ) {
			$CalledNumbt=0;
		}
		$CalledNumbt=~ s/\+//;
		$CalledNumbt=~ s/#//;
		$CalledNumbt=~ s/\,//;
		$RxdCalledNumbt=$CalledNumbt;
		$FinalCalledNumbt=$CalledNumbt;
		$CalledIDt =$CalledNumbt;

		$CallingNumb = $cdr_values[15];
		if (($CallingNumb eq 'NA' ) || (length($CallingNumb) <2) ) {
			$CallingNumb=0;
		}
		$CallingNumb=~ s/\+//;
		$RxdCallingNumb = $CallingNumb;
		$FinalCallingNumb = $CallingNumb;
		$CallingID =$CallingNumb;
		$Username=$CallingNumb;

		$CallingNumbt = $cdr_values[34];
		if (($CallingNumbt eq 'NA' ) || (length($CallingNumbt) <2) ) {
			$CallingNumbt=0;
		}
		$CallingNumbt=~ s/\+//;
		$RxdCallingNumbt = $CallingNumbt;
		$FinalCallingNumbt = $CallingNumbt;
		$CallingIDt =$CallingNumbt;
		$Usernamet=$CallingNumbt;

		#$InOctets = $cdr_values[27];
		#$OutOctets = $cdr_values[28];
		#$InPackets = $cdr_values[25];
		#$OutPackets = $cdr_values[26];
	
		#$InOctetst = $cdr_values[46];
		#$OutOctetst = $cdr_values[47];
		#$InPacketst = $cdr_values[44];
		#$OutPacketst = $cdr_values[45];
		
		$InOctets =0;
		$OutOctets = 0;
		$InPackets = 0;
		$OutPackets = 0;
	
		$InOctetst = 0;
		$OutOctetst =0;
		$InPacketst = 0;
		$OutPacketst = 0;
		
	
		
		$SessionTime=ceil($cdr_values[56]/1000); 
		
		$SessionTimet=$SessionTime;

		if ( $cdr_values[11] ==0 ) {
			$DisconnectCause='0';
		} else
		{
		
		$DisconnectCause=dec2hex($cdr_values[11]);
		}
		
		$DisconnectCause=~ s/^\s+//;  #remove spaces from the beginning of the disconnectcause
		$DisconnectCause=substr($DisconnectCause,0,3);
		if (($DisconnectCause eq '3DB' ) ) {
			$DisconnectCause='22';
		}
		$DisconnectCauset=$DisconnectCause;

		$RemoteAddress =$cdr_values[16] ;
		$RemoteMedAddress=$RemoteAddress;
		#next LIRE if ($RemoteAddress eq '');
		
		$RemoteAddresst =$cdr_values[37] ;
		$RemoteMedAddresst=$RemoteAddresst;
		
		$NAStrunkt='0';
		$NASdt='0';
		$NAStrunk='0';
		$NASd='0';

		$CalledN = $CalledID;
		$CalledNt = $CalledIDt;

		if (substr ($CalledN, 0, 2) =~ /^77|^78/) {
			$Member = (substr ($CalledN, 0, 2));
			$Strt = 2;
		}

		else {
			$Member = substr ($CalledN, 0, 4);
			$Strt = 4;
		}

		if (substr ($CalledNt, 0, 2) =~ /^77|^78/) {
			$Membert = (substr ($CalledNt, 0, 2));
			$Strtt = 2;
		}

		else {
			$Membert = substr ($CalledNt, 0, 4);
			$Strtt = 4;
		}

	
		if ($RemoteAddresst =~ /204\.14\.210\.73|69\.1\.239\.229|204\.13\.12\.173|208\.87\.168\.65|208\.87\.169\.120|208\.87\.169\.100|208\.87\.170\.99/){ #WPC
			$Membert = "3166";
			$Strtt = 0;
		}
		elsif ($RemoteAddresst =~ /213\.132\.227\.2/){ #???
			$Membert = "6322";
			$Strtt = 0;
		}
		elsif ($RemoteAddresst =~ /80\.239\.172\.249|80\.239\.172\.184|80\.239\.172\.191|80\.239\.172\.144|80\.239\.172\.145|80\.239\.172\.148|65\.223\.208\.5/){ #xplorium
			$Membert = "0";
			$Strtt = 0;
		}
		elsif ($RemoteAddresst =~ /80\.85\.65\.205|87\.236\.144\.9|87\.236\.144\.39|87\.236\.144\.38/){ #Splendor
			$Membert = "8377";
			$Strtt = 0;
		}
		elsif ($RemoteAddresst =~ /206\.131\.227\.2|206\.131\.227\.19|63\.218\.111\.238|89\.249\.209\.73|89\.249\.210\.227|69\.48\.141\.136/) { #sip to sip
			$Membert = "890";
			$Strtt = 0;
			$CallTypet="V";
		}
		elsif ($RemoteAddresst =~ /66\.241\.7\.200|66\.241\.7\.201|199\.73\.53\.210|206\.169\.15\.228|64\.94\.105\.140|75\.98\.35\.140/) { #Vinculum
			$Membert = "8583";
			$Strtt = 0;
			
		}
		elsif ($RemoteAddresst =~ /202\.125\.146\.1/){ #PTCL
			$Membert = "8548";
			$Strtt = 3;
		}
		elsif ($RemoteAddresst =~ /69\.44\.146\.28/){ #Next
			$Membert = "8548";
			$Strtt = 5;
		}
		elsif ($RemoteAddresst =~ /213\.248\.105\.21|213\.248\.105\.29/) { #Teliasonera
			$Membert = "8583";
			$Strtt = 0;
		}
		elsif ($RemoteAddresst =~ /196\.219\.52\.|217\.194\.136\.|64\.110\.64\.|87\.228\.197\.|213\.144\.186\.99/) { #To STE Gateway
			$GWipt=$RemoteAddresst;
			$CallTypet = "Telephony";
			$v_tt = "t";
		}
		elsif ($RemoteAddresst =~ /81\.52\.176\.101|81\.52\.176\.133|81\.52\.176\.165|90\.84\.132\.1|90\.84\.132\.7|90\.84\.132\.129|90\.84\.132\.135/) { #Francetelecom
			$Membert = "8586";
			$Strtt = 0;
			
		}
		elsif ($RemoteAddresst =~ /176\.241\.186\.164|176\.241\.186\.165|176\.241\.186\.166|176\.241\.186\.167|176\.241\.186\.168|176\.241\.186\.169|176\.241\.186\.170|176\.241\.186\.171|176\.241\.186\.172|176\.241\.186\.173|176\.241\.186\.174|176\.241\.186\.175|176\.241\.186\.176|176\.241\.186\.177|176\.241\.186\.178|212\.102\.3\.19|212\.102\.3\.3|212\.102\.3\.4|212\.102\.3\.5|212\.102\.3\.6|212\.102\.3\.7|176\.241\.189\.132|176\.241\.189\.119|212\.102\.3\.20|212\.102\.3\.21|212\.102\.3\.22|82\.118\.170\.18|82\.118\.170\.19|82\.118\.170\.20|82\.118\.170\.21|82\.118\.170\.22|82\.118\.170\.23|82\.118\.170\.59|82\.118\.170\.60|82\.118\.170\.61|82\.118\.170\.70|82\.118\.170\.71/) { #MAJE
			$Membert = "8586";
			$Strtt = 0;
			
		}
		elsif ($RemoteAddresst =~ /176\.241\.186\.133|176\.241\.186\.134|176\.241\.186\.135|176\.241\.186\.136|176\.241\.186\.137|176\.241\.186\.138|176\.241\.186\.139|176\.241\.186\.140|176\.241\.186\.146|176\.241\.186\.147|176\.241\.186\.148|176\.241\.186\.149|176\.241\.186\.150|176\.241\.186\.151|176\.241\.186\.152|176\.241\.186\.153|176\.241\.186\.154|176\.241\.186\.157|176\.241\.189\.82|176\.241\.189\.83|176\.241\.189\.84|176\.241\.189\.85|176\.241\.189\.86|176\.241\.189\.87|176\.241\.189\.88|176\.241\.189\.89|176\.241\.189\.90|176\.241\.189\.91|176\.241\.189\.122|176\.241\.189\.123|176\.241\.189\.124|176\.241\.189\.125|176\.241\.189\.126|176\.241\.189\.120|176\.241\.189\.121|176\.241\.189\.130|176\.241\.189\.131/) { #MAJE2
			$Membert = "8586";
			$Strtt = 0;
			
		}
		elsif ($RemoteAddresst =~ /84\.246\.112\.33|84\.246\.112\.45/) { #Lebara
			$Membert = "8583";
			$Strtt = 0;
			
		}
		elsif ($RemoteAddresst =~ /217\.173\.53\.68|195\.14\.141\.196/) { #unlimited business and cyta
			$Membert = "8583";
			$Strtt = 0;
			
		}
	
		elsif ($RemoteAddresst =~ /62\.190\.10\.85|62\.190\.10\.86/) { #verizon
			$Membert = "8583";
			$Strtt = 0;
			
		}

		elsif ($RemoteAddresst =~ /46\.255\.56\.3|46\.184\.255\.150|46\.184\.255\.151/) { #Teo Muscat and VIVA bahrain
			$Membert = "8583";
			$Strtt = 0;
			
		}

		elsif ($RemoteAddresst =~ /31\.25\.192\.133|31\.25\.192\.69/) { #ManorIT
			$Membert = "8583";
			$Strtt = 6;
			
		}

		elsif ($RemoteAddresst =~ /104\.152\.200\.126|104\.152\.200\.19|104\.152\.200\.212|104\.152\.202\.240|104\.152\.202\.247|200\.0\.90\.33|200\.0\.90\.72|200\.0\.92\.102|200\.0\.92\.119|200\.57\.142\.120/) { #IPBTEL
			$Membert = "8583";
			$Strtt = 5;
			
		}



		if ($RemoteAddress =~ /104\.152\.200\.126|104\.152\.200\.19|104\.152\.200\.212|104\.152\.202\.240|104\.152\.202\.247|200\.0\.90\.33|200\.0\.90\.72|200\.0\.92\.102|200\.0\.92\.119|200\.57\.142\.120/) { #IPBtel
			$Member = "8583";
			$Strt = 5;
			
		}
		elsif ($RemoteAddress =~ /31\.25\.192\.133|31\.25\.192\.69/) { #ManorIt
			$Member = "8583";
			$Strt = 6;
		}
		elsif ($RemoteAddress =~ /46\.255\.56\.3|46\.184\.255\.150|46\.184\.255\.151/) { #Teo Muscat and VIVA bahrain
			$Member = "8583";
			$Strt = 0;
			
		}

		elsif ($RemoteAddress =~ /62\.190\.10\.85|62\.190\.10\.86/) { #verizon
			$Member = "8583";
			$Strt = 0;
			
		}

		elsif ($RemoteAddress =~ /217\.173\.53\.68|195\.14\.141\.196/) { #unlimited business and cyta
			$Member = "8583";
			$Strt = 0;
			
		}
		elsif ($RemoteAddress =~ /84\.246\.112\.33|84\.246\.112\.45/) { #Lebara
			$Member = "8583";
			$Strt = 2;
			
		}
		elsif ($RemoteAddress =~ /81\.52\.176\.101|81\.52\.176\.133|81\.52\.176\.165|90\.84\.132\.1|90\.84\.132\.7|90\.84\.132\.129|90\.84\.132\.135/) { #Francetelecom
			$Member = "8586";
			$Strt = 0;
			
		}
		elsif ($RemoteAddress =~ /213\.248\.105\.21|213\.248\.105\.29/) { #Teliasonera
			$Member = "8583";
			$Strt = 0;
			
		}

		elsif ($RemoteAddress =~ /208\.79\.180\.33|208\.79\.180\.35|208\.79\.180\.37|208\.79\.180\.39|208\.79\.180\.41|208\.79\.180\.43|208\.79\.180\.45|199\.15\.76\.10|199\.15\.76\.12|199\.15\.76\.14|70\.42\.46\.4|70\.42\.46\.10|70\.42\.46\.35|70\.42\.46\.48|70\.42\.46\.8|70\.42\.46\.11|201\.168\.65\.182/){ #STI
			$Member = "8547";
			$Strt = 5;
		}

		elsif ($RemoteAddress =~ /196\.219\.52\.|217\.194\.136\.|64\.110\.64\.|87\.228\.197\.|213\.144\.186\.99/) { #From STE gateway
			$GWip=$RemoteAddress;
			$CallType = "Telephony";
			$v_t = "t";
		}
		elsif ($RemoteAddress =~ /212\.227\.134\.18|5\.153\.54\.244/) { #ITEST 
			$Member = "8583";
			$Strt = 7;
			
		}


		if ($Member =~ /2173|8173/) {   #arbinet 
			if (substr ($CalledN, 4, 1) ne "1") {
				$Strt = 7;
			}
		}

		if ($Membert =~ /2173|8173/) {   #arbinet 
			if (substr ($CalledNt, 4, 1) ne "1") {
				$Strtt = 7;
			}
		}
		
		if ($RemoteAddress =~ /4\.79\.201\.111|4\.79\.201\.100|4\.53\.178\.90|4\.53\.178\.91|4\.31\.54\.40|4\.31\.54\.41|4\.31\.54\.48|4\.31\.54\.49|4\.53\.178\.89|4\.53\.178\.74|4\.53\.178\.75|4\.31\.54\.42|208\.64\.253\.140|208\.64\.253\.141|208\.64\.253\.142|208\.64\.253\.148|208\.64\.253\.149/){ #voicestep: normal to Sip with american number call
			$Member = "890";
			$CallType="R";
			$ConfIDtemp=$ConfIDt;
			if (!($RemoteAddresst =~ /206\.131\.227\.2|206\.131\.227\.19|63\.218\.111\.238|89\.249\.209\.73|89\.249\.210\.227|69\.48\.141\.136/)) { #call forwarding
				
				#caclulate the regionid and country for the number where we forwarded the call
				$RegionID = substr ($CalledNt, $Strtt, 8);
				($regionidprim,$CountryCode)=calcregidprim ($RegionID);
						
				
				
				#add entries one for the sip owner to bill for the call forwarded and the normal entry for the termination 
				

			}
			#add one entry as vendor for voicestep and another entry as customer for the called sip 
			#change the confid to avoid prob in the inout table : remove the first character and replace it with R
			$ConfID=$ConfIDtemp."R";
			$ConfIDt=$ConfID; 
		
			$RemoteAddresst=$RemoteAddress;
			$RemoteAddress=$CalledN;
			#add 899 to the called number for the regions and rates calculations
			$CalledN="899".$CalledN;
			$CalledNt=$CalledN;
			$CalledIDt=$CalledID;
			$Strt = 0;
		}
		
		
		if ($RemoteAddress =~ /206\.131\.227\.2|206\.131\.227\.19|63\.218\.111\.238|89\.249\.210\.227|69\.48\.141\.136/){ #retail
			$Member = "890";
			if ($RemoteAddresst =~ /206\.131\.227\.2|206\.131\.227\.19|63\.218\.111\.238|89\.249\.210\.227|69\.48\.141\.136/){  #sip to sip without forwarding
				$Strt = 0;
				unless ($CalledN =~ /^899/) { #sip 899 but with three digists as prefix or sip with american number remove three digIts as prefix used to call then the 1 for america
					$CalledN=substr($CalledN,3);
					unless ($CalledN =~ /^899/)	{	
						$CalledN="899".substr($CalledN,1); #sip with american number remove the 1 and add 899
					}
					
				} 
			}
			else {
				$RemoteAddress=$CallingNumb;
				$CallType="R";
				$Strt = 3;
				
				if (substr($CalledN,3) =~ /^1/ ) { #if the called number is american check if it is one of our sip numbers
					$member_number=	substr($CalledN,4);
					$find_m=0;				
					for ($i_m=0; $i_m < @members_data; $i_m++) {
						if ($members_data[$i_m] eq $member_number) {
					 		$find_m=1;
	  			 			last;
	  					}
					}
					
					if ($find_m==1) { #sip to sip with forwarded call we have to bill the owner of the sip for the forwarded leg
						$RemoteAddress=$member_number;
						$CalledN=$CalledNt;
						$Strt =$Strtt;
					}
				}
			}
		}
	

	if  (($RemoteAddress =~ /209\.51\.180\.142|209\.51\.180\.147|209\.51\.180\.150/) && (substr ($CalledID, 0, 4) =~ /^9898/) ) { #retail standard
			$RemoteAddress = $RemoteAddress."S";
		}

	$RegionID = substr ($CalledN, $Strt, 8);
	$RegionIDt = $RegionID;
	($regionidprim,$CountryCode)=calcregidprim ($RegionID);
	$CountryCodet = $CountryCode;
	$regionidprimt = $regionidprim;
	
	#introduced to solve the problem of long called id sent by p-group:they were sending two callednumbers
	if (length($CalledID) >30 ) {

		$CalledID=substr($CalledID,0,29);
		$RxdCalledNumb=substr($RxdCalledNumb,0,29);
		

	}
	if (length($CalledIDt) >30 ) {

		$CalledIDt=substr($CalledIDt,0,29);
		$RxdCalledNumbt=substr($RxdCalledNumbt,0,29);
		$FinalCalledNumbt=substr($FinalCalledNumbt,0,29);

	}

	if (length($CallingID) >30 ) {

		$CallingID=substr($CallingID,0,29);
		$RxdCallingNumb=substr($RxdCallingNumb,0,29);
		$Username=substr($Username,0,29);
		

	}
	if (length($CallingIDt) >30 ) {

		$CallingIDt=substr($CallingIDt,0,29);
		$RxdCallingNumbt=substr($RxdCallingNumbt,0,29);
		$FinalCallingNumbt=substr($FinalCallingNumbt,0,29);
		$Usernamet=substr($Usernamet,0,29);

	}
	print OUTFILEIN join (',', ($SetupDate, $SetupTime, $SetupTime2, $ConnectTime, $DisconnectTime, $CallingID, $CalledID, $Member, $CountryCode, $RegionID, $regionidprim, $ConfID, $CallOrigin, $CallType, $GWip, $RxdCalledNumb, $RxdCallingNumb, $RemoteAddress, $RemoteMedAddress, $Username, $NAStrunk, $NASd, $SessionTime, $DisconnectCause, $OutPackets, $InPackets, $OutOctets, $InOctets, $v_t."\n"));
		if (($RemoteAddresst ne 'NA') && ($RemoteAddresst !~ /10\.10\.10\./)){
	 		print OUTFILEOUT join (',', ($SetupDatet, $SetupTimet, $SetupTime2t, $ConnectTimet, $DisconnectTimet, $CallingIDt, $CalledIDt, $Membert, $CountryCodet, $RegionIDt, $regionidprimt, $ConfIDt, $CallOrigint, $CallTypet, $GWipt, $RxdCalledNumbt, $RxdCallingNumbt, $FinalCalledNumbt, $FinalCallingNumbt, $RemoteAddresst, $RemoteMedAddresst, $Usernamet, $NAStrunkt, $NASdt, $SessionTimet, $DisconnectCauset, $OutPacketst, $InPacketst, $OutOctetst, $InOctetst, $v_tt."\n"));
		}

	($SetupDate, $SetupTime, $SetupTime2, $ConnectTime, $DisconnectTime, $CallingID, $CalledID, $Member, $CountryCode, $RegionID, $ConfID, $CallOrigin, $CallType, $GWip, $RxdCalledNumb, $RxdCallingNumb, $FinalCalledNumb, $FinalCallingNumb, $RemoteAddress, $RemoteMedAddress, $Username, $NAStrunk, $NASd, $SessionTime, $DisconnectCause, $OutPackets, $InPackets, $OutOctets, $InOctets,$regionidprim,$v_t) = ("","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","");
	($SetupDatet, $SetupTimet, $SetupTime2t, $ConnectTimet, $DisconnectTimet, $CallingIDt, $CalledIDt, $Membert, $CountryCodet, $RegionIDt, $ConfIDt, $CallOrigint, $CallTypet, $GWipt, $RxdCalledNumbt, $RxdCallingNumbt, $FinalCalledNumbt, $FinalCallingNumbt, $RemoteAddresst, $RemoteMedAddresst, $Usernamet, $NAStrunkt, $NASdt, $SessionTimet, $DisconnectCauset, $OutPacketst, $InPacketst, $OutOctetst, $InOctetst,$regionidprimt,$v_tt) = ("","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","");

}
close INFILE;
$newradiusname="$switchcount-$radiuslog";
move($radiuslog,$newradiusname);
$switchcount=$switchcount +1 ;
$ftp->quit;
}
close OUTFILEIN;
close OUTFILEOUT;



($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time) ; 

$timestamp = "$Hour:$Minute:$Second";
$timestamp2 = "$Hour$Minute$Second";
#print OUTFILELOG "end radius processing ($line_no): $timestamp \n";
#print OUTFILELOG "$timestamp,$line_no,";

#truncate tables
$truncatetables ="truncate table tempaccounting_in
truncate table tempaccounting_inimport
truncate table tempaccounting_out
truncate table tempaccounting_outimport
truncate table tempaccounting_inimt
truncate table tempaccounting_outimt
truncate table RegionTemp
truncate table RadiusData
truncate table RadiusRegion
truncate table monitorin_table
truncate table monitorout_table";

$sth = $dbh->prepare($truncatetables); 
$sth->execute or die "couldn't execute statement" .$sth->errstr;

#bulk insert
 
$bulkinsert="BULK INSERT [dbo].[tempaccounting_inimport]
   FROM '$abs_path$radiusincsvfile'
   WITH 
      (
         FIELDTERMINATOR = ',',
         ROWTERMINATOR = '\\n'
      )

BULK INSERT [dbo].[tempaccounting_outimport]
   FROM '$abs_path$radiusoutcsvfile'
   WITH 
      (
         FIELDTERMINATOR = ',',
         ROWTERMINATOR = '\\n'
      )
";


$sth = $dbh->prepare($bulkinsert); 
$sth->execute or die "couldn't execute statement" .$sth->errstr;

($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time) ; 

$timestamp = "$Hour:$Minute:$Second";
#print OUTFILELOG "end bulkinsert: $timestamp \n";
print OUTFILELOG "$timestamp,";

#Data Append

$dataappend="insert into tempaccounting_in select \* from tempaccounting_inimport
insert into tempaccounting_out select \* from tempaccounting_outimport
insert into monitorin_table select * from monitorin_view
insert into monitorout_table select * from monitorout_view
INSERT INTO RadiusDestinationsFinal (country, name, nickname, gateway) SELECT DISTINCT a.CountryCode, a.Name, left(a.Name,3)+' Out' as Nickname, a.GWNickname FROM RadiusDestinationsFinal RIGHT OUTER JOIN monitorin_countrysub a ON RadiusDestinationsFinal.gateway = a.GWNickname AND RadiusDestinationsFinal.name = a.Name AND RadiusDestinationsFinal.country = a.CountryCode WHERE (RadiusDestinationsFinal.country IS NULL) AND (RadiusDestinationsFinal.name IS NULL) AND (RadiusDestinationsFinal.gateway IS NULL) and (a.Name IS NOT NULL) and (a.CountryCode IS NOT NULL) and (a.GWNickname IS NOT NULL) and (a.name not like 'IMT%') 
INSERT INTO RadiusDestinationsFinal (country, name, nickname, gateway) SELECT DISTINCT a.CountryCode, a.Name, left(a.Name,3)+' In' as Nickname, a.GWNickname FROM RadiusDestinationsFinal RIGHT OUTER JOIN monitorout_countrysub a ON RadiusDestinationsFinal.gateway = a.GWNickname AND RadiusDestinationsFinal.name = a.Name AND RadiusDestinationsFinal.country = a.CountryCode WHERE (RadiusDestinationsFinal.country IS NULL) AND (RadiusDestinationsFinal.name IS NULL) AND (RadiusDestinationsFinal.gateway IS NULL) and (a.Name IS NOT NULL) and (a.CountryCode IS NOT NULL) and (a.GWNickname IS NOT NULL) and (a.name not like 'IMT%') 
INSERT INTO RadiusDestinationsFinal (country, name, nickname, gateway) SELECT DISTINCT a.CountryCode, a.Name, left(a.Name,3)+' Out' as Nickname, a.GWNickname FROM RadiusDestinationsFinal RIGHT OUTER JOIN monitorin_clientsub a ON RadiusDestinationsFinal.gateway = a.GWNickname AND RadiusDestinationsFinal.name = a.Name AND RadiusDestinationsFinal.country = a.CountryCode WHERE (RadiusDestinationsFinal.country IS NULL) AND (RadiusDestinationsFinal.name IS NULL) AND (RadiusDestinationsFinal.gateway IS NULL) and (a.Name IS NOT NULL) and (a.CountryCode IS NOT NULL) and (a.GWNickname IS NOT NULL) and (a.name not like 'IMT%')
INSERT INTO RadiusDestinationsFinal (country, name, nickname, gateway) SELECT DISTINCT a.CountryCode, a.Name, left(a.Name,3)+' In' as Nickname, a.GWNickname FROM RadiusDestinationsFinal RIGHT OUTER JOIN monitorout_clientsub a ON RadiusDestinationsFinal.gateway = a.GWNickname AND RadiusDestinationsFinal.name = a.Name AND RadiusDestinationsFinal.country = a.CountryCode WHERE (RadiusDestinationsFinal.country IS NULL) AND (RadiusDestinationsFinal.name IS NULL) AND (RadiusDestinationsFinal.gateway IS NULL) and (a.Name IS NOT NULL) and (a.CountryCode IS NOT NULL) and (a.GWNickname IS NOT NULL) and (a.name not like 'IMT%')
INSERT INTO RadiusDestinationsFinal (country, name, nickname, gateway) SELECT DISTINCT a.CountryCode, a.Name, left(a.Name,3)+' Out' as Nickname, a.GWNickname FROM RadiusDestinationsFinal RIGHT OUTER JOIN monitorin_gwsub a ON RadiusDestinationsFinal.gateway = a.GWNickname AND RadiusDestinationsFinal.name = a.Name AND RadiusDestinationsFinal.country = a.CountryCode WHERE (RadiusDestinationsFinal.country IS NULL) AND (RadiusDestinationsFinal.name IS NULL) AND (RadiusDestinationsFinal.gateway IS NULL) and (a.Name IS NOT NULL) and (a.CountryCode IS NOT NULL) and (a.GWNickname IS NOT NULL) and (a.name not like 'IMT%') 
INSERT INTO RadiusDestinationsFinal (country, name, nickname, gateway) SELECT DISTINCT a.CountryCode, a.Name, left(a.Name,3)+' In' as Nickname, a.GWNickname FROM RadiusDestinationsFinal RIGHT OUTER JOIN monitorout_gwsub a ON RadiusDestinationsFinal.gateway = a.GWNickname AND RadiusDestinationsFinal.name = a.Name AND RadiusDestinationsFinal.country = a.CountryCode WHERE (RadiusDestinationsFinal.country IS NULL) AND (RadiusDestinationsFinal.name IS NULL) AND (RadiusDestinationsFinal.gateway IS NULL) and (a.Name IS NOT NULL) and (a.CountryCode IS NOT NULL) and (a.GWNickname IS NOT NULL) and (a.name not like 'IMT%') 
insert into radiusdata SELECT PrimaryKey, Name, Country, gateway, Seizures, Completed, ASR, ASRm, ACD, Minutes, BilledMin, TQI, AnsDel, AdjAnsDel, NormalD, FailureD, NoCircD, NoReqCircD, tCh, kOctetsXmt, kOctetsRec, MaxTime, Failed, NormalDisc, FailureDisc, NoCircDisc, NoReqCircDisc, ASRmSeiz, Rounded, GWip, CallType, AccountGroup, FSR, FSRSeiz, radiusdataarchivemaxid.MaxOfImport_Id + 1 AS import_id FROM monitorin_Country CROSS JOIN radiusdataarchivemaxid						
insert into radiusdata SELECT PrimaryKey, Name, Country, gateway, Seizures, Completed, ASR, ASRm, ACD, Minutes, BilledMin, TQI, AnsDel, AdjAnsDel, NormalD, FailureD, NoCircD, NoReqCircD, tCh, kOctetsXmt, kOctetsRec, MaxTime, Failed, NormalDisc, FailureDisc, NoCircDisc, NoReqCircDisc, ASRmSeiz, Rounded, GWip, CallType, AccountGroup, FSR, FSRSeiz, radiusdataarchivemaxid.MaxOfImport_Id + 1 AS import_id FROM monitorout_Country CROSS JOIN radiusdataarchivemaxid
insert into radiusdata SELECT PrimaryKey, Name, Country, gateway, Seizures, Completed, ASR, ASRm, ACD, Minutes, BilledMin, TQI, AnsDel, AdjAnsDel, NormalD, FailureD, NoCircD, NoReqCircD, tCh, kOctetsXmt, kOctetsRec, MaxTime, Failed, NormalDisc, FailureDisc, NoCircDisc, NoReqCircDisc, ASRmSeiz, Rounded, GWip, CallType, AccountGroup, FSR, FSRSeiz, radiusdataarchivemaxid.MaxOfImport_Id + 1 AS import_id FROM monitorin_gw CROSS JOIN radiusdataarchivemaxid
insert into radiusdata SELECT PrimaryKey, Name, Country, gateway, Seizures, Completed, ASR, ASRm, ACD, Minutes, BilledMin, TQI, AnsDel, AdjAnsDel, NormalD, FailureD, NoCircD, NoReqCircD, tCh, kOctetsXmt, kOctetsRec, MaxTime, Failed, NormalDisc, FailureDisc, NoCircDisc, NoReqCircDisc, ASRmSeiz, Rounded, GWip, CallType, AccountGroup, FSR, FSRSeiz, radiusdataarchivemaxid.MaxOfImport_Id + 1 AS import_id FROM monitorout_gw CROSS JOIN radiusdataarchivemaxid
insert into radiusdata SELECT PrimaryKey, Name, Country, gateway, Seizures, Completed, ASR, ASRm, ACD, Minutes, BilledMin, TQI, AnsDel, AdjAnsDel, NormalD, FailureD, NoCircD, NoReqCircD, tCh, kOctetsXmt, kOctetsRec, MaxTime, Failed, NormalDisc, FailureDisc, NoCircDisc, NoReqCircDisc, ASRmSeiz, Rounded, GWip, CallType, AccountGroup, FSR, FSRSeiz, radiusdataarchivemaxid.MaxOfImport_Id + 1 AS import_id FROM monitorin_totals CROSS JOIN radiusdataarchivemaxid
insert into radiusdata SELECT PrimaryKey, Name, Country, gateway, Seizures, Completed, ASR, ASRm, ACD, Minutes, BilledMin, TQI, AnsDel, AdjAnsDel, NormalD, FailureD, NoCircD, NoReqCircD, tCh, kOctetsXmt, kOctetsRec, MaxTime, Failed, NormalDisc, FailureDisc, NoCircDisc, NoReqCircDisc, ASRmSeiz, Rounded, GWip, CallType, AccountGroup, FSR, FSRSeiz, radiusdataarchivemaxid.MaxOfImport_Id + 1 AS import_id FROM monitorin_client CROSS JOIN radiusdataarchivemaxid
insert into radiusdata SELECT PrimaryKey, Name, Country, gateway, Seizures, Completed, ASR, ASRm, ACD, Minutes, BilledMin, TQI, AnsDel, AdjAnsDel, NormalD, FailureD, NoCircD, NoReqCircD, tCh, kOctetsXmt, kOctetsRec, MaxTime, Failed, NormalDisc, FailureDisc, NoCircDisc, NoReqCircDisc, ASRmSeiz, Rounded, GWip, CallType, AccountGroup, FSR, FSRSeiz, radiusdataarchivemaxid.MaxOfImport_Id + 1 AS import_id FROM monitorout_client CROSS JOIN radiusdataarchivemaxid
Execute RadiusRegionAppend
Execute tempAccountingArchiveAppend";

$sth = $dbh->prepare($dataappend); 
$sth->execute or die "couldn't execute statement" .$sth->errstr;

($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time) ; 

$timestamp = "$Hour:$Minute:$Second";
#print OUTFILELOG "end data append : $timestamp \n";
print OUTFILELOG "$timestamp,";

#DataExport- newdestnationspl part 

$MrtgBatch = 'c:\MrtgBatch.bat';
open ( MRTGBATCH, ">$MrtgBatch");

$MrtgBatchnewdest = 'c:\MrtgBatchnewdest.bat';
open ( MRTGBATCHNEWDEST, ">$MrtgBatchnewdest");
print MRTGBATCHNEWDEST "\@echo off\n";
print MRTGBATCHNEWDEST "cd c:\\mrtg-2\.10\.13\\bin\n";
 
print MRTGBATCH "cd c:\\rrdtool\\src\\tool_release\n";



$NewDest = 0;
$BlankLine = 0;
$indexgw = 'c:\imc tel inc\monitor\Radius\IndexGW.txt';
$indexactive = 'c:\imc tel inc\monitor\Radius\IndexActive.txt';
$indexinactive = 'c:\imc tel inc\monitor\Radius\IndexInactive.txt';
$index24 = 'c:\imc tel inc\monitor\Radius\Index24Hours.txt';
$mrtgIndexList = 'c:\imc tel inc\monitor\Radius\mrtgIndexList.txt';
$mrtgIndexActiveList = 'c:\imc tel inc\monitor\Radius\mrtgIndexActiveList.txt';

open( INDGW, ">$indexgw") or die "Can't open $indexgw.\n";
open( INDACTIVE, ">$indexactive") or die "Can't open $indexactive.\n";
open( INDINACTIVE, ">$indexinactive") or die "Can't open $indexinactive.\n";
open( IND24, ">$index24") or die "Can't open $index24.\n";
open( INDEXLIST, ">$mrtgIndexList") or die "Can't open $mrtgIndexList.\n";
open( INDEXACTIVELIST, ">$mrtgIndexActiveList") or die "Can't open $mrtgIndexActiveList.\n";

$RadiusDataFinal="SELECT CASE WHEN [Seiz5] IS NULL THEN 0 ELSE [Seiz5] END ,CASE WHEN [Seiz1440] IS NULL THEN 0 ELSE [Seiz1440] END,[PrimaryKey],[name],[Country],[gateway],[Seizures],CASE WHEN [completed] IS NULL THEN 0 ELSE [completed] END,[ASR],[ASRm],[ACD],CASE WHEN [Minutes] IS NULL THEN 0 ELSE [Minutes] END,[BilledMin],CASE WHEN [AnsDel] IS NULL THEN 0 ELSE [AnsDel] END,CASE WHEN [AdjAnsDel] IS NULL THEN 0 ELSE [AdjAnsDel] END,CASE WHEN [NormalD] IS NULL THEN 0 ELSE [NormalD] END,CASE WHEN [FailureD] IS NULL THEN 0 ELSE [FailureD] END,CASE WHEN [NoCircD] IS NULL THEN 0 ELSE [NoCircD] END,CASE WHEN [tCh] IS NULL THEN 0 ELSE [tCh] END,[MaxTime],[Failed], replace([GWip],' ', ''),[CallType],[AccountGroup],CASE WHEN [FSR] IS NULL THEN 0 ELSE [FSR] END,[InOut],[Active],[3daySeiz]
FROM [dbo]\.[RadiusDataFinal] ORDER BY CASE WHEN [name] like 'GW%' THEN 'a' ELSE 'b' END,CASE WHEN Country = 'Total' THEN 'a' ELSE 'b' END, Country, CASE WHEN [name]like 'GW%' THEN gateway END, CASE WHEN RIGHT([Name], 3) LIKE '%In%' THEN 'Out' ELSE 'IN' END, [name], CASE WHEN Seiz5 > 0 THEN 'a' ELSE 'b' END, CASE WHEN Seiz1440 > 0 THEN 'a' ELSE 'b' END, gwip";

$sth = $dbh->prepare($RadiusDataFinal); 
$sth->execute or die "couldn't execute statement" .$sth->errstr;

$Active_counter = 0;

while (@row = $sth->fetchrow_array){

	($Seiz5, $Seiz1440, $PrimaryKey, $FullName, $Country, $GW, $Seizures, $Completed, $ASR, $ASRm, $ACD, $Minutes, $BilledMin, $AnsDel, $AdjAnsDel, $NormalD, $FailureD, $NoCircD, $tCh, $MaxTime, $Failed, $Gateway, $CallType, $Name, $FSR, $InOut, $Active, $Seiz3Day) = @row;
	#@NotUsed = ($CallType, $Failed, $BilledMin, $MaxTime);
	#print @NotUsed;
	
	#chop($Active);

	if ($InOut eq "IN"){
		$InOut = "Out";
	}
	else { 
		$InOut = "In";
	}

	$seizuresleft=ceil($Seizures/5);
	@RawVar = ($seizuresleft, $tCh, $Minutes, $ACD, $ASR, $ASRm);                                                                                                                                                                                                     	

	$Seizures /= 5 unless ($Seizures eq "");
	$Minutes /= 5 unless ($Minutes eq ""); 
	$Completed /= 5 ;
	$tCh /= 5 ;
	$CountryShort = $Country;
	$CountryShort =~ s/ //g;
	$GWShort = $GW;
	$GWShort =~ s/\.//g;
	$GWShort =~ s/\ //g;
	#$PrimaryKey =~ s/295/999/;

	if ($Seizures eq ""){
	($Seizures, $Minutes, $Completed) = (0,0,0);
	}

	#print "$Seizures $Name $Country\n";
	
	if ($Completed == 0 && $Seizures > 0){
	($ASR, $Minutes, $ASRm, $ACD) = (0,0,0,0);
	}
	
	if ($Seizures == 0 && $Seiz5 > 0){
	($ASR, $Minutes, $ASRm, $ACD) = (0,0,0,0);
	}
		
	$mrtgDir = "c:\\mrtg-2\.10\.13\\bin\\";
	#$mrtgDir = "c:\\imc tel inc\\monitor\\radius\\bin\\";
	$mrtgCFG = $mrtgDir."$Name-$CountryShort-$GWShort-$PrimaryKey\.cfg";
	

	if ($Seizures > 0 || $Seiz5 > 0){
		#CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "asr", $ASR, $ASRm);
		#print MRTGBATCH "rrdtool update c:\\Inetpub\\wwwroot\\mrtgfiles\\TrafficData-Gif-Log\\$Name\\$Name-$CountryShort-$GWShort-$PrimaryKey-asr\.rrd N:$ASR:$ASRm \n";
		RRDs::update ("c:\\Inetpub\\wwwroot\\mrtgfiles\\TrafficData-Gif-Log\\$Name\\$Name-$CountryShort-$GWShort-$PrimaryKey-asr\.rrd","N:$ASR:$ASRm");
		RRDs::update ("c:\\Inetpub\\wwwroot\\mrtgfiles\\TrafficData-Gif-Log\\$Name\\$Name-$CountryShort-$GWShort-$PrimaryKey-acd\.rrd","N:$ACD:0");
		RRDs::update ("c:\\Inetpub\\wwwroot\\mrtgfiles\\TrafficData-Gif-Log\\$Name\\$Name-$CountryShort-$GWShort-$PrimaryKey-seizures\.rrd","N:$Completed:$Seizures");
		RRDs::update ("c:\\Inetpub\\wwwroot\\mrtgfiles\\TrafficData-Gif-Log\\$Name\\$Name-$CountryShort-$GWShort-$PrimaryKey-minutesCh\.rrd","N:$Minutes:$tCh");
		RRDs::update ("c:\\Inetpub\\wwwroot\\mrtgfiles\\TrafficData-Gif-Log\\$Name\\$Name-$CountryShort-$GWShort-$PrimaryKey-ansdel\.rrd","N:$AnsDel:$AdjAnsDel");
		RRDs::update ("c:\\Inetpub\\wwwroot\\mrtgfiles\\TrafficData-Gif-Log\\$Name\\$Name-$CountryShort-$GWShort-$PrimaryKey-normald\.rrd","N:$NormalD:$FailureD");
		RRDs::update ("c:\\Inetpub\\wwwroot\\mrtgfiles\\TrafficData-Gif-Log\\$Name\\$Name-$CountryShort-$GWShort-$PrimaryKey-nocircd\.rrd","N:$NoCircD:$FSR");

		print MRTGBATCH "copy /Y c:\\Inetpub\\wwwroot\\mrtgfiles\\TrafficData-Gif-Log\\$Name\\$Name-$CountryShort-$GWShort-$PrimaryKey-minutesCh\.rrd \"c:\\Inetpub\\wwwroot\\mrtgfiles\\TrafficData-Gif-Log\\$Name $InOut\\\"\n";
			unless (-d "c:\\Inetpub\\wwwroot\\TrafficData\\$CountryShort\\"){
			print MRTGBATCHNEWDEST "MKDIR \"c:\\Inetpub\\wwwroot\\mrtgfiles\\TrafficData-Gif-Log\\$CountryShort\\\"\n";
			print MRTGBATCHNEWDEST "MKDIR \"c:\\Inetpub\\wwwroot\\TrafficData\\$CountryShort\\\"\n";
			}
		print MRTGBATCH "copy /Y c:\\Inetpub\\wwwroot\\mrtgfiles\\TrafficData-Gif-Log\\$Name\\$Name-$CountryShort-$GWShort-$PrimaryKey-minutesCh\.rrd \"c:\\Inetpub\\wwwroot\\mrtgfiles\\TrafficData-Gif-Log\\$CountryShort\\\"\n";
		$Active_counter++;
	}
	
	$CFGFile = "$Name-$CountryShort-$GWShort-$PrimaryKey\.cfg";
	$LogFile = "$Name-$CountryShort-$GWShort-$PrimaryKey\.log";

	$NickName = substr($Name, 0, 3).$InOut;
	$NickCountry = substr($CountryShort, 0, 8);
	$GW2 = substr($GWShort,length($GWShort)-2,2);
	#$Description = "$NickName-$NickCountry-$GWShort";

	if ($InOut eq "Out"){
		$BGCOLOR = "\"\#CCFFCC\"";
	}
	else{
		$BGCOLOR = "\"\#FFFFFF\"";
	}

	
	if ($Country eq "Total" && $Name eq "GW"){
		print INDGW "<tr><td><a href=\"cgi-bin/14all\.cgi?dir=$Name\\\&cfg=$CFGFile&periodtype=daily\"><span style=\'color:windowtext\;text-decoration:none\'>$FullName</a></td><td><a href=\"cgi-bin/14all\.cgi?dir=$Name\\\&cfg=$CFGFile&periodtype=daily\"><span style=\'color:windowtext\;text-decoration:none\;text-underline:none\'>$GWShort</a></td><td><b>$RawVar[0]</b></td>\n";
		
		if($Minutes < 0.5){
			print INDGW "<td></td><td></td>";
		}
		else{ 
			printf INDGW "<td>%d</td><td>%d</td>", $tCh, $Minutes;
		}
		
		if($ACD == 0){
			print INDGW "<td> </td>";
		}
		else{ 
			if($ACD < 1){
			$td1 = "<td style=\"color:red\">";
			}
			else {
			$td1 = "<td>";
			}

			printf INDGW "$td1%.1f</td>", $ACD;
		}

		if($ASR == 0){
			print INDGW "<td></td><td></td>\n";
		}
		else{
			if($ASRm < 15){
			$td1 = "<td style=\"color:red\">";
			$td2 = "<td style=\"color:red\">";
			}
			elsif ($ASR < 15){
			$td1 = "<td style=\"color:red\">";
			$td2 = "<td>";
			}
			else{
			$td1 = "<td>";
			$td2 = "<td>";
			}
 
			printf INDGW "$td1%d</td>$td2%d</td>\n", $ASR, $ASRm;
		}
		print INDGW "<td><a href=\"cgi-bin/14all\.cgi?dir=$Name+$InOut\\\&cfg=mrtg-index.cfg&periodtype=daily\">All</a></td><td><a href=\"cgi-bin/14all\.cgi?dir=$Name+$InOut\\\&cfg=mrtg-indexActive.cfg&periodtype=daily\">Act</a></td></tr>\n";
		unless (-e $mrtgCFG){
			CreateCfg($Name, $FullName, $CountryShort, $GWShort, $Gateway, $PrimaryKey) unless ($Name eq "");
			$NewDest = 1;
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "asr", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "acd", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "seizures", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "minutesCh", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "ansdel", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "normald", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "nocircd", 0, 0);
			print MRTGBATCHNEWDEST "perl mrtg --logging=$LogFile $CFGFile\n" ;
			print MRTGBATCHNEWDEST "MKDIR \"c:\\Inetpub\\wwwroot\\mrtgfiles\\TrafficData-Gif-Log\\$Name $InOut\"\n";
			print MRTGBATCHNEWDEST "MKDIR \"c:\\Inetpub\\wwwroot\\trafficdata\\$Name $InOut\"\n";

			}
		#print MRTGBATCH "perl mrtg --logging=$LogFile $CFGFile\n" ;
	}

	elsif ($Country eq "Total"){ # && ($Active eq "1" || $Seizures > 0)){

		if ($BlankLine == 0){
			print INDGW "<tr><td colspan=8>\&nbsp\;</td></tr>\n";
			$BlankLine=1;
		}
		if ($InOut eq "In" && $BlankLine == 1){
			print INDGW "<tr><td colspan=8>\&nbsp\;</td></tr>\n";
			$BlankLine=2;
		}
			
		print INDGW "<tr><td><a href=\"cgi-bin/14all\.cgi?dir=$Name\\\&cfg=$CFGFile&periodtype=daily\"><span style=\'color:windowtext\;text-decoration:none\;text-underline:none\'>$NickName</a></td><td><a href=\"cgi-bin/14all\.cgi?dir=$Name\\\&cfg=$CFGFile&periodtype=daily\"><span style=\'color:windowtext\;text-decoration:none\;text-underline:none\'>$GWShort</a></td><td><b>$RawVar[0]</b></td>\n";
	#	printf INDGW "<td>%d</td><td>%d</td><td>%d</td><td>%.1f</td><td>%d</td><td>%d</td></tr>\n", $RawVar[0], $tCh, $Minutes, $ACD, $ASR, $ASRm;

		if($Minutes < 0.5){
			print INDGW "<td></td><td></td>";
		}
		else{ 
			printf INDGW "<td>%d</td><td>%d</td>", $tCh, $Minutes;
		}
		
		if($ACD == 0){
			print INDGW "<td> </td>";
		}
		else{ 
			if($ACD < 1){
			$td1 = "<td style=\"color:red\">";
			}
			else {
			$td1 = "<td>";
			}

			printf INDGW "$td1%.1f</td>", $ACD;
		}

		if($ASR == 0){
			print INDGW "<td></td><td></td>\n";
		}
		else{
			if($ASRm < 15){
			$td1 = "<td style=\"color:red\">";
			$td2 = "<td style=\"color:red\">";
			}
			elsif ($ASR < 15){
			$td1 = "<td style=\"color:red\">";
			$td2 = "<td>";
			}
			else{
			$td1 = "<td>";
			$td2 = "<td>";
			}
 
			printf INDGW "$td1%d</td>$td2%d</td>\n", $ASR, $ASRm;
		}
		print INDGW "<td><a href=\"cgi-bin/14all\.cgi?dir=$Name+$InOut\\\&cfg=mrtg-index.cfg&periodtype=daily\">All</a></td><td><a href=\"cgi-bin/14all\.cgi?dir=$Name+$InOut\\\&cfg=mrtg-indexActive.cfg&periodtype=daily\">Act</a></td></tr>\n";

		unless (-e $mrtgCFG){
			CreateCfg($Name, $FullName, $CountryShort, $GWShort, $Gateway, $PrimaryKey) unless ($Name eq "");
			$NewDest = 1;
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "asr", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "acd", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "seizures", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "minutesCh", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "ansdel", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "normald", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "nocircd", 0, 0);
			print MRTGBATCHNEWDEST "perl mrtg --logging=$LogFile $CFGFile\n" ;

		}

	}		

	elsif ($Seizures > 0){
		#print INDACTIVE "<tr><td><a href=\"cgi-bin/14all\.cgi?dir=$Name\\\&cfg=$CFGFile\"><span style=\'color:windowtext\;text-decoration:none\;text-underline:none\'>$Description</a></td>";
		print INDACTIVE "<tr BGCOLOR=$BGCOLOR><td><a href=\"cgi-bin/14all\.cgi?dir=$Name\\\&cfg=$CFGFile&periodtype=daily\"><span style=\'color:windowtext\;text-decoration:none\;text-underline:none\'>$NickName</a></td><td><a href=\"cgi-bin/14all\.cgi?dir=$Name\\\&cfg=$CFGFile&periodtype=daily\"><span style=\'color:windowtext\;text-decoration:none\;text-underline:none\'>$NickCountry</a></td><td><a href=\"cgi-bin/14all\.cgi?dir=$Name\\\&cfg=$CFGFile&periodtype=daily\"><span style=\'color:windowtext\;text-decoration:none\;text-underline:none\'>$GW2</a></td><td><b>$RawVar[0]</b></td>";
		
		if($Minutes < 0.5){
			print INDACTIVE "<td></td><td></td>";
		}
		else{ 
			printf INDACTIVE "<td>%d</td><td>%d</td>", $tCh, $Minutes;
		}
		
		if($ACD == 0){
			print INDACTIVE "<td> </td>";
		}
		else{ 
			if($ACD < 1){
			$td1 = "<td style=\"color:red\">";
			}
			else {
			$td1 = "<td>";
			}

			printf INDACTIVE "$td1%.1f</td>", $ACD;
		}

		if($ASR == 0){
			print INDACTIVE "<td></td><td></td></tr>\n";
		}
		else{
			if($ASRm < 15){
			$td1 = "<td style=\"color:red\">";
			$td2 = "<td style=\"color:red\">";
			}
			elsif ($ASR < 15){
			$td1 = "<td style=\"color:red\">";
			$td2 = "<td>";
			}
			else{
			$td1 = "<td>";
			$td2 = "<td>";
			}
 
			printf INDACTIVE "$td1%d</td>$td2%d</td>\n", $ASR, $ASRm;
		}
			

		#printf INDACTIVE "<td>%d</td><td>%d</td><td>%.1f</td><td>%d</td><td>%d</td></tr>\n", $tCh, $Minutes, $ACD, $ASR, $ASRm;
		unless (-e $mrtgCFG){
			CreateCfg($Name, $FullName, $CountryShort, $GWShort, $Gateway, $PrimaryKey) unless ($Name eq "");
			$NewDest = 1;
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "asr", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "acd", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "seizures", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "minutesCh", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "ansdel", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "normald", 0, 0);
			CreatePl($Name, $CountryShort, $GWShort, $PrimaryKey, "nocircd", 0, 0);
			print MRTGBATCHNEWDEST "perl mrtg --logging=$LogFile $CFGFile\n" ;

		}
		
						
		#print MRTGBATCH "perl mrtg --logging=$LogFile $CFGFile\n";	

			
	}

	else {
		if (-e $mrtgCFG){
			if ($Seiz1440 > 0){
				print IND24 "<tr BGCOLOR=$BGCOLOR><td><a href=\"cgi-bin/14all\.cgi?dir=$Name\\\&cfg=$CFGFile&periodtype=daily\"><span style=\'color:windowtext\;text-decoration:none\;text-underline:none\'>$NickName</a></td><td><a href=\"cgi-bin/14all\.cgi?dir=$Name\\\&cfg=$CFGFile&periodtype=daily\"><span style=\'color:windowtext\;text-decoration:none\;text-underline:none\'>$NickCountry</a></td><td><a href=\"cgi-bin/14all\.cgi?dir=$Name\\\&cfg=$CFGFile&periodtype=daily\"><span style=\'color:windowtext\;text-decoration:none\;text-underline:none\'>$GW2</a></td>\n";
				printf IND24 "<td>%d</td></tr>\n", $Seiz1440;	
			}
			else {
				print INDINACTIVE "<tr BGCOLOR=$BGCOLOR><td><a href=\"cgi-bin/14all\.cgi?dir=$Name\\\&cfg=$CFGFile&periodtype=weekly\" target=\"index1\"><span style=\'color:windowtext\;text-decoration:none\;text-underline:none\'>$NickName</a></td><td><a href=\"cgi-bin/14all\.cgi?dir=$Name\\\&cfg=$CFGFile&periodtype=weekly\" target=\"index1\"><span style=\'color:windowtext\;text-decoration:none\;text-underline:none\'>$NickCountry</a></td><td><a href=\"cgi-bin/14all\.cgi?dir=$Name\\\&cfg=$CFGFile&periodtype=weekly\" target=\"index1\"><span style=\'color:windowtext\;text-decoration:none\;text-underline:none\'>$GW2</a></td>\n";
			}

		}
	}

	if(-e $mrtgCFG){
		print INDEXLIST "$Name,$FullName,$CountryShort,$GWShort,$Gateway,$PrimaryKey\n";
	}

	if ($Seiz3Day > 0) {
		print INDEXACTIVELIST "$Name,$FullName,$CountryShort,$GWShort,$Gateway,$PrimaryKey\n";
	}
 }

close (INDEXLIST);
close (INDEXACTIVELIST);

$mrtgDir = "c:\\mrtg-2\.10\.13\\bin\\";
$mrtgIndexCFG = $mrtgDir."mrtg-index\.cfg";
$mrtgIndexActive = $mrtgDir."mrtg-indexActive\.cfg";
$mrtgIndexByCountry = $mrtgDir."mrtg-indexByCountry\.cfg";
$mrtgIndexByCount_All = $mrtgDir."mrtg-indexByCount_All\.cfg";
$mrtgIndexHeader = $mrtgDir."mrtgIndexHeader\.txt";

open( INDEXHEAD, "<$mrtgIndexHeader") or die "Can't open $mrtgIndexHeader.\n";
open( INDEXLIST, "<$mrtgIndexList") or die "Can't open $mrtgIndexList.\n";
open( CFGFILEACTIVE, ">$mrtgIndexActive") or die "Can't open $mrtgIndexActive.\n";
open( INDEXACTIVELIST, "<$mrtgIndexActiveList") or die "Can't open $mrtgIndexActiveList.\n";
open( CFGBYCOUNTRY, ">$mrtgIndexByCountry") or die "Can't open $mrtgIndexActive.\n";


while($line = <INDEXHEAD>){
	print CFGFILEACTIVE "$line";
	print CFGBYCOUNTRY "$line";
}

while($line = <INDEXACTIVELIST>){
	($Name,$FullName,$Country,$GW,$Gateway,$PrimaryKey) = split(",",$line);
	$DestName = "$Name-$Country-$GW-$PrimaryKey";
	$DestDesc = "$FullName $Country $Gateway";
	chop($DestName);

	if ($FullName eq "GW"){
		print CFGFILEACTIVE "directory[_]:Gateways\n";
	}
	else{
		print CFGFILEACTIVE "directory[_]:$FullName\n";
		print CFGBYCOUNTRY "directory[_]:$Country\n";
	}
	print CFGFILEACTIVE "Target[$DestName-minutesCh]: \`perl c:\\mrtg-2.10.13\\Scripts\\$DestName-minutesCh\.pl\`\nPNGTitle[$DestName-minutesCh]: Minutes/Channels    $DestDesc\nLegend1[$DestName-minutesCh]: Minutes per Minute for $DestDesc\nLegend2[$DestName-minutesCh]: Channels for $DestDesc\nTitle[$DestName-minutesCh]: Minutes/Channels: $DestDesc\nPageTop[$DestName-minutesCh]: <H5><FONT COLOR=\" \& #0000ff\& \"> Minutes/Channels: $DestDesc </H5>\n \n";
	print CFGBYCOUNTRY "Target[$DestName-minutesCh]: \`perl c:\\mrtg-2.10.13\\Scripts\\$DestName-minutesCh\.pl\`\nPNGTitle[$DestName-minutesCh]: Minutes/Channels    $DestDesc\nLegend1[$DestName-minutesCh]: Minutes per Minute for $DestDesc\nLegend2[$DestName-minutesCh]: Channels for $DestDesc\nTitle[$DestName-minutesCh]: Minutes/Channels: $DestDesc\nPageTop[$DestName-minutesCh]: <H5><FONT COLOR=\" \& #0000ff\& \"> Minutes/Channels: $DestDesc </H5>\n \n";

}

close (INDEXHEAD);
close (CFGFILEACTIVE);
close (CFGBYCOUNTRY);

if ($NewDest == 1){

	open( INDEXHEAD, "<$mrtgIndexHeader") or die "Can't open $mrtgIndexHeader.\n";
	open( CFGFILE, ">$mrtgIndexCFG") or die "Can't open $mrtgIndexCFG.\n";
	open( CFGBYCOUNTALL, ">$mrtgIndexByCount_All") or die "Can't open $mrtgIndexByCount_All.\n";

	while($line = <INDEXHEAD>){
		print CFGFILE "$line";
		print CFGBYCOUNTALL "$line";
	}

	while($line = <INDEXLIST>){	# If there is a new Destination, rewrite the Index CFG Files.

		($Name,$FullName,$Country,$GW,$Gateway,$PrimaryKey) = split(",",$line);
		$DestName = "$Name-$Country-$GW-$PrimaryKey";
		$DestDesc = "$FullName $Country $Gateway";
		chop($DestName);

		if ($FullName eq "GW"){
			print CFGFILE "directory[_]:Gateways\n";
		}
		else{
			print CFGFILE "directory[_]:$FullName\n";
			print CFGBYCOUNTALL "directory[_]:$Country\n";
		}
		print CFGFILE "Target[$DestName-minutesCh]: \`perl c:\\mrtg-2.10.13\\Scripts\\$DestName-minutesCh\.pl\`\nPNGTitle[$DestName-minutesCh]: Minutes/Channels    $DestDesc\nLegend1[$DestName-minutesCh]: Minutes per Minute for $DestDesc\nLegend2[$DestName-minutesCh]: Channels for $DestDesc\nTitle[$DestName-minutesCh]: Minutes/Channels: $DestDesc\nPageTop[$DestName-minutesCh]: <H5><FONT COLOR=\" \& #0000ff\& \"> Minutes/Channels: $DestDesc </H5>\n \n";
		print CFGBYCOUNTALL "Target[$DestName-minutesCh]: \`perl c:\\mrtg-2.10.13\\Scripts\\$DestName-minutesCh\.pl\`\nPNGTitle[$DestName-minutesCh]: Minutes/Channels    $DestDesc\nLegend1[$DestName-minutesCh]: Minutes per Minute for $DestDesc\nLegend2[$DestName-minutesCh]: Channels for $DestDesc\nTitle[$DestName-minutesCh]: Minutes/Channels: $DestDesc\nPageTop[$DestName-minutesCh]: <H5><FONT COLOR=\" \& #0000ff\& \"> Minutes/Channels: $DestDesc </H5>\n \n";
	}

}
close (INDEXLIST);
close (CFGFILE);
close (CFGBYCOUNTALL);
print MRTGBATCH "cd c:\\radiuslog\\\n";
print MRTGBATCH "del *\.cdr \n";
print MRTGBATCH "cd c:\\radiuslog\\tempImport\\\n";


#print MRTGBATCH "perl mrtg --logging=mrtg-index\.log mrtg-index\.cfg\n";
close (MRTGBATCH);
print MRTGBATCHNEWDEST "c:\\MrtgBatch.bat\n";

close (MRTGBATCHNEWDEST);
PrintHTMLFile();

($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time) ; 

$timestamp = "$Hour:$Minute:$Second";
#print OUTFILELOG "end mrtgbbach processing : $timestamp \n";
print OUTFILELOG "$timestamp,";

#new destinations main procedure end

#Archive Shrink

$archiveshrink = "Execute RadiusDataArchiveAppend
Execute RadiusRegionArchiveAppend";

$sth = $dbh->prepare($archiveshrink); 
$sth->execute or die "couldn't execute statement" .$sth->errstr;

($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time) ; 

$timestamp = "$Hour:$Minute:$Second";
#print OUTFILELOG "end archive : $timestamp \n";
print OUTFILELOG "$timestamp,";

#system('c:\mrtgbatch.bat');
system('c:\mrtgbatchnewdest.bat');
($Second, $Minute, $Hour, $Day, $Month, $Year, $WeekDay, $DayOfYear, $IsDST) = localtime(time) ; 

$timestamp = "$Hour:$Minute:$Second";
#print OUTFILELOG "global endtime : $timestamp \n";
print OUTFILELOG "$timestamp,$Active_counter\n";
close OUTFILELOG;

}

