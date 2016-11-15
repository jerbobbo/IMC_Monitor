#!/usr/bin/perl -w
use File::Copy;
use Cwd;
use Net::FTP;
use Date::Calc qw(Today Add_Delta_Days);
use POSIX qw(ceil floor);
# require ("imcfunctions.pl");


sub main();

main();

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
$radiusinoutlogfile ="IMC_Monitor2.log";
$radiusincsvfile ="Monitor.insansay2.csv";
$radiusoutcsvfile = "Monitor.outsansay2.csv";



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
# $softswitch[0]="206\.131\.227\.3";
$softswitch[0]="209\.51\.180\.131";
$softswitch[1]="209\.51\.180\.135";
$softswitch[2]="209\.51\.180\.137";
$softswitch[3]="217\.14\.132\.202";
$softswitch[4]="217\.14\.132\.206";

# LOOP on SANSAYs to get the CDRS
$switchcount=0;


#TOREMOVE
print('before boucle switchcount');
#Loop on sansays IPs
BOUCLE: while ($switchcount < 5 )
	{
		eval{
			$ftp = Net::FTP->new($softswitch[$switchcount],Debug => 3);

			#Login credentials
			$ftp->login("cdr","28cAu10r") ;

			#change working directory
			$ftp->cwd("/CDR/");
		};


		$ftp->binary;

		#List Cdrs FILES UNDER /CDR
		@files=$ftp->ls("-t *.cdr");

		if ($@)
		{
		print OUTFILELOG "errors occured $@ : $timestamp \n";
		$switchcount=$switchcount +1 ;
		next;
		}

		# FIND LAST CDRS FILE NAME
		$radiuslog = $files[0];
		# READ CDRs FILES where first row number> last Cdrs last row number
		#TOREMOVE
		print('before boucle read @files');

				#compare last file name to files under CDR
					$ftp->get($radiuslog)    or print  "error message :$ftp->message";

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

		$DisconnectCause=dec2hex($cdr_values[11]);

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
		elsif ($RemoteAddresst =~ /206\.131\.227\.2|206\.131\.227\.19|63\.218\.111\.238|89\.249\.209\.73/) { #sip to sip
			$Membert = "890";
			$Strtt = 0;
			$CallTypet="V";
		}
		elsif ($RemoteAddresst =~ /66\.241\.7\.200|66\.241\.7\.201/) { #Vinculum
			$Membert = "8583";
			$Strtt = 0;

		}
		elsif ($RemoteAddresst =~ /202\.125\.146\.1/){ #PTCL
			$Membert = "8548";
			$Strtt = 3;
		}
		elsif ($RemoteAddresst =~ /69\.10\.52\.36/){ #BGI
			$Membert = "8548";
			$Strtt = 3;
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
		elsif ($RemoteAddresst =~ /81\.52\.176\.101|81\.52\.176\.133|81\.52\.176\.165/) { #Francetelecom
			$Membert = "8586";
			$Strtt = 0;

		}
		elsif ($RemoteAddresst =~ /212\.102\.3\.3|212\.102\.3\.4|212\.102\.3\.5|212\.102\.3\.6|212\.102\.3\.7/) { #MAJE
			$Membert = "8586";
			$Strtt = 0;

		}

		if ($RemoteAddress =~ /81\.52\.176\.101|81\.52\.176\.133|81\.52\.176\.165/) { #Francetelecom
			$Member = "8586";
			$Strt = 0;

		}
		elsif ($RemoteAddress =~ /213\.248\.105\.21|213\.248\.105\.29/) { #Teliasonera
			$Member = "8583";
			$Strt = 0;

		}

		elsif ($RemoteAddress =~ /199\.15\.76\.10|199\.15\.76\.12|199\.15\.76\.14|70\.42\.46\.4|70\.42\.46\.10|70\.42\.46\.35|70\.42\.46\.48|70\.42\.46\.8|70\.42\.46\.11/){ #STI
			$Member = "8547";
			$Strt = 5;
		}

		elsif ($RemoteAddress =~ /196\.219\.52\.|217\.194\.136\.|64\.110\.64\.|87\.228\.197\.|213\.144\.186\.99/) { #From STE gateway
			$GWip=$RemoteAddress;
			$CallType = "Telephony";
			$v_t = "t";
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

		if ($RemoteAddress =~ /64\.27\.1\.152|69\.64\.173\.162|8\.7\.22\.90|8\.7\.22\.71|4\.79\.201\.111|4\.79\.201\.103/){ #voicestep: normal to Sip with american number call
			$Member = "890";
			$CallType="R";
			$ConfIDtemp=$ConfIDt;
			if (!($RemoteAddresst =~ /206\.131\.227\.2|206\.131\.227\.19|63\.218\.111\.238|89\.249\.209\.73/)) { #call forwarding

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


		if ($RemoteAddress =~ /206\.131\.227\.2|206\.131\.227\.19|63\.218\.111\.238/){ #retail
			$Member = "890";
			if ($RemoteAddresst =~ /206\.131\.227\.2|206\.131\.227\.19|63\.218\.111\.238/){  #sip to sip without forwarding
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


}
