
-- Create syntax for TABLE 'accounting_gateways'
CREATE TABLE `accounting_gateways` (
  `GWip` varchar(16) collate ascii_bin NOT NULL,
  `Type` varchar(3) collate ascii_bin NOT NULL,
  PRIMARY KEY  (`GWip`)
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'accounting_members'
CREATE TABLE `accounting_members` (
  `member_name` varchar(10) collate ascii_bin NOT NULL,
  `member_ip` varchar(16) collate ascii_bin NOT NULL,
  `Type` char(3) collate ascii_bin default NULL,
  `v_t` char(1) collate ascii_bin NOT NULL,
  `pricing_plan` varchar(10) collate ascii_bin default NULL,
  `intc` varchar(50) collate ascii_bin default NULL,
  PRIMARY KEY  (`member_ip`,`v_t`)
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'accounting_price'
CREATE TABLE `accounting_price` (
  `Customer` varchar(50) collate ascii_bin NOT NULL,
  `RegionID` int(11) NOT NULL,
  `Effective_Date` datetime NOT NULL,
  `Price` float NOT NULL,
  `initial_increment` float default NULL,
  `additional_increment` float default NULL,
  `price_pk` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`price_pk`)
) ENGINE=MyISAM AUTO_INCREMENT=6789432 DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'accounting_region'
CREATE TABLE `accounting_region` (
  `Prefix` varchar(4) character set utf8 NOT NULL,
  `RegionName` varchar(50) character set utf8 NOT NULL,
  `RegionCode` varchar(8) collate ascii_bin NOT NULL,
  `mobile_proper` char(1) collate ascii_bin default NULL,
  `Routecode` int(11) default NULL,
  `RegionID` int(11) NOT NULL auto_increment,
  `date_region` datetime default NULL,
  PRIMARY KEY  (`RegionID`)
) ENGINE=MyISAM AUTO_INCREMENT=19063 DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'accounting_regioncountrytemp'
CREATE TABLE `accounting_regioncountrytemp` (
  `Prefix` varchar(4) character set utf8 NOT NULL,
  `RegionName` varchar(50) character set utf8 NOT NULL,
  `RegionCode` varchar(8) collate ascii_bin NOT NULL default '',
  `mobile_proper` char(1) collate ascii_bin default NULL,
  `Routecode` int(11) default NULL,
  `RegionID` int(11) NOT NULL,
  `CountryName` varchar(50) character set utf8 default NULL,
  PRIMARY KEY  (`RegionID`)
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'accounting_regionfromto'
CREATE TABLE `accounting_regionfromto` (
  `Prefix` varchar(3) character set utf8 NOT NULL,
  `RegionName` varchar(25) character set utf8 NOT NULL,
  `From` char(8) collate ascii_bin NOT NULL,
  `To` char(8) collate ascii_bin NOT NULL,
  `RegionID` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`RegionID`)
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'accounting_regiontemp'
CREATE TABLE `accounting_regiontemp` (
  `Prefix` varchar(4) character set utf8 NOT NULL,
  `RegionName` varchar(50) character set utf8 NOT NULL,
  `RegionCode` varchar(8) collate ascii_bin NOT NULL,
  `mobile_proper` char(1) collate ascii_bin default NULL,
  `Routecode` bigint(20) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'cl_cdrbysansay'
CREATE TABLE `cl_cdrbysansay` (
  `IPSansay` int(11) NOT NULL,
  `LastcdrName` varchar(50) collate ascii_bin default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'country_prefix'
CREATE TABLE `country_prefix` (
  `Country` varchar(255) character set utf8 default NULL,
  `Prefix` varchar(50) character set utf8 NOT NULL,
  PRIMARY KEY  (`Prefix`)
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'dest'
CREATE TABLE `dest` (
  `Dest` int(11) NOT NULL,
  `Monitored` tinyint(4) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'disconnecttext'
CREATE TABLE `disconnecttext` (
  `DisconnectText` varchar(255) character set utf8 default NULL,
  `DiscID` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'disconnecttext_master'
CREATE TABLE `disconnecttext_master` (
  `DisconnectText` varchar(255) character set utf8 default NULL,
  `ID` int(11) NOT NULL,
  `IDh` varchar(3) collate ascii_bin NOT NULL default '',
  `DisconnectGroup` int(11) default NULL,
  `ASRmGroup` tinyint(4) default NULL,
  PRIMARY KEY  (`IDh`)
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'gateway_ip'
CREATE TABLE `gateway_ip` (
  `GW KEY` int(11) NOT NULL auto_increment,
  `GW_IP` varchar(255) character set utf8 default NULL,
  `IP-IP` tinyint(4) default NULL,
  PRIMARY KEY  (`GW KEY`)
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'members'
CREATE TABLE `members` (
  `Name` varchar(255) character set utf8 default NULL,
  `Account Number` varchar(50) character set utf8 NOT NULL,
  `Rounded` tinyint(4) default NULL,
  `SetUp_Sec` tinyint(4) default NULL,
  `Cost/Sale` varchar(50) character set utf8 default NULL,
  `Account Group` varchar(50) character set utf8 default NULL,
  `Nickname` varchar(50) character set utf8 default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'monitorin_table'
CREATE TABLE `monitorin_table` (
  `MaxTime` datetime default NULL,
  `SetupSec` decimal(31,0) default NULL,
  `ConnectMin` decimal(36,4) default NULL,
  `Round30Min` decimal(39,4) default NULL,
  `CallType` varchar(9) collate ascii_bin default NULL,
  `GWip` varchar(15) collate ascii_bin default NULL,
  `OutOctets` decimal(41,0) default NULL,
  `InOctets` decimal(41,0) default NULL,
  `Completed` bigint(21) NOT NULL default '0',
  `CountryCode` varchar(5) collate ascii_bin default NULL,
  `Member` varchar(4) collate ascii_bin default NULL,
  `OutPackets` decimal(41,0) default NULL,
  `InPackets` decimal(41,0) default NULL,
  `SetUpAdj` decimal(31,0) default NULL,
  `SetUpSeiz` bigint(21) NOT NULL default '0',
  `Round6Min` decimal(39,4) default NULL,
  `Name` varchar(14) collate ascii_bin default NULL,
  `Seizures` bigint(21) NOT NULL default '0',
  `NormalD` bigint(21) NOT NULL default '0',
  `FailureD` bigint(21) NOT NULL default '0',
  `FSRseiz` bigint(21) NOT NULL default '0',
  `NoCircD` bigint(21) NOT NULL default '0',
  `NoReqCircD` bigint(21) NOT NULL default '0',
  `Blank` varchar(1) character set utf8 NOT NULL default '',
  `GWNickname` char(3) collate ascii_bin default NULL,
  `ASRmSeiz` bigint(21) NOT NULL default '0',
  `Failed` bigint(21) NOT NULL default '0',
  `AccountGroup` varchar(10) collate ascii_bin default NULL,
  `nickname` varchar(7) collate ascii_bin default NULL,
  `v_t` char(1) collate ascii_bin default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;


-- Create syntax for TABLE 'monitorout_table'
CREATE TABLE `monitorout_table` (
  `MaxTime` datetime default NULL,
  `SetupSec` decimal(31,0) default NULL,
  `ConnectMin` decimal(36,4) default NULL,
  `Round30Min` decimal(39,4) default NULL,
  `CallType` varchar(9) collate ascii_bin default NULL,
  `GWip` varchar(15) collate ascii_bin default NULL,
  `OutOctets` decimal(41,0) default NULL,
  `InOctets` decimal(41,0) default NULL,
  `Completed` bigint(21) NOT NULL default '0',
  `CountryCode` varchar(5) collate ascii_bin default NULL,
  `Member` varchar(4) collate ascii_bin default NULL,
  `OutPackets` decimal(41,0) default NULL,
  `InPackets` decimal(41,0) default NULL,
  `SetUpAdj` decimal(31,0) default NULL,
  `SetUpSeiz` bigint(21) NOT NULL default '0',
  `Round6Min` decimal(39,4) default NULL,
  `Name` varchar(13) collate ascii_bin default NULL,
  `Seizures` bigint(21) NOT NULL default '0',
  `NormalD` bigint(21) NOT NULL default '0',
  `FailureD` bigint(21) NOT NULL default '0',
  `FSRseiz` bigint(21) NOT NULL default '0',
  `NoCircD` bigint(21) NOT NULL default '0',
  `NoReqCircD` bigint(21) NOT NULL default '0',
  `Blank` varchar(1) character set utf8 NOT NULL default '',
  `GWNickname` char(3) collate ascii_bin default NULL,
  `ASRmSeiz` bigint(21) NOT NULL default '0',
  `Failed` bigint(21) NOT NULL default '0',
  `AccountGroup` varchar(10) collate ascii_bin default NULL,
  `nickname` varchar(6) collate ascii_bin default NULL,
  `v_t` char(1) collate ascii_bin default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'monitoring_access'
CREATE TABLE `monitoring_access` (
  `user_account` varchar(50) collate ascii_bin default NULL,
  `acc_permissions` varchar(10) collate ascii_bin NOT NULL default 'all'
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'pots_ip'
CREATE TABLE `pots_ip` (
  `POTS_IP KEY` int(11) NOT NULL auto_increment,
  `SourceIP` varchar(255) character set utf8 default NULL,
  `CallType` varchar(50) collate ascii_bin default NULL,
  PRIMARY KEY  (`POTS_IP KEY`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'radiusdata'
CREATE TABLE `radiusdata` (
  `PrimaryKey` int(11) default NULL,
  `Name` varchar(14) collate ascii_bin default NULL,
  `Country` varchar(255) character set utf8 default NULL,
  `gateway` varchar(50) character set utf8 default NULL,
  `Seizures` int(11) default NULL,
  `Completed` int(11) default NULL,
  `ASR` int(11) default NULL,
  `ASRm` int(11) default NULL,
  `ACD` decimal(38,6) default NULL,
  `Minutes` decimal(38,6) default NULL,
  `BilledMin` decimal(38,10) default NULL,
  `TQI` int(11) default NULL,
  `AnsDel` int(11) default NULL,
  `AdjAnsDel` int(11) default NULL,
  `NormalD` int(11) default NULL,
  `FailureD` int(11) default NULL,
  `NoCircD` int(11) default NULL,
  `NoReqCircD` int(11) default NULL,
  `tCh` decimal(38,6) default NULL,
  `kOctetsXmt` bigint(20) default NULL,
  `kOctetsRec` bigint(20) default NULL,
  `MaxTime` datetime default NULL,
  `Failed` int(11) default NULL,
  `NormalDisc` int(11) default NULL,
  `FailureDisc` int(11) default NULL,
  `NoCircDisc` int(11) default NULL,
  `NoReqCircDisc` int(11) default NULL,
  `ASRmSeiz` int(11) default NULL,
  `GWip` varchar(50) collate ascii_bin default NULL,
  `CallType` varchar(50) collate ascii_bin default NULL,
  `AccountGroup` varchar(15) collate ascii_bin default NULL,
  `FSR` int(11) default NULL,
  `FSRseiz` int(11) default NULL,
  `import_id` int(11) default NULL,
  `nickname` varchar(8) collate ascii_bin default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;


-- Create syntax for TABLE 'radiusdataarchive'
CREATE TABLE `radiusdataarchive` (
  `PrimaryKey` int(11) default NULL,
  `Name` varchar(14) collate ascii_bin default NULL,
  `Country` varchar(255) character set utf8 default NULL,
  `gateway` varchar(50) character set utf8 default NULL,
  `Seizures` int(11) default NULL,
  `Completed` int(11) default NULL,
  `ASR` int(11) default NULL,
  `ASRm` int(11) default NULL,
  `ACD` decimal(38,6) default NULL,
  `Minutes` decimal(38,6) default NULL,
  `BilledMin` decimal(38,10) default NULL,
  `TQI` int(11) default NULL,
  `AnsDel` int(11) default NULL,
  `AdjAnsDel` int(11) default NULL,
  `NormalD` int(11) default NULL,
  `FailureD` int(11) default NULL,
  `NoCircD` int(11) default NULL,
  `NoReqCircD` int(11) default NULL,
  `tCh` decimal(38,6) default NULL,
  `kOctetsXmt` bigint(20) default NULL,
  `kOctetsRec` bigint(20) default NULL,
  `MaxTime` datetime default NULL,
  `Failed` int(11) default NULL,
  `NormalDisc` int(11) default NULL,
  `FailureDisc` int(11) default NULL,
  `NoCircDisc` int(11) default NULL,
  `NoReqCircDisc` int(11) default NULL,
  `ASRmSeiz` int(11) default NULL,
  `GWip` varchar(50) collate ascii_bin default NULL,
  `CallType` varchar(50) collate ascii_bin default NULL,
  `AccountGroup` varchar(15) collate ascii_bin default NULL,
  `FSR` int(11) default NULL,
  `FSRseiz` int(11) default NULL,
  `import_id` int(11) default NULL,
  `Nickname` varchar(50) character set utf8 default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'radiusdatafinaltable'
CREATE TABLE `radiusdatafinaltable` (
  `PrimaryKey` int(11) NOT NULL default '0',
  `name` varchar(255) character set utf8 default NULL,
  `Country` varchar(255) character set utf8 default NULL,
  `gateway` varchar(50) character set utf8 default NULL,
  `Seizures` int(11) default NULL,
  `Completed` int(11) default NULL,
  `ASR` int(11) default NULL,
  `ASRm` int(11) default NULL,
  `ACD` decimal(38,6) default NULL,
  `Minutes` decimal(38,6) default NULL,
  `BilledMin` decimal(38,10) default NULL,
  `AnsDel` int(11) default NULL,
  `AdjAnsDel` int(11) default NULL,
  `NormalD` int(11) default NULL,
  `FailureD` int(11) default NULL,
  `NoCircD` int(11) default NULL,
  `tCh` decimal(38,6) default NULL,
  `MaxTime` datetime default NULL,
  `Failed` int(11) default NULL,
  `CallType` varchar(50) collate ascii_bin default NULL,
  `AccountGroup` longtext character set utf8,
  `FSR` int(11) default NULL,
  `InOut` varchar(3) character set utf8 collate utf8_unicode_ci default NULL,
  `GWip` varchar(50) collate ascii_bin default NULL,
  `Seiz5` int(11) default NULL,
  `Seiz1440` int(11) default NULL,
  `Seiz3Day` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'radiusdatagraphs'
CREATE TABLE `radiusdatagraphs` (
  `PrimaryKey` int(11) default NULL,
  `Name` varchar(14) collate ascii_bin default NULL,
  `Country` varchar(255) character set utf8 default NULL,
  `gateway` varchar(50) character set utf8 default NULL,
  `Seizures` int(11) default NULL,
  `Completed` int(11) default NULL,
  `ASR` int(11) default NULL,
  `ASRm` int(11) default NULL,
  `ACD` decimal(38,6) default NULL,
  `Minutes` decimal(38,6) default NULL,
  `BilledMin` decimal(38,10) default NULL,
  `TQI` int(11) default NULL,
  `AnsDel` int(11) default NULL,
  `AdjAnsDel` int(11) default NULL,
  `NormalD` int(11) default NULL,
  `FailureD` int(11) default NULL,
  `NoCircD` int(11) default NULL,
  `NoReqCircD` int(11) default NULL,
  `tCh` decimal(38,6) default NULL,
  `kOctetsXmt` bigint(20) default NULL,
  `kOctetsRec` bigint(20) default NULL,
  `MaxTime` datetime default NULL,
  `Failed` int(11) default NULL,
  `NormalDisc` int(11) default NULL,
  `FailureDisc` int(11) default NULL,
  `NoCircDisc` int(11) default NULL,
  `NoReqCircDisc` int(11) default NULL,
  `ASRmSeiz` int(11) default NULL,
  `Rounded` decimal(38,6) default NULL,
  `GWip` varchar(50) collate ascii_bin default NULL,
  `CallType` varchar(50) collate ascii_bin default NULL,
  `AccountGroup` varchar(15) collate ascii_bin default NULL,
  `FSR` int(11) default NULL,
  `FSRseiz` int(11) default NULL,
  `import_id` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'radiusdestinations'
CREATE TABLE `radiusdestinations` (
  `Country` varchar(50) character set utf8 default NULL,
  `AdjustedCountry` varchar(50) character set utf8 default NULL,
  `Gateway` varchar(50) character set utf8 default NULL,
  `Name` varchar(255) character set utf8 default NULL,
  `NickName` varchar(50) character set utf8 default NULL,
  `Client` varchar(50) character set utf8 default NULL,
  `PrimaryKey` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`PrimaryKey`)
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'radiusdestinationsfinal'
CREATE TABLE `radiusdestinationsfinal` (
  `country` varchar(50) character set utf8 default NULL,
  `name` varchar(255) character set utf8 default NULL,
  `nickname` varchar(50) character set utf8 default NULL,
  `gateway` varchar(50) character set utf8 default NULL,
  `PrimaryKey` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`PrimaryKey`)
) ENGINE=MyISAM AUTO_INCREMENT=4687 DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'radiusregion'
CREATE TABLE `radiusregion` (
  `Name` varchar(14) collate ascii_bin default NULL,
  `Country` varchar(255) character set utf8 default NULL,
  `Region` varchar(50) collate ascii_bin default NULL,
  `mobile_proper` char(1) collate ascii_bin default NULL,
  `gateway` varchar(3) collate ascii_bin default NULL,
  `Seizures` int(11) default NULL,
  `Completed` int(11) default NULL,
  `ASR` int(11) default NULL,
  `ASRm` int(11) default NULL,
  `ACD` decimal(38,6) default NULL,
  `Minutes` decimal(38,6) default NULL,
  `BilledMin` decimal(38,10) default NULL,
  `TQI` int(11) default NULL,
  `AnsDel` int(11) default NULL,
  `AdjAnsDel` int(11) default NULL,
  `NormalD` int(11) default NULL,
  `FailureD` int(11) default NULL,
  `NoCircD` int(11) default NULL,
  `NoReqCircD` int(11) default NULL,
  `tCh` decimal(38,6) default NULL,
  `kOctetsXmt` bigint(20) default NULL,
  `kOctetsRec` bigint(20) default NULL,
  `MaxTime` datetime default NULL,
  `Failed` int(11) default NULL,
  `NormalDisc` int(11) default NULL,
  `FailureDisc` int(11) default NULL,
  `NoCircDisc` int(11) default NULL,
  `NoReqCircDisc` int(11) default NULL,
  `ASRmSeiz` int(11) default NULL,
  `GWip` varchar(50) collate ascii_bin default NULL,
  `TrunkGroup` int(11) default NULL,
  `CallType` varchar(50) collate ascii_bin default NULL,
  `AccountGroup` varchar(10) collate ascii_bin default NULL,
  `FSR` int(11) default NULL,
  `FSRSeiz` int(11) default NULL,
  `regionidprim` int(11) default NULL,
  `import_id` int(11) default NULL,
  `nickname` varchar(8) collate ascii_bin default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;


-- Create syntax for TABLE 'radiusregionarchive'
CREATE TABLE `radiusregionarchive` (
  `Name` varchar(14) collate ascii_bin default NULL,
  `Country` varchar(255) character set utf8 default NULL,
  `Region` varchar(50) collate ascii_bin default NULL,
  `mobile_proper` char(1) collate ascii_bin default NULL,
  `gateway` varchar(3) collate ascii_bin default NULL,
  `Seizures` int(11) default NULL,
  `Completed` int(11) default NULL,
  `ASR` int(11) default NULL,
  `ASRm` int(11) default NULL,
  `ACD` decimal(38,6) default NULL,
  `Minutes` decimal(38,6) default NULL,
  `BilledMin` decimal(38,10) default NULL,
  `TQI` int(11) default NULL,
  `AnsDel` int(11) default NULL,
  `AdjAnsDel` int(11) default NULL,
  `NormalD` int(11) default NULL,
  `FailureD` int(11) default NULL,
  `NoCircD` int(11) default NULL,
  `NoReqCircD` int(11) default NULL,
  `tCh` decimal(38,6) default NULL,
  `kOctetsXmt` bigint(20) default NULL,
  `kOctetsRec` bigint(20) default NULL,
  `MaxTime` datetime default NULL,
  `Failed` int(11) default NULL,
  `NormalDisc` int(11) default NULL,
  `FailureDisc` int(11) default NULL,
  `NoCircDisc` int(11) default NULL,
  `NoReqCircDisc` int(11) default NULL,
  `ASRmSeiz` int(11) default NULL,
  `GWip` varchar(50) collate ascii_bin default NULL,
  `TrunkGroup` int(11) default NULL,
  `CallType` varchar(50) collate ascii_bin default NULL,
  `AccountGroup` varchar(10) collate ascii_bin default NULL,
  `FSR` int(11) default NULL,
  `FSRSeiz` int(11) default NULL,
  `regionidprim` int(11) default NULL,
  `import_id` int(11) default NULL,
  `nickname` varchar(8) collate ascii_bin default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'radiusregionarchive_sum'
CREATE TABLE `radiusregionarchive_sum` (
  `Name` varchar(14) collate ascii_bin default NULL,
  `Country` varchar(255) character set utf8 default NULL,
  `Region` varchar(50) collate ascii_bin default NULL,
  `regionidprim` int(11) default NULL,
  `Seizures` int(11) default NULL,
  `completed` int(11) default NULL,
  `minutes` decimal(38,6) default NULL,
  `ASRmSeiz` int(11) default NULL,
  `CallDate` datetime default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'regiontemp'
CREATE TABLE `regiontemp` (
  `RegionCalled` char(50) character set utf8 NOT NULL,
  `RegionName` char(50) collate ascii_bin default NULL,
  PRIMARY KEY  (`RegionCalled`)
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'telephonymembers'
CREATE TABLE `telephonymembers` (
  `Name` varchar(10) collate ascii_bin NOT NULL,
  `GWip` varchar(16) character set utf8 NOT NULL,
  `Type` char(2) collate ascii_bin default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'tempaccounting_in'
CREATE TABLE `tempaccounting_in` (
  `SetupDate` datetime default NULL,
  `SetupTime` datetime default NULL,
  `SetupTime2` int(11) default NULL,
  `ConnectTime` datetime default NULL,
  `DisconnectTime` datetime default NULL,
  `CallingID` varchar(30) collate ascii_bin default NULL,
  `CalledID` varchar(30) collate ascii_bin default NULL,
  `Member` varchar(4) collate ascii_bin default NULL,
  `CountryCode` varchar(5) collate ascii_bin default NULL,
  `RegionID` int(11) default NULL,
  `regionidprim` int(11) default NULL,
  `ConfID` varchar(40) collate ascii_bin default NULL,
  `CallOrigin` char(6) collate ascii_bin default NULL,
  `CallType` varchar(9) collate ascii_bin default NULL,
  `GWip` varchar(15) collate ascii_bin default NULL,
  `RxdCalledNumb` varchar(30) collate ascii_bin default NULL,
  `RxdCallingNumb` varchar(30) collate ascii_bin default NULL,
  `RemoteAddress` varchar(15) collate ascii_bin default NULL,
  `RemoteMedAddress` varchar(15) collate ascii_bin default NULL,
  `Username` varchar(30) collate ascii_bin default NULL,
  `NAStrunk` varchar(5) collate ascii_bin default NULL,
  `NASd` int(11) default NULL,
  `SessionTime` int(11) default NULL,
  `DisconnectCause` varchar(2) collate ascii_bin default NULL,
  `OutPackets` bigint(20) default NULL,
  `InPackets` bigint(20) default NULL,
  `OutOctets` bigint(20) default NULL,
  `InOctets` bigint(20) default NULL,
  `v_t` char(1) collate ascii_bin default NULL,
  `IDcol` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`IDcol`)
) ENGINE=MyISAM AUTO_INCREMENT=924 DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'tempaccounting_inarchive'
CREATE TABLE `tempaccounting_inarchive` (
  `SetupDate` datetime default NULL,
  `SetupTime` datetime default NULL,
  `SetupTime2` int(11) default NULL,
  `ConnectTime` datetime default NULL,
  `DisconnectTime` datetime default NULL,
  `CallingID` varchar(30) collate ascii_bin default NULL,
  `CalledID` varchar(30) collate ascii_bin default NULL,
  `Member` varchar(4) collate ascii_bin default NULL,
  `CountryCode` varchar(5) collate ascii_bin default NULL,
  `RegionID` int(11) default NULL,
  `regionidprim` int(11) default NULL,
  `ConfID` varchar(40) collate ascii_bin default NULL,
  `CallOrigin` char(6) collate ascii_bin default NULL,
  `CallType` varchar(9) collate ascii_bin default NULL,
  `GWip` varchar(15) collate ascii_bin default NULL,
  `RxdCalledNumb` varchar(30) collate ascii_bin default NULL,
  `RxdCallingNumb` varchar(30) collate ascii_bin default NULL,
  `RemoteAddress` varchar(15) collate ascii_bin default NULL,
  `RemoteMedAddress` varchar(15) collate ascii_bin default NULL,
  `Username` varchar(30) collate ascii_bin default NULL,
  `NAStrunk` varchar(5) collate ascii_bin default NULL,
  `NASd` int(11) default NULL,
  `SessionTime` int(11) default NULL,
  `DisconnectCause` varchar(2) collate ascii_bin default NULL,
  `OutPackets` bigint(20) default NULL,
  `InPackets` bigint(20) default NULL,
  `OutOctets` bigint(20) default NULL,
  `InOctets` bigint(20) default NULL,
  `SetupSec` int(11) default NULL,
  `OctPackOut` int(11) default NULL,
  `OctPackIn` int(11) default NULL,
  `v_t` char(1) collate ascii_bin default NULL,
  `import_id` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'tempaccounting_indaily'
CREATE TABLE `tempaccounting_indaily` (
  `SetupDate` datetime default NULL,
  `SetupTime` datetime default NULL,
  `SetupTime2` int(11) default NULL,
  `ConnectTime` datetime default NULL,
  `DisconnectTime` datetime default NULL,
  `CallingID` varchar(30) collate ascii_bin default NULL,
  `CalledID` varchar(30) collate ascii_bin default NULL,
  `Member` varchar(4) collate ascii_bin default NULL,
  `CountryCode` varchar(5) collate ascii_bin default NULL,
  `RegionID` int(11) default NULL,
  `ConfID` varchar(40) collate ascii_bin default NULL,
  `CallOrigin` char(6) collate ascii_bin default NULL,
  `CallType` varchar(9) collate ascii_bin default NULL,
  `GWip` varchar(15) collate ascii_bin default NULL,
  `RxdCalledNumb` varchar(30) collate ascii_bin default NULL,
  `RxdCallingNumb` varchar(30) collate ascii_bin default NULL,
  `RemoteAddress` varchar(15) collate ascii_bin default NULL,
  `RemoteMedAddress` varchar(15) collate ascii_bin default NULL,
  `Username` varchar(30) collate ascii_bin default NULL,
  `NAStrunk` varchar(5) collate ascii_bin default NULL,
  `NASd` int(11) default NULL,
  `SessionTime` int(11) default NULL,
  `DisconnectCause` varchar(2) collate ascii_bin default NULL,
  `OutPackets` int(11) default NULL,
  `InPackets` int(11) default NULL,
  `OutOctets` bigint(20) default NULL,
  `InOctets` bigint(20) default NULL,
  `Import_ID` varchar(30) collate ascii_bin default NULL,
  `regionid_prim` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'tempaccounting_indailycal'
CREATE TABLE `tempaccounting_indailycal` (
  `SetupDate` datetime default NULL,
  `SetupTime` datetime default NULL,
  `SetupTime2` int(11) default NULL,
  `ConnectTime` datetime default NULL,
  `DisconnectTime` datetime default NULL,
  `CallingID` varchar(30) collate ascii_bin default NULL,
  `CalledID` varchar(30) collate ascii_bin default NULL,
  `Member` varchar(4) collate ascii_bin default NULL,
  `CountryCode` varchar(5) collate ascii_bin default NULL,
  `RegionID` int(11) default NULL,
  `ConfID` varchar(40) collate ascii_bin default NULL,
  `CallOrigin` char(6) collate ascii_bin default NULL,
  `CallType` varchar(9) collate ascii_bin default NULL,
  `GWip` varchar(15) collate ascii_bin default NULL,
  `RxdCalledNumb` varchar(30) collate ascii_bin default NULL,
  `RxdCallingNumb` varchar(30) collate ascii_bin default NULL,
  `RemoteAddress` varchar(15) collate ascii_bin default NULL,
  `RemoteMedAddress` varchar(15) collate ascii_bin default NULL,
  `Username` varchar(30) collate ascii_bin default NULL,
  `NAStrunk` varchar(5) collate ascii_bin default NULL,
  `NASd` int(11) default NULL,
  `SessionTime` int(11) default NULL,
  `DisconnectCause` varchar(2) collate ascii_bin default NULL,
  `OutPackets` int(11) default NULL,
  `InPackets` int(11) default NULL,
  `OutOctets` bigint(20) default NULL,
  `InOctets` bigint(20) default NULL,
  `Import_ID` varchar(30) collate ascii_bin default NULL,
  `regionid_prim` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'tempaccounting_inimport'
CREATE TABLE `tempaccounting_inimport` (
  `SetupDate` datetime default NULL,
  `SetupTime` datetime default NULL,
  `SetupTime2` int(11) default NULL,
  `ConnectTime` datetime default NULL,
  `DisconnectTime` datetime default NULL,
  `CallingID` varchar(30) collate ascii_bin default NULL,
  `CalledID` varchar(30) collate ascii_bin default NULL,
  `Member` varchar(4) collate ascii_bin default NULL,
  `CountryCode` varchar(5) collate ascii_bin default NULL,
  `RegionID` int(11) default NULL,
  `regionidprim` int(11) default NULL,
  `ConfID` varchar(40) collate ascii_bin default NULL,
  `CallOrigin` char(6) collate ascii_bin default NULL,
  `CallType` varchar(9) collate ascii_bin default NULL,
  `GWip` varchar(15) collate ascii_bin default NULL,
  `RxdCalledNumb` varchar(30) collate ascii_bin default NULL,
  `RxdCallingNumb` varchar(30) collate ascii_bin default NULL,
  `RemoteAddress` varchar(15) collate ascii_bin default NULL,
  `RemoteMedAddress` varchar(15) collate ascii_bin default NULL,
  `Username` varchar(30) collate ascii_bin default NULL,
  `NAStrunk` varchar(5) collate ascii_bin default NULL,
  `NASd` int(11) default NULL,
  `SessionTime` int(11) default NULL,
  `DisconnectCause` varchar(2) collate ascii_bin default NULL,
  `OutPackets` bigint(20) default NULL,
  `InPackets` bigint(20) default NULL,
  `OutOctets` bigint(20) default NULL,
  `InOctets` bigint(20) default NULL,
  `v_t` char(1) collate ascii_bin default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'tempaccounting_inimt'
CREATE TABLE `tempaccounting_inimt` (
  `SetupDate` datetime default NULL,
  `SetupTime` datetime default NULL,
  `SetupTime2` int(11) default NULL,
  `ConnectTime` datetime default NULL,
  `DisconnectTime` datetime default NULL,
  `CallingID` varchar(30) collate ascii_bin default NULL,
  `CalledID` varchar(30) collate ascii_bin default NULL,
  `Member` varchar(4) collate ascii_bin default NULL,
  `CountryCode` varchar(5) collate ascii_bin default NULL,
  `RegionID` int(11) default NULL,
  `regionidprim` int(11) default NULL,
  `ConfID` varchar(40) collate ascii_bin default NULL,
  `CallOrigin` char(6) collate ascii_bin default NULL,
  `CallType` varchar(9) collate ascii_bin default NULL,
  `GWip` varchar(15) collate ascii_bin default NULL,
  `RxdCalledNumb` varchar(30) collate ascii_bin default NULL,
  `RxdCallingNumb` varchar(30) collate ascii_bin default NULL,
  `RemoteAddress` varchar(15) collate ascii_bin default NULL,
  `RemoteMedAddress` varchar(15) collate ascii_bin default NULL,
  `Username` varchar(30) collate ascii_bin default NULL,
  `NAStrunk` varchar(5) collate ascii_bin default NULL,
  `NASd` int(11) default NULL,
  `SessionTime` int(11) default NULL,
  `DisconnectCause` varchar(2) collate ascii_bin default NULL,
  `OutPackets` bigint(20) default NULL,
  `InPackets` bigint(20) default NULL,
  `OutOctets` bigint(20) default NULL,
  `InOctets` bigint(20) default NULL,
  `v_t` char(1) collate ascii_bin default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'tempaccounting_out'
CREATE TABLE `tempaccounting_out` (
  `SetupDate` datetime default NULL,
  `SetupTime` datetime default NULL,
  `SetupTime2` int(11) default NULL,
  `ConnectTime` datetime default NULL,
  `DisconnectTime` datetime default NULL,
  `CallingID` varchar(30) collate ascii_bin default NULL,
  `CalledID` varchar(30) collate ascii_bin default NULL,
  `Member` varchar(4) collate ascii_bin default NULL,
  `CountryCode` varchar(5) collate ascii_bin default NULL,
  `RegionID` int(11) default NULL,
  `regionidprim` int(11) default NULL,
  `ConfID` varchar(40) collate ascii_bin default NULL,
  `CallOrigin` char(9) collate ascii_bin default NULL,
  `CallType` varchar(9) collate ascii_bin default NULL,
  `GWip` varchar(15) collate ascii_bin default NULL,
  `RxdCalledNumb` varchar(30) collate ascii_bin default NULL,
  `RxdCallingNumb` varchar(30) collate ascii_bin default NULL,
  `FinalCalledNumb` varchar(30) collate ascii_bin default NULL,
  `FinalCallingNumb` varchar(30) collate ascii_bin default NULL,
  `RemoteAddress` varchar(15) collate ascii_bin default NULL,
  `RemoteMedAddress` varchar(15) collate ascii_bin default NULL,
  `Username` varchar(30) collate ascii_bin default NULL,
  `NAStrunk` varchar(5) collate ascii_bin default NULL,
  `NASd` int(11) default NULL,
  `SessionTime` int(11) default NULL,
  `DisconnectCause` varchar(2) collate ascii_bin default NULL,
  `OutPackets` bigint(20) default NULL,
  `InPackets` bigint(20) default NULL,
  `OutOctets` bigint(20) default NULL,
  `InOctets` bigint(20) default NULL,
  `v_t` char(1) collate ascii_bin default NULL,
  `IDcol` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`IDcol`)
) ENGINE=MyISAM AUTO_INCREMENT=688 DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'tempaccounting_outarchive'
CREATE TABLE `tempaccounting_outarchive` (
  `SetupDate` datetime default NULL,
  `SetupTime` datetime default NULL,
  `SetupTime2` int(11) default NULL,
  `ConnectTime` datetime default NULL,
  `DisconnectTime` datetime default NULL,
  `CallingID` varchar(30) collate ascii_bin default NULL,
  `CalledID` varchar(30) collate ascii_bin default NULL,
  `Member` varchar(4) collate ascii_bin default NULL,
  `CountryCode` varchar(5) collate ascii_bin default NULL,
  `RegionID` int(11) default NULL,
  `regionidprim` int(11) default NULL,
  `ConfID` varchar(40) collate ascii_bin default NULL,
  `CallOrigin` char(9) collate ascii_bin default NULL,
  `CallType` varchar(9) collate ascii_bin default NULL,
  `GWip` varchar(15) collate ascii_bin default NULL,
  `RxdCalledNumb` varchar(30) collate ascii_bin default NULL,
  `RxdCallingNumb` varchar(30) collate ascii_bin default NULL,
  `RemoteAddress` varchar(15) collate ascii_bin default NULL,
  `RemoteMedAddress` varchar(15) collate ascii_bin default NULL,
  `Username` varchar(30) collate ascii_bin default NULL,
  `NAStrunk` varchar(5) collate ascii_bin default NULL,
  `NASd` int(11) default NULL,
  `SessionTime` int(11) default NULL,
  `DisconnectCause` varchar(2) collate ascii_bin default NULL,
  `OutPackets` bigint(20) default NULL,
  `InPackets` bigint(20) default NULL,
  `OutOctets` bigint(20) default NULL,
  `InOctets` bigint(20) default NULL,
  `FinalCalledNumb` varchar(30) collate ascii_bin default NULL,
  `FinalCallingNumb` varchar(30) collate ascii_bin default NULL,
  `SetupSec` int(11) default NULL,
  `OctPackOut` int(11) default NULL,
  `OctPackIn` int(11) default NULL,
  `v_t` char(1) collate ascii_bin default NULL,
  `import_id` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'tempaccounting_outimport'
CREATE TABLE `tempaccounting_outimport` (
  `SetupDate` datetime default NULL,
  `SetupTime` datetime default NULL,
  `SetupTime2` int(11) default NULL,
  `ConnectTime` datetime default NULL,
  `DisconnectTime` datetime default NULL,
  `CallingID` varchar(30) collate ascii_bin default NULL,
  `CalledID` varchar(30) collate ascii_bin default NULL,
  `Member` varchar(4) collate ascii_bin default NULL,
  `CountryCode` varchar(5) collate ascii_bin default NULL,
  `RegionID` int(11) default NULL,
  `regionidprim` int(11) default NULL,
  `ConfID` varchar(40) collate ascii_bin default NULL,
  `CallOrigin` char(9) collate ascii_bin default NULL,
  `CallType` varchar(9) collate ascii_bin default NULL,
  `GWip` varchar(15) collate ascii_bin default NULL,
  `RxdCalledNumb` varchar(30) collate ascii_bin default NULL,
  `RxdCallingNumb` varchar(30) collate ascii_bin default NULL,
  `FinalCalledNumb` varchar(30) collate ascii_bin default NULL,
  `FinalCallingNumb` varchar(30) collate ascii_bin default NULL,
  `RemoteAddress` varchar(15) collate ascii_bin default NULL,
  `RemoteMedAddress` varchar(15) collate ascii_bin default NULL,
  `Username` varchar(30) collate ascii_bin default NULL,
  `NAStrunk` varchar(5) collate ascii_bin default NULL,
  `NASd` int(11) default NULL,
  `SessionTime` int(11) default NULL,
  `DisconnectCause` varchar(2) collate ascii_bin default NULL,
  `OutPackets` bigint(20) default NULL,
  `InPackets` bigint(20) default NULL,
  `OutOctets` bigint(20) default NULL,
  `InOctets` bigint(20) default NULL,
  `v_t` char(1) collate ascii_bin default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'tempaccounting_outimt'
CREATE TABLE `tempaccounting_outimt` (
  `SetupDate` datetime default NULL,
  `SetupTime` datetime default NULL,
  `SetupTime2` int(11) default NULL,
  `ConnectTime` datetime default NULL,
  `DisconnectTime` datetime default NULL,
  `CallingID` varchar(30) collate ascii_bin default NULL,
  `CalledID` varchar(30) collate ascii_bin default NULL,
  `Member` varchar(4) collate ascii_bin default NULL,
  `CountryCode` varchar(5) collate ascii_bin default NULL,
  `RegionID` int(11) default NULL,
  `regionidprim` int(11) default NULL,
  `ConfID` varchar(40) collate ascii_bin default NULL,
  `CallOrigin` char(9) collate ascii_bin default NULL,
  `CallType` varchar(9) collate ascii_bin default NULL,
  `GWip` varchar(15) collate ascii_bin default NULL,
  `RxdCalledNumb` varchar(30) collate ascii_bin default NULL,
  `RxdCallingNumb` varchar(30) collate ascii_bin default NULL,
  `FinalCalledNumb` varchar(30) collate ascii_bin default NULL,
  `FinalCallingNumb` varchar(30) collate ascii_bin default NULL,
  `RemoteAddress` varchar(15) collate ascii_bin default NULL,
  `RemoteMedAddress` varchar(15) collate ascii_bin default NULL,
  `Username` varchar(30) collate ascii_bin default NULL,
  `NAStrunk` varchar(5) collate ascii_bin default NULL,
  `NASd` int(11) default NULL,
  `SessionTime` int(11) default NULL,
  `DisconnectCause` varchar(2) collate ascii_bin default NULL,
  `OutPackets` bigint(20) default NULL,
  `InPackets` bigint(20) default NULL,
  `OutOctets` bigint(20) default NULL,
  `InOctets` bigint(20) default NULL,
  `v_t` char(1) collate ascii_bin default NULL
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'trunkgroup'
CREATE TABLE `trunkgroup` (
  `NAStrunk` varchar(10) collate ascii_bin NOT NULL,
  `TrunkGroup` int(11) default NULL,
  `TrunkDesc` varchar(50) collate ascii_bin default NULL,
  PRIMARY KEY  (`NAStrunk`)
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for VIEW 'accountgroup'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `accountgroup`
AS SELECT
   distinct `accounting_members`.`member_name` AS `AccountGroup`,concat(`accounting_members`.`member_name`,_ascii' In') AS `FullClient`
FROM `accounting_members` union select distinct `accounting_members`.`member_name` AS `AccountGroup`,concat(`accounting_members`.`member_name`,_ascii' Out') AS `FullClient` from `accounting_members`;

-- Create syntax for VIEW 'membersnickname'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `membersnickname`
AS SELECT
   distinct `members`.`Name` AS `Name`,
   `members`.`Nickname` AS `Nickname`,
   `members`.`Account Group` AS `Account Group`
FROM `members` where (`members`.`Name` is not null);

-- Create syntax for VIEW 'monitorin_client'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorin_client`
AS SELECT
   `b`.`PrimaryKey` AS `PrimaryKey`,
   `a`.`Name` AS `Name`,
   `country_prefix`.`Country` AS `Country`,
   `b`.`gateway` AS `gateway`,
   `a`.`Seizures` AS `Seizures`,
   `a`.`Completed` AS `Completed`,round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) AS `ASR`,(case `a`.`ASRmSeiz` when 0 then 0 else round(((100 * `a`.`Completed`) / `a`.`ASRmSeiz`),0) end) AS `ASRm`,(case when (`a`.`Completed` = 0) then NULL else round((`a`.`ConnectMin` / `a`.`Completed`),1) end) AS `ACD`,round(`a`.`ConnectMin`,0) AS `Minutes`,round(`a`.`Round30Min`,0) AS `BilledMin`,(round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) * round(((100 * `a`.`Completed`) / `a`.`Seizures`),0)) AS `TQI`,round((`a`.`SetupSec` / `a`.`Seizures`),1) AS `AnsDel`,round((`a`.`SetUpAdj` / `a`.`SetUpSeiz`),1) AS `AdjAnsDel`,round(((100 * `a`.`NormalD`) / `a`.`Seizures`),0) AS `NormalD`,round(((100 * `a`.`FailureD`) / `a`.`Seizures`),0) AS `FailureD`,round(((100 * `a`.`NoCircD`) / `a`.`Seizures`),0) AS `NoCircD`,round(((100 * `a`.`NoReqCircD`) / `a`.`Seizures`),0) AS `NoReqCircD`,round(((`a`.`SetupSec` / 60) + `a`.`ConnectMin`),1) AS `tCh`,round((`a`.`OutOctets` / 1000),1) AS `kOctetsXmt`,round((`a`.`InOctets` / 1000),1) AS `kOctetsRec`,
   `a`.`MaxTime` AS `MaxTime`,
   `a`.`Failed` AS `Failed`,
   `a`.`NormalD` AS `NormalDisc`,
   `a`.`FailureD` AS `FailureDisc`,
   `a`.`NoCircD` AS `NoCircDisc`,
   `a`.`NoReqCircD` AS `NoReqCircDisc`,
   `a`.`ASRmSeiz` AS `ASRmSeiz`,
   `a`.`GWip` AS `GWip`,
   `a`.`CallType` AS `CallType`,
   `a`.`AccountGroup` AS `AccountGroup`,round(((100 * `a`.`FSRseiz`) / `a`.`Seizures`),0) AS `FSR`,
   `a`.`FSRseiz` AS `FSRseiz`,
   `a`.`nickname` AS `nickname`
FROM (`monitorin_clientsub` `a` left join (`radiusdestinationsfinal` `b` left join `country_prefix` on((`b`.`country` like `country_prefix`.`Prefix`))) on(((convert(`a`.`GWNickname` using utf8) like `b`.`gateway`) and (convert(`a`.`Name` using utf8) like `b`.`name`) and (convert(`a`.`CountryCode` using utf8) like `b`.`country`)))) order by `b`.`PrimaryKey`;


-- Create syntax for VIEW 'monitorin_clientsub'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorin_clientsub`
AS SELECT
   max(`a`.`MaxTime`) AS `MaxTime`,sum(`a`.`SetupSec`) AS `SetupSec`,sum(`a`.`ConnectMin`) AS `ConnectMin`,sum(`a`.`Round30Min`) AS `Round30Min`,
   `a`.`CallType` AS `CallType`,
   `a`.`GWNickname` AS `GWip`,sum(`a`.`OutOctets`) AS `OutOctets`,sum(`a`.`InOctets`) AS `InOctets`,sum(`a`.`Completed`) AS `Completed`,_utf8'000' AS `CountryCode`,
   `a`.`Member` AS `Member`,sum(`a`.`OutPackets`) AS `OutPackets`,sum(`a`.`InPackets`) AS `InPackets`,sum(`a`.`SetUpAdj`) AS `SetUpAdj`,sum(`a`.`SetUpSeiz`) AS `SetUpSeiz`,sum(`a`.`Round6Min`) AS `Round6Min`,
   `a`.`Name` AS `Name`,sum(`a`.`Seizures`) AS `Seizures`,sum(`a`.`NormalD`) AS `NormalD`,sum(`a`.`FailureD`) AS `FailureD`,sum(`a`.`FSRseiz`) AS `FSRseiz`,sum(`a`.`NoCircD`) AS `NoCircD`,sum(`a`.`NoReqCircD`) AS `NoReqCircD`,_utf8'\'' AS `Blank`,
   `a`.`GWNickname` AS `GWNickname`,sum(`a`.`ASRmSeiz`) AS `ASRmSeiz`,sum(`a`.`Failed`) AS `Failed`,
   `a`.`AccountGroup` AS `AccountGroup`,
   `a`.`nickname` AS `nickname`
FROM `monitorin_table` `a` group by `a`.`CallType`,`a`.`Member`,`a`.`Name`,`a`.`GWNickname`,`a`.`AccountGroup`,`a`.`nickname` having (not((`AccountGroup` like _ascii'IMT'))) order by `a`.`Name`,`a`.`GWNickname`;

-- Create syntax for VIEW 'monitorin_clientsub_test'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorin_clientsub_test`
AS SELECT
   max(`a`.`MaxTime`) AS `MaxTime`,sum(`a`.`SetupSec`) AS `SetupSec`,sum(`a`.`ConnectMin`) AS `ConnectMin`,sum(`a`.`Round30Min`) AS `Round30Min`,
   `a`.`CallType` AS `CallType`,
   `a`.`GWNickname` AS `GWip`,sum(`a`.`OutOctets`) AS `OutOctets`,sum(`a`.`InOctets`) AS `InOctets`,sum(`a`.`Completed`) AS `Completed`,_utf8'000' AS `CountryCode`,
   `a`.`Member` AS `Member`,sum(`a`.`OutPackets`) AS `OutPackets`,sum(`a`.`InPackets`) AS `InPackets`,sum(`a`.`SetUpAdj`) AS `SetUpAdj`,sum(`a`.`SetUpSeiz`) AS `SetUpSeiz`,sum(`a`.`Round6Min`) AS `Round6Min`,
   `a`.`Name` AS `Name`,sum(`a`.`Seizures`) AS `Seizures`,sum(`a`.`NormalD`) AS `NormalD`,sum(`a`.`FailureD`) AS `FailureD`,sum(`a`.`FSRseiz`) AS `FSRseiz`,sum(`a`.`NoCircD`) AS `NoCircD`,sum(`a`.`NoReqCircD`) AS `NoReqCircD`,_utf8'\'' AS `Blank`,
   `a`.`GWNickname` AS `GWNickname`,sum(`a`.`ASRmSeiz`) AS `ASRmSeiz`,sum(`a`.`Failed`) AS `Failed`,
   `a`.`AccountGroup` AS `AccountGroup`,
   `a`.`nickname` AS `nickname`
FROM `monitorin_table` `a` group by `a`.`CallType`,`a`.`Member`,`a`.`Name`,`a`.`GWNickname`,`a`.`AccountGroup`,`a`.`nickname` having (not((`AccountGroup` like _ascii'IMT'))) order by `a`.`Name`,`a`.`GWNickname`;


-- Create syntax for VIEW 'monitorin_country'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorin_country`
AS SELECT
   `b`.`PrimaryKey` AS `PrimaryKey`,
   `a`.`Name` AS `Name`,
   `country_prefix`.`Country` AS `Country`,
   `b`.`gateway` AS `gateway`,
   `a`.`Seizures` AS `Seizures`,
   `a`.`Completed` AS `Completed`,(case when (`a`.`Seizures` = 0) then NULL else round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) end) AS `ASR`,
   (case `a`.`ASRmSeiz` when 0 then 0 else round(((100 * `a`.`Completed`) / `a`.`ASRmSeiz`),0) end) AS `ASRm`,
   (case when (`a`.`Completed` = 0) then NULL else round((`a`.`ConnectMin` / `a`.`Completed`),1) end) AS `ACD`,
   round(`a`.`ConnectMin`,0) AS `Minutes`,
   round(`a`.`Round30Min`,0) AS `BilledMin`,
   (case when (`a`.`Seizures` = 0) then NULL else (round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) * round(((100 * `a`.`Completed`) / `a`.`Seizures`),0)) end) AS `TQI`,
   round((`a`.`SetupSec` / `a`.`Seizures`),1) AS `AnsDel`,
   round((`a`.`SetUpAdj` / `a`.`SetUpSeiz`),1) AS `AdjAnsDel`,
   round(((100 * `a`.`NormalD`) / `a`.`Seizures`),0) AS `NormalD`,
   round(((100 * `a`.`FailureD`) / `a`.`Seizures`),0) AS `FailureD`,
   round(((100 * `a`.`NoCircD`) / `a`.`Seizures`),0) AS `NoCircD`,
   round(((100 * `a`.`NoReqCircD`) / `a`.`Seizures`),0) AS `NoReqCircD`,
   round(((`a`.`SetupSec` / 60) + `a`.`ConnectMin`),1) AS `tCh`,
   round((`a`.`OutOctets` / 1000),1) AS `kOctetsXmt`,
   round((`a`.`InOctets` / 1000),1) AS `kOctetsRec`,
   `a`.`MaxTime` AS `MaxTime`,
   `a`.`Failed` AS `Failed`,
   `a`.`NormalD` AS `NormalDisc`,
   `a`.`FailureD` AS `FailureDisc`,
   `a`.`NoCircD` AS `NoCircDisc`,
   `a`.`NoReqCircD` AS `NoReqCircDisc`,
   `a`.`ASRmSeiz` AS `ASRmSeiz`,
   `a`.`GWip` AS `GWip`,
   `a`.`CallType` AS `CallType`,
   `a`.`AccountGroup` AS `AccountGroup`,
   `a`.`nickname` AS `nickname`,(case when (`a`.`Seizures` = 0) then NULL else round(((100 * `a`.`FSRseiz`) / `a`.`Seizures`),0) end) AS `FSR`,
   `a`.`FSRseiz` AS `FSRSeiz`
FROM ((`monitorin_countrysub` `a` left join `country_prefix` on((convert(`a`.`CountryCode` using utf8) = `country_prefix`.`Prefix`))) left join `radiusdestinationsfinal` `b` on(((`b`.`gateway` = convert(`a`.`GWNickname` using utf8)) and (`b`.`name` = convert(`a`.`Name` using utf8)) and (`b`.`country` = convert(`a`.`CountryCode` using utf8))))) where (`a`.`Seizures` > 0) order by `b`.`PrimaryKey`;



-- Create syntax for VIEW 'monitorin_countrysub'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorin_countrysub`
AS SELECT
   max(`a`.`MaxTime`) AS `MaxTime`,sum(`a`.`SetupSec`) AS `SetupSec`,
   sum(`a`.`ConnectMin`) AS `ConnectMin`,
   sum(`a`.`Round30Min`) AS `Round30Min`,
   `a`.`CallType` AS `CallType`,
   `a`.`GWNickname` AS `GWip`,sum(`a`.`OutOctets`) AS `OutOctets`,
   sum(`a`.`InOctets`) AS `InOctets`,
   sum(`a`.`Completed`) AS `Completed`,
   `a`.`CountryCode` AS `CountryCode`,
   `a`.`Member` AS `Member`,
   sum(`a`.`OutPackets`) AS `OutPackets`,
   sum(`a`.`InPackets`) AS `InPackets`,
   sum(`a`.`SetUpAdj`) AS `SetUpAdj`,
   sum(`a`.`SetUpSeiz`) AS `SetUpSeiz`,
   sum(`a`.`Round6Min`) AS `Round6Min`,
   `a`.`Name` AS `Name`,
   sum(`a`.`Seizures`) AS `Seizures`,
   sum(`a`.`NormalD`) AS `NormalD`,
   sum(`a`.`FailureD`) AS `FailureD`,
   sum(`a`.`FSRseiz`) AS `FSRseiz`,
   sum(`a`.`NoCircD`) AS `NoCircD`,
   sum(`a`.`NoReqCircD`) AS `NoReqCircD`,_utf8'\'' AS `Blank`,
   `a`.`GWNickname` AS `GWNickname`,
   sum(`a`.`ASRmSeiz`) AS `ASRmSeiz`,
   sum(`a`.`Failed`) AS `Failed`,
   `a`.`AccountGroup` AS `AccountGroup`,
   `a`.`nickname` AS `nickname`,
   `a`.`v_t` AS `v_t`
FROM `monitorin_table` `a` group by `a`.`CallType`,`a`.`Member`,`a`.`Name`,`a`.`GWNickname`,`a`.`AccountGroup`,`a`.`nickname`,`a`.`CountryCode`,`a`.`v_t` having (not((`AccountGroup` like _ascii'IMT')));


-- Create syntax for VIEW 'monitorin_gw'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorin_gw`
AS SELECT
   `b`.`PrimaryKey` AS `PrimaryKey`,
   `a`.`Name` AS `Name`,
   `country_prefix`.`Country` AS `Country`,
   `b`.`gateway` AS `gateway`,
   `a`.`Seizures` AS `Seizures`,
   `a`.`Completed` AS `Completed`,round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) AS `ASR`,(case `a`.`ASRmSeiz` when 0 then 0 else round(((100 * `a`.`Completed`) / `a`.`ASRmSeiz`),0) end) AS `ASRm`,(case when (`a`.`Completed` = 0) then NULL else round((`a`.`ConnectMin` / `a`.`Completed`),1) end) AS `ACD`,round(`a`.`ConnectMin`,0) AS `Minutes`,round(`a`.`Round30Min`,0) AS `BilledMin`,(round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) * round(((100 * `a`.`Completed`) / `a`.`Seizures`),0)) AS `TQI`,round((`a`.`SetupSec` / `a`.`Seizures`),1) AS `AnsDel`,round((`a`.`SetUpAdj` / `a`.`SetUpSeiz`),1) AS `AdjAnsDel`,round(((100 * `a`.`NormalD`) / `a`.`Seizures`),0) AS `NormalD`,round(((100 * `a`.`FailureD`) / `a`.`Seizures`),0) AS `FailureD`,round(((100 * `a`.`NoCircD`) / `a`.`Seizures`),0) AS `NoCircD`,round(((100 * `a`.`NoReqCircD`) / `a`.`Seizures`),0) AS `NoReqCircD`,round(((`a`.`SetupSec` / 60) + `a`.`ConnectMin`),1) AS `tCh`,round((`a`.`OutOctets` / 1000),1) AS `kOctetsXmt`,round((`a`.`InOctets` / 1000),1) AS `kOctetsRec`,
   `a`.`MaxTime` AS `MaxTime`,
   `a`.`Failed` AS `Failed`,
   `a`.`NormalD` AS `NormalDisc`,
   `a`.`FailureD` AS `FailureDisc`,
   `a`.`NoCircD` AS `NoCircDisc`,
   `a`.`NoReqCircD` AS `NoReqCircDisc`,
   `a`.`ASRmSeiz` AS `ASRmSeiz`,
   `a`.`GWip` AS `GWip`,_utf8'\'' AS `CallType`,
   `a`.`AccountGroup` AS `AccountGroup`,
   `a`.`NickName` AS `nickname`,round(((100 * `a`.`FSRseiz`) / `a`.`Seizures`),0) AS `FSR`,
   `a`.`FSRseiz` AS `FSRseiz`
FROM (`monitorin_gwsub` `a` left join (`radiusdestinationsfinal` `b` left join `country_prefix` on((`b`.`country` = `country_prefix`.`Prefix`))) on(((convert(`a`.`CountryCode` using utf8) = `b`.`country`) and (convert(`a`.`Name` using utf8) = `b`.`name`) and (convert(`a`.`GWNickname` using utf8) = `b`.`gateway`)))) order by `b`.`PrimaryKey`;



-- Create syntax for VIEW 'monitorin_gwsub'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorin_gwsub`
AS SELECT
   max(`a`.`MaxTime`) AS `MaxTime`,sum(`a`.`SetupSec`) AS `SetupSec`,sum(`a`.`ConnectMin`) AS `ConnectMin`,sum(`a`.`Round30Min`) AS `Round30Min`,
   `a`.`GWip` AS `GWip`,sum(`a`.`OutOctets`) AS `OutOctets`,sum(`a`.`InOctets`) AS `InOctets`,sum(`a`.`Completed`) AS `Completed`,_utf8'000' AS `CountryCode`,_utf8'Total' AS `Member`,sum(`a`.`OutPackets`) AS `OutPackets`,sum(`a`.`InPackets`) AS `InPackets`,sum(`a`.`SetUpAdj`) AS `SetUpAdj`,sum(`a`.`SetUpSeiz`) AS `SetUpSeiz`,sum(`a`.`Round6Min`) AS `Round6Min`,concat(`b`.`Type`,_ascii' Out') AS `Name`,sum(`a`.`Seizures`) AS `Seizures`,sum(`a`.`NormalD`) AS `NormalD`,sum(`a`.`FailureD`) AS `FailureD`,sum(`a`.`FSRseiz`) AS `FSRseiz`,sum(`a`.`NoCircD`) AS `NoCircD`,sum(`a`.`NoReqCircD`) AS `NoReqCircD`,_utf8'\'' AS `Blank`,right(`a`.`GWip`,3) AS `GWNickname`,sum(`a`.`ASRmSeiz`) AS `ASRmSeiz`,sum(`a`.`Failed`) AS `Failed`,
   `b`.`Type` AS `AccountGroup`,concat(`b`.`Type`,_ascii' Out') AS `NickName`
FROM (`monitorin_table` `a` left join `accounting_gateways` `b` on((`b`.`GWip` like `a`.`GWip`))) group by `a`.`GWip`,`a`.`GWNickname` order by `a`.`GWip`;




-- Create syntax for VIEW 'monitorin_totals'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorin_totals`
AS SELECT
   _utf8'614' AS `PrimaryKey`,
   `a`.`Name` AS `Name`,
   `a`.`NickName` AS `Nickname`,
   `a`.`CountryCode` AS `Country`,
   `a`.`GWNickname` AS `gateway`,
   `a`.`Seizures` AS `Seizures`,
   `a`.`Completed` AS `Completed`,round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) AS `ASR`,(case `a`.`ASRmSeiz` when 0 then 0 else round(((100 * `a`.`Completed`) / `a`.`ASRmSeiz`),0) end) AS `ASRm`,(case when (`a`.`Completed` = 0) then NULL else round((`a`.`ConnectMin` / `a`.`Completed`),0) end) AS `ACD`,round(`a`.`ConnectMin`,0) AS `Minutes`,round(`a`.`Round30Min`,0) AS `BilledMin`,(round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) * round(((100 * `a`.`Completed`) / `a`.`Seizures`),0)) AS `TQI`,round((`a`.`SetupSec` / `a`.`Seizures`),1) AS `AnsDel`,round((`a`.`SetUpAdj` / `a`.`SetUpSeiz`),1) AS `AdjAnsDel`,round(((100 * `a`.`NormalD`) / `a`.`Seizures`),0) AS `NormalD`,round(((100 * `a`.`FailureD`) / `a`.`Seizures`),0) AS `FailureD`,round(((100 * `a`.`NoCircD`) / `a`.`Seizures`),0) AS `NoCircD`,round(((100 * `a`.`NoReqCircD`) / `a`.`Seizures`),0) AS `NoReqCircD`,round(((`a`.`SetupSec` / 60) + `a`.`ConnectMin`),1) AS `tCh`,round((`a`.`OutOctets` / 1000),1) AS `kOctetsXmt`,round((`a`.`InOctets` / 1000),1) AS `kOctetsRec`,
   `a`.`MaxTime` AS `MaxTime`,
   `a`.`Failed` AS `Failed`,
   `a`.`NormalD` AS `NormalDisc`,
   `a`.`FailureD` AS `FailureDisc`,
   `a`.`NoCircD` AS `NoCircDisc`,
   `a`.`NoReqCircD` AS `NoReqCircDisc`,
   `a`.`ASRmSeiz` AS `ASRmSeiz`,
   `a`.`GWip` AS `GWip`,_utf8'\'' AS `CallType`,_utf8'Total' AS `AccountGroup`,round(((100 * `a`.`FSRseiz`) / `a`.`Seizures`),0) AS `FSR`,
   `a`.`FSRseiz` AS `FSRseiz`
FROM `monitorin_totalssub` `a`;


-- Create syntax for VIEW 'monitorin_totalssub'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorin_totalssub`
AS SELECT
   max(`a`.`MaxTime`) AS `MaxTime`,sum(`a`.`SetupSec`) AS `SetupSec`,sum(`a`.`ConnectMin`) AS `ConnectMin`,sum(`a`.`Round30Min`) AS `Round30Min`,_utf8'000.000.000.000' AS `GWip`,sum(`a`.`OutOctets`) AS `OutOctets`,sum(`a`.`InOctets`) AS `InOctets`,sum(`a`.`Completed`) AS `Completed`,_utf8'All' AS `CountryCode`,_utf8'Total' AS `Member`,sum(`a`.`OutPackets`) AS `OutPackets`,sum(`a`.`InPackets`) AS `InPackets`,sum(`a`.`SetUpAdj`) AS `SetUpAdj`,sum(`a`.`SetUpSeiz`) AS `SetUpSeiz`,sum(`a`.`Round6Min`) AS `Round6Min`,_utf8'Total Out' AS `Name`,sum(`a`.`Seizures`) AS `Seizures`,sum(`a`.`NormalD`) AS `NormalD`,sum(`a`.`FailureD`) AS `FailureD`,sum(`a`.`FSRseiz`) AS `FSRseiz`,sum(`a`.`NoCircD`) AS `NoCircD`,sum(`a`.`NoReqCircD`) AS `NoReqCircD`,_utf8'\'' AS `Blank`,_utf8'000' AS `GWNickname`,sum(`a`.`ASRmSeiz`) AS `ASRmSeiz`,sum(`a`.`Failed`) AS `Failed`,_utf8'Total Out' AS `NickName`
FROM `monitorin_table` `a`;


-- Create syntax for VIEW 'monitorin_view'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorin_view`
AS SELECT
   max(`a`.`DisconnectTime`) AS `MaxTime`,
   sum(`a`.`SetupSec`) AS `SetupSec`,
   sum((`a`.`SessionTime` / 60.0)) AS `ConnectMin`,
   sum((`a`.`Conn30Sec` / 60.0)) AS `Round30Min`,
   `a`.`CallType` AS `CallType`,
   `a`.`GWip` AS `GWip`,
   sum(`a`.`OutOctets`) AS `OutOctets`,
   sum(`a`.`InOctets`) AS `InOctets`,
   count((case when (`a`.`SessionTime` > 0) then `a`.`SetupTime` end)) AS `Completed`,
   `a`.`CountryCode` AS `CountryCode`,
   `a`.`Member` AS `Member`,
   sum(`a`.`OutPackets`) AS `OutPackets`,sum(`a`.`InPackets`) AS `InPackets`,
   sum((case when (`disconnecttext_master`.`ID` <> 34) then `a`.`SetupSec` end)) AS `SetUpAdj`,
   count((case when (`disconnecttext_master`.`ID` <> 34) then `a`.`SetupTime` end)) AS `SetUpSeiz`,
   sum((`a`.`Conn6Sec` / 60.0)) AS `Round6Min`,concat(`a`.`name`,_ascii' Out') AS `Name`,
   count(`a`.`SetupTime`) AS `Seizures`,
   count((case when (`disconnecttext_master`.`DisconnectGroup` = 1) then `a`.`SetupTime` end)) AS `NormalD`,
   count((case when (`disconnecttext_master`.`DisconnectGroup` = 4) then `a`.`SetupTime` end)) AS `FailureD`,
   count((case when ((`disconnecttext_master`.`DisconnectGroup` = 5) and (`disconnecttext_master`.`ID` <> 34)) then `a`.`SetupTime` end)) AS `FSRseiz`,
   count((case when (`disconnecttext_master`.`ID` = 34) then `a`.`SetupTime` end)) AS `NoCircD`,
   count((case when (`disconnecttext_master`.`ID` = 44) then `a`.`SetupTime` end)) AS `NoReqCircD`,_utf8'\'' AS `Blank`,
   `b`.`Type` AS `GWNickname`,
   count((case `disconnecttext_master`.`ASRmGroup` when 0 then `a`.`SetupTime` end)) AS `ASRmSeiz`,
   count((case when (`a`.`SessionTime` = 0) then `a`.`SetupTime` end)) AS `Failed`,
   `a`.`name` AS `AccountGroup`,concat(left(`a`.`name`,3),_ascii' Out') AS `nickname`,
   `a`.`v_t` AS `v_t`
FROM ((`tempaccounting_inmasterrev` `a` join `accounting_members` `b` on(((`b`.`member_ip` like (case when (`a`.`v_t` like _ascii'V') then `a`.`RemoteAddress` else `a`.`GWip` end)) and (`a`.`v_t` like `b`.`v_t`)))) left join `disconnecttext_master` on((`disconnecttext_master`.`IDh` like `a`.`DisconnectCause`))) group by `a`.`CallType`,`b`.`Type`,`a`.`GWip`,`a`.`CountryCode`,`a`.`Member`,concat(`a`.`name`,_ascii' Out'),concat(left(`a`.`name`,3),_ascii' Out'),`a`.`v_t`,`a`.`name` having ((not((`AccountGroup` like _ascii'IMT'))) and (not((`AccountGroup` like _ascii'IMC'))));


-- Create syntax for VIEW 'monitorout_client'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorout_client`
AS SELECT
   `b`.`PrimaryKey` AS `PrimaryKey`,
   `a`.`Name` AS `Name`,
   `country_prefix`.`Country` AS `Country`,
   `b`.`gateway` AS `gateway`,
   `a`.`Seizures` AS `Seizures`,
   `a`.`Completed` AS `Completed`,round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) AS `ASR`,(case `a`.`ASRmSeiz` when 0 then 0 else round(((100 * `a`.`Completed`) / `a`.`ASRmSeiz`),0) end) AS `ASRm`,(case when (`a`.`Completed` = 0) then NULL else round((`a`.`ConnectMin` / `a`.`Completed`),1) end) AS `ACD`,round(`a`.`ConnectMin`,0) AS `Minutes`,round(`a`.`Round30Min`,0) AS `BilledMin`,(round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) * round(((100 * `a`.`Completed`) / `a`.`Seizures`),0)) AS `TQI`,round((`a`.`SetupSec` / `a`.`Seizures`),1) AS `AnsDel`,round((`a`.`SetUpAdj` / `a`.`SetUpSeiz`),1) AS `AdjAnsDel`,round(((100 * `a`.`NormalD`) / `a`.`Seizures`),0) AS `NormalD`,round(((100 * `a`.`FailureD`) / `a`.`Seizures`),0) AS `FailureD`,round(((100 * `a`.`NoCircD`) / `a`.`Seizures`),0) AS `NoCircD`,round(((100 * `a`.`NoReqCircD`) / `a`.`Seizures`),0) AS `NoReqCircD`,round(((`a`.`SetupSec` / 60) + `a`.`ConnectMin`),1) AS `tCh`,round((`a`.`OutOctets` / 1000),1) AS `kOctetsXmt`,round((`a`.`InOctets` / 1000),1) AS `kOctetsRec`,
   `a`.`MaxTime` AS `MaxTime`,
   `a`.`Failed` AS `Failed`,
   `a`.`NormalD` AS `NormalDisc`,
   `a`.`FailureD` AS `FailureDisc`,
   `a`.`NoCircD` AS `NoCircDisc`,
   `a`.`NoReqCircD` AS `NoReqCircDisc`,
   `a`.`ASRmSeiz` AS `ASRmSeiz`,
   `a`.`GWip` AS `GWip`,
   `a`.`CallType` AS `CallType`,
   `a`.`AccountGroup` AS `AccountGroup`,round(((100 * `a`.`FSRseiz`) / `a`.`Seizures`),0) AS `FSR`,
   `a`.`FSRseiz` AS `FSRseiz`,
   `a`.`nickname` AS `nickname`
FROM (`monitorout_clientsub` `a` left join (`radiusdestinationsfinal` `b` left join `country_prefix` on((`b`.`country` like `country_prefix`.`Prefix`))) on(((convert(`a`.`GWNickname` using utf8) like `b`.`gateway`) and (convert(`a`.`Name` using utf8) like `b`.`name`) and (convert(`a`.`CountryCode` using utf8) like `b`.`country`)))) order by `b`.`PrimaryKey`;


-- Create syntax for VIEW 'monitorout_clientsub'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorout_clientsub`
AS SELECT
   max(`a`.`MaxTime`) AS `MaxTime`,sum(`a`.`SetupSec`) AS `SetupSec`,sum(`a`.`ConnectMin`) AS `ConnectMin`,sum(`a`.`Round30Min`) AS `Round30Min`,
   `a`.`CallType` AS `CallType`,
   `a`.`GWNickname` AS `GWip`,sum(`a`.`OutOctets`) AS `OutOctets`,sum(`a`.`InOctets`) AS `InOctets`,sum(`a`.`Completed`) AS `Completed`,_utf8'000' AS `CountryCode`,
   `a`.`Member` AS `Member`,sum(`a`.`OutPackets`) AS `OutPackets`,sum(`a`.`InPackets`) AS `InPackets`,sum(`a`.`SetUpAdj`) AS `SetUpAdj`,sum(`a`.`SetUpSeiz`) AS `SetUpSeiz`,sum(`a`.`Round6Min`) AS `Round6Min`,
   `a`.`Name` AS `Name`,sum(`a`.`Seizures`) AS `Seizures`,sum(`a`.`NormalD`) AS `NormalD`,sum(`a`.`FailureD`) AS `FailureD`,sum(`a`.`FSRseiz`) AS `FSRseiz`,sum(`a`.`NoCircD`) AS `NoCircD`,sum(`a`.`NoReqCircD`) AS `NoReqCircD`,_utf8'\'' AS `Blank`,
   `a`.`GWNickname` AS `GWNickname`,sum(`a`.`ASRmSeiz`) AS `ASRmSeiz`,sum(`a`.`Failed`) AS `Failed`,
   `a`.`AccountGroup` AS `AccountGroup`,
   `a`.`nickname` AS `nickname`
FROM `monitorout_table` `a` group by `a`.`CallType`,`a`.`Member`,`a`.`Name`,`a`.`GWNickname`,`a`.`AccountGroup`,`a`.`nickname` having (not((`AccountGroup` like _ascii'IMT'))) order by `a`.`Name`,`a`.`GWNickname`;

-- Create syntax for VIEW 'monitorout_country'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorout_country`
AS SELECT
   `b`.`PrimaryKey` AS `PrimaryKey`,
   `a`.`Name` AS `Name`,
   `country_prefix`.`Country` AS `Country`,
   `b`.`gateway` AS `gateway`,
   `a`.`Seizures` AS `Seizures`,
   `a`.`Completed` AS `Completed`,(case when (`a`.`Seizures` = 0) then NULL else round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) end) AS `ASR`,(case `a`.`ASRmSeiz` when 0 then 0 else round(((100 * `a`.`Completed`) / `a`.`ASRmSeiz`),0) end) AS `ASRm`,(case when (`a`.`Completed` = 0) then NULL else round((`a`.`ConnectMin` / `a`.`Completed`),1) end) AS `ACD`,round(`a`.`ConnectMin`,0) AS `Minutes`,round(`a`.`Round30Min`,0) AS `BilledMin`,(case when (`a`.`Seizures` = 0) then NULL else (round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) * round(((100 * `a`.`Completed`) / `a`.`Seizures`),0)) end) AS `TQI`,round((`a`.`SetupSec` / `a`.`Seizures`),1) AS `AnsDel`,round((`a`.`SetUpAdj` / `a`.`SetUpSeiz`),1) AS `AdjAnsDel`,round(((100 * `a`.`NormalD`) / `a`.`Seizures`),0) AS `NormalD`,round(((100 * `a`.`FailureD`) / `a`.`Seizures`),0) AS `FailureD`,round(((100 * `a`.`NoCircD`) / `a`.`Seizures`),0) AS `NoCircD`,round(((100 * `a`.`NoReqCircD`) / `a`.`Seizures`),0) AS `NoReqCircD`,round(((`a`.`SetupSec` / 60) + `a`.`ConnectMin`),1) AS `tCh`,round((`a`.`OutOctets` / 1000),1) AS `kOctetsXmt`,round((`a`.`InOctets` / 1000),1) AS `kOctetsRec`,
   `a`.`MaxTime` AS `MaxTime`,
   `a`.`Failed` AS `Failed`,
   `a`.`NormalD` AS `NormalDisc`,
   `a`.`FailureD` AS `FailureDisc`,
   `a`.`NoCircD` AS `NoCircDisc`,
   `a`.`NoReqCircD` AS `NoReqCircDisc`,
   `a`.`ASRmSeiz` AS `ASRmSeiz`,
   `a`.`GWip` AS `GWip`,
   `a`.`CallType` AS `CallType`,
   `a`.`AccountGroup` AS `AccountGroup`,
   `a`.`nickname` AS `nickname`,(case when (`a`.`Seizures` = 0) then NULL else round(((100 * `a`.`FSRseiz`) / `a`.`Seizures`),0) end) AS `FSR`,
   `a`.`FSRseiz` AS `FSRSeiz`
FROM ((`monitorout_countrysub` `a` left join `country_prefix` on((convert(`a`.`CountryCode` using utf8) = `country_prefix`.`Prefix`))) left join `radiusdestinationsfinal` `b` on(((`b`.`gateway` = convert(`a`.`GWNickname` using utf8)) and (`b`.`name` = convert(`a`.`Name` using utf8)) and (`b`.`country` = convert(`a`.`CountryCode` using utf8))))) where (`a`.`Seizures` > 0) order by `b`.`PrimaryKey`;


-- Create syntax for VIEW 'monitorout_countrysub'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorout_countrysub`
AS SELECT
   max(`a`.`MaxTime`) AS `MaxTime`,sum(`a`.`SetupSec`) AS `SetupSec`,sum(`a`.`ConnectMin`) AS `ConnectMin`,sum(`a`.`Round30Min`) AS `Round30Min`,
   `a`.`CallType` AS `CallType`,
   `a`.`GWNickname` AS `GWip`,sum(`a`.`OutOctets`) AS `OutOctets`,sum(`a`.`InOctets`) AS `InOctets`,sum(`a`.`Completed`) AS `Completed`,
   `a`.`CountryCode` AS `CountryCode`,
   `a`.`Member` AS `Member`,sum(`a`.`OutPackets`) AS `OutPackets`,sum(`a`.`InPackets`) AS `InPackets`,sum(`a`.`SetUpAdj`) AS `SetUpAdj`,sum(`a`.`SetUpSeiz`) AS `SetUpSeiz`,sum(`a`.`Round6Min`) AS `Round6Min`,
   `a`.`Name` AS `Name`,sum(`a`.`Seizures`) AS `Seizures`,sum(`a`.`NormalD`) AS `NormalD`,sum(`a`.`FailureD`) AS `FailureD`,sum(`a`.`FSRseiz`) AS `FSRseiz`,sum(`a`.`NoCircD`) AS `NoCircD`,sum(`a`.`NoReqCircD`) AS `NoReqCircD`,_utf8'\'' AS `Blank`,
   `a`.`GWNickname` AS `GWNickname`,sum(`a`.`ASRmSeiz`) AS `ASRmSeiz`,sum(`a`.`Failed`) AS `Failed`,
   `a`.`AccountGroup` AS `AccountGroup`,
   `a`.`nickname` AS `nickname`,
   `a`.`v_t` AS `v_t`
FROM `monitorout_table` `a` group by `a`.`CallType`,`a`.`Member`,`a`.`Name`,`a`.`GWNickname`,`a`.`AccountGroup`,`a`.`nickname`,`a`.`CountryCode`,`a`.`v_t` having (not((`AccountGroup` like _ascii'IMT')));

-- Create syntax for VIEW 'monitorout_gw'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorout_gw`
AS SELECT
   `b`.`PrimaryKey` AS `PrimaryKey`,
   `a`.`Name` AS `Name`,
   `country_prefix`.`Country` AS `Country`,
   `b`.`gateway` AS `gateway`,
   `a`.`Seizures` AS `Seizures`,
   `a`.`Completed` AS `Completed`,round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) AS `ASR`,(case `a`.`ASRmSeiz` when 0 then 0 else round(((100 * `a`.`Completed`) / `a`.`ASRmSeiz`),0) end) AS `ASRm`,(case when (`a`.`Completed` = 0) then NULL else round((`a`.`ConnectMin` / `a`.`Completed`),1) end) AS `ACD`,round(`a`.`ConnectMin`,0) AS `Minutes`,round(`a`.`Round30Min`,0) AS `BilledMin`,(round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) * round(((100 * `a`.`Completed`) / `a`.`Seizures`),0)) AS `TQI`,round((`a`.`SetupSec` / `a`.`Seizures`),1) AS `AnsDel`,round((`a`.`SetUpAdj` / `a`.`SetUpSeiz`),1) AS `AdjAnsDel`,round(((100 * `a`.`NormalD`) / `a`.`Seizures`),0) AS `NormalD`,round(((100 * `a`.`FailureD`) / `a`.`Seizures`),0) AS `FailureD`,round(((100 * `a`.`NoCircD`) / `a`.`Seizures`),0) AS `NoCircD`,round(((100 * `a`.`NoReqCircD`) / `a`.`Seizures`),0) AS `NoReqCircD`,round(((`a`.`SetupSec` / 60) + `a`.`ConnectMin`),1) AS `tCh`,round((`a`.`OutOctets` / 1000),1) AS `kOctetsXmt`,round((`a`.`InOctets` / 1000),1) AS `kOctetsRec`,
   `a`.`MaxTime` AS `MaxTime`,
   `a`.`Failed` AS `Failed`,
   `a`.`NormalD` AS `NormalDisc`,
   `a`.`FailureD` AS `FailureDisc`,
   `a`.`NoCircD` AS `NoCircDisc`,
   `a`.`NoReqCircD` AS `NoReqCircDisc`,
   `a`.`ASRmSeiz` AS `ASRmSeiz`,
   `a`.`GWip` AS `GWip`,_utf8'\'' AS `CallType`,
   `a`.`AccountGroup` AS `AccountGroup`,
   `a`.`NickName` AS `nickname`,round(((100 * `a`.`FSRseiz`) / `a`.`Seizures`),0) AS `FSR`,
   `a`.`FSRseiz` AS `FSRseiz`
FROM (`monitorout_gwsub` `a` left join (`radiusdestinationsfinal` `b` left join `country_prefix` on((`b`.`country` = `country_prefix`.`Prefix`))) on(((convert(`a`.`CountryCode` using utf8) = `b`.`country`) and (convert(`a`.`Name` using utf8) = `b`.`name`) and (convert(`a`.`GWNickname` using utf8) = `b`.`gateway`)))) order by `b`.`PrimaryKey`;

-- Create syntax for VIEW 'monitorout_gwsub'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorout_gwsub`
AS SELECT
   max(`a`.`MaxTime`) AS `MaxTime`,sum(`a`.`SetupSec`) AS `SetupSec`,sum(`a`.`ConnectMin`) AS `ConnectMin`,sum(`a`.`Round30Min`) AS `Round30Min`,
   `a`.`GWip` AS `GWip`,sum(`a`.`OutOctets`) AS `OutOctets`,sum(`a`.`InOctets`) AS `InOctets`,sum(`a`.`Completed`) AS `Completed`,_utf8'000' AS `CountryCode`,_utf8'Total' AS `Member`,sum(`a`.`OutPackets`) AS `OutPackets`,sum(`a`.`InPackets`) AS `InPackets`,sum(`a`.`SetUpAdj`) AS `SetUpAdj`,sum(`a`.`SetUpSeiz`) AS `SetUpSeiz`,sum(`a`.`Round6Min`) AS `Round6Min`,concat(`b`.`Type`,_ascii' In') AS `Name`,sum(`a`.`Seizures`) AS `Seizures`,sum(`a`.`NormalD`) AS `NormalD`,sum(`a`.`FailureD`) AS `FailureD`,sum(`a`.`FSRseiz`) AS `FSRseiz`,sum(`a`.`NoCircD`) AS `NoCircD`,sum(`a`.`NoReqCircD`) AS `NoReqCircD`,_utf8'\'' AS `Blank`,right(`a`.`GWip`,3) AS `GWNickname`,sum(`a`.`ASRmSeiz`) AS `ASRmSeiz`,sum(`a`.`Failed`) AS `Failed`,
   `b`.`Type` AS `AccountGroup`,concat(`b`.`Type`,_ascii' In') AS `NickName`
FROM (`monitorout_table` `a` left join `accounting_gateways` `b` on((`b`.`GWip` like `a`.`GWip`))) group by `a`.`GWip` order by `a`.`GWip`;


-- Create syntax for VIEW 'monitorout_totals'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorout_totals`
AS SELECT
   _utf8'614' AS `PrimaryKey`,
   `a`.`Name` AS `Name`,
   `a`.`NickName` AS `Nickname`,
   `a`.`CountryCode` AS `Country`,
   `a`.`GWNickname` AS `gateway`,
   `a`.`Seizures` AS `Seizures`,
   `a`.`Completed` AS `Completed`,round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) AS `ASR`,(case `a`.`ASRmSeiz` when 0 then 0 else round(((100 * `a`.`Completed`) / `a`.`ASRmSeiz`),0) end) AS `ASRm`,(case when (`a`.`Completed` = 0) then NULL else round((`a`.`ConnectMin` / `a`.`Completed`),0) end) AS `ACD`,round(`a`.`ConnectMin`,0) AS `Minutes`,round(`a`.`Round30Min`,0) AS `BilledMin`,(round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) * round(((100 * `a`.`Completed`) / `a`.`Seizures`),0)) AS `TQI`,round((`a`.`SetupSec` / `a`.`Seizures`),1) AS `AnsDel`,round((`a`.`SetUpAdj` / `a`.`SetUpSeiz`),1) AS `AdjAnsDel`,round(((100 * `a`.`NormalD`) / `a`.`Seizures`),0) AS `NormalD`,round(((100 * `a`.`FailureD`) / `a`.`Seizures`),0) AS `FailureD`,round(((100 * `a`.`NoCircD`) / `a`.`Seizures`),0) AS `NoCircD`,round(((100 * `a`.`NoReqCircD`) / `a`.`Seizures`),0) AS `NoReqCircD`,round(((`a`.`SetupSec` / 60) + `a`.`ConnectMin`),1) AS `tCh`,round((`a`.`OutOctets` / 1000),1) AS `kOctetsXmt`,round((`a`.`InOctets` / 1000),1) AS `kOctetsRec`,
   `a`.`MaxTime` AS `MaxTime`,
   `a`.`Failed` AS `Failed`,
   `a`.`NormalD` AS `NormalDisc`,
   `a`.`FailureD` AS `FailureDisc`,
   `a`.`NoCircD` AS `NoCircDisc`,
   `a`.`NoReqCircD` AS `NoReqCircDisc`,
   `a`.`ASRmSeiz` AS `ASRmSeiz`,
   `a`.`GWip` AS `GWip`,_utf8'\'' AS `CallType`,_utf8'Total' AS `AccountGroup`,round(((100 * `a`.`FSRseiz`) / `a`.`Seizures`),0) AS `FSR`,
   `a`.`FSRseiz` AS `FSRseiz`
FROM `monitorout_totalssub` `a`;

-- Create syntax for VIEW 'monitorout_totals2'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorout_totals2`
AS SELECT
   _utf8'614' AS `PrimaryKey`,
   `a`.`Name` AS `Name`,
   `a`.`NickName` AS `Nickname`,
   `a`.`CountryCode` AS `Country`,
   `a`.`GWNickname` AS `gateway`,
   `a`.`Seizures` AS `Seizures`,
   `a`.`Completed` AS `Completed`,round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) AS `ASR`,(case `a`.`ASRmSeiz` when 0 then 0 else round(((100 * `a`.`Completed`) / `a`.`ASRmSeiz`),0) end) AS `ASRm`,(case when (`a`.`Completed` = 0) then NULL else round((`a`.`ConnectMin` / `a`.`Completed`),0) end) AS `ACD`,round(`a`.`ConnectMin`,0) AS `Minutes`,round(`a`.`Round30Min`,0) AS `BilledMin`,(round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) * round(((100 * `a`.`Completed`) / `a`.`Seizures`),0)) AS `TQI`,round((`a`.`SetupSec` / `a`.`Seizures`),1) AS `AnsDel`,round((`a`.`SetUpAdj` / `a`.`SetUpSeiz`),1) AS `AdjAnsDel`,round(((100 * `a`.`NormalD`) / `a`.`Seizures`),0) AS `NormalD`,round(((100 * `a`.`FailureD`) / `a`.`Seizures`),0) AS `FailureD`,round(((100 * `a`.`NoCircD`) / `a`.`Seizures`),0) AS `NoCircD`,round(((100 * `a`.`NoReqCircD`) / `a`.`Seizures`),0) AS `NoReqCircD`,round(((`a`.`SetupSec` / 60) + `a`.`ConnectMin`),1) AS `tCh`,round((`a`.`OutOctets` / 1000),1) AS `kOctetsXmt`,round((`a`.`InOctets` / 1000),1) AS `kOctetsRec`,
   `a`.`MaxTime` AS `MaxTime`,
   `a`.`Failed` AS `Failed`,
   `a`.`NormalD` AS `NormalDisc`,
   `a`.`FailureD` AS `FailureDisc`,
   `a`.`NoCircD` AS `NoCircDisc`,
   `a`.`NoReqCircD` AS `NoReqCircDisc`,
   `a`.`ASRmSeiz` AS `ASRmSeiz`,
   `a`.`GWip` AS `GWip`,_utf8'\'' AS `CallType`,_utf8'Total' AS `AccountGroup`,round(((100 * `a`.`FSRseiz`) / `a`.`Seizures`),0) AS `FSR`,
   `a`.`FSRseiz` AS `FSRseiz`
FROM `monitorout_totalssub2` `a`;

-- Create syntax for VIEW 'monitorout_totalssub'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorout_totalssub`
AS SELECT
   max(`a`.`MaxTime`) AS `MaxTime`,sum(`a`.`SetupSec`) AS `SetupSec`,sum(`a`.`ConnectMin`) AS `ConnectMin`,sum(`a`.`Round30Min`) AS `Round30Min`,_utf8'000.000.000.000' AS `GWip`,sum(`a`.`OutOctets`) AS `OutOctets`,sum(`a`.`InOctets`) AS `InOctets`,sum(`a`.`Completed`) AS `Completed`,_utf8'All' AS `CountryCode`,_utf8'Total' AS `Member`,sum(`a`.`OutPackets`) AS `OutPackets`,sum(`a`.`InPackets`) AS `InPackets`,sum(`a`.`SetUpAdj`) AS `SetUpAdj`,sum(`a`.`SetUpSeiz`) AS `SetUpSeiz`,sum(`a`.`Round6Min`) AS `Round6Min`,_utf8'Total In' AS `Name`,sum(`a`.`Seizures`) AS `Seizures`,sum(`a`.`NormalD`) AS `NormalD`,sum(`a`.`FailureD`) AS `FailureD`,sum(`a`.`FSRseiz`) AS `FSRseiz`,sum(`a`.`NoCircD`) AS `NoCircD`,sum(`a`.`NoReqCircD`) AS `NoReqCircD`,_utf8'\'' AS `Blank`,_utf8'000' AS `GWNickname`,sum(`a`.`ASRmSeiz`) AS `ASRmSeiz`,sum(`a`.`Failed`) AS `Failed`,_utf8'Total In' AS `NickName`
FROM `monitorout_table` `a`;

-- Create syntax for VIEW 'monitorout_view'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monitorout_view`
AS SELECT
   max(`a`.`DisconnectTime`) AS `MaxTime`,sum(`a`.`SetupSec`) AS `SetupSec`,sum((`a`.`SessionTime` / 60.0)) AS `ConnectMin`,sum((`a`.`Conn30Sec` / 60.0)) AS `Round30Min`,
   `a`.`CallType` AS `CallType`,
   `a`.`GWip` AS `GWip`,sum(`a`.`OutOctets`) AS `OutOctets`,sum(`a`.`InOctets`) AS `InOctets`,count((case when (`a`.`SessionTime` > 0) then `a`.`SetupTime` end)) AS `Completed`,
   `a`.`CountryCode` AS `CountryCode`,
   `a`.`Member` AS `Member`,sum(`a`.`OutPackets`) AS `OutPackets`,sum(`a`.`InPackets`) AS `InPackets`,sum((case when (`disconnecttext_master`.`ID` <> 34) then `a`.`SetupSec` end)) AS `SetUpAdj`,count((case when (`disconnecttext_master`.`ID` <> 34) then `a`.`SetupTime` end)) AS `SetUpSeiz`,sum((`a`.`Conn6Sec` / 60.0)) AS `Round6Min`,concat(`a`.`name`,_ascii' In') AS `Name`,count(`a`.`SetupTime`) AS `Seizures`,count((case when (`disconnecttext_master`.`DisconnectGroup` = 1) then `a`.`SetupTime` end)) AS `NormalD`,count((case when (`disconnecttext_master`.`DisconnectGroup` = 4) then `a`.`SetupTime` end)) AS `FailureD`,count((case when ((`disconnecttext_master`.`DisconnectGroup` = 5) and (`disconnecttext_master`.`ID` <> 34)) then `a`.`SetupTime` end)) AS `FSRseiz`,count((case when (`disconnecttext_master`.`ID` = 34) then `a`.`SetupTime` end)) AS `NoCircD`,count((case when (`disconnecttext_master`.`ID` = 44) then `a`.`SetupTime` end)) AS `NoReqCircD`,_utf8'\'' AS `Blank`,
   `b`.`Type` AS `GWNickname`,count((case `disconnecttext_master`.`ASRmGroup` when 0 then `a`.`SetupTime` end)) AS `ASRmSeiz`,count((case when (`a`.`SessionTime` = 0) then `a`.`SetupTime` end)) AS `Failed`,
   `a`.`name` AS `AccountGroup`,concat(left(`a`.`name`,3),_ascii' In') AS `nickname`,
   `a`.`v_t` AS `v_t`
FROM ((`tempaccounting_outmasterrev` `a` join `accounting_members` `b` on(((`b`.`member_ip` like (case when (`a`.`v_t` like _ascii'V') then `a`.`RemoteAddress` else `a`.`GWip` end)) and (`a`.`v_t` like `b`.`v_t`)))) left join `disconnecttext_master` on((`disconnecttext_master`.`IDh` like `a`.`DisconnectCause`))) group by `a`.`CallType`,`b`.`Type`,`a`.`GWip`,`a`.`CountryCode`,`a`.`Member`,concat(`a`.`name`,_ascii' In'),concat(left(`a`.`name`,3),_ascii' In'),`a`.`v_t`,`a`.`name` having ((not((`AccountGroup` like _ascii'IMT'))) and (not((`AccountGroup` like _ascii'IMC'))));


-- Create syntax for VIEW 'radiusdataarchivemaxid'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `radiusdataarchivemaxid`
AS SELECT
   max(`radiusdataarchive`.`import_id`) AS `MaxOfimport_id`
FROM `radiusdataarchive`;

-- Create syntax for VIEW 'radiusinregion'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `radiusinregion`
AS SELECT
   `a`.`name` AS `Name`,
   `country_prefix`.`Country` AS `Country`,
   `a`.`Region` AS `Region`,
   `a`.`mobile_proper` AS `mobile_proper`,
   `a`.`GWNickname` AS `gateway`,
   `a`.`Seizures` AS `Seizures`,
   `a`.`Completed` AS `Completed`,round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) AS `ASR`,(case `a`.`ASRmSeiz` when 0 then 0 else round(((100 * `a`.`Completed`) / `a`.`ASRmSeiz`),0) end) AS `ASRm`,(case when (`a`.`Completed` = 0) then NULL else round((`a`.`ConnectMin` / `a`.`Completed`),1) end) AS `ACD`,round(`a`.`ConnectMin`,0) AS `Minutes`,round(`a`.`Round30Min`,0) AS `BilledMin`,(round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) * round(((100 * `a`.`Completed`) / `a`.`Seizures`),0)) AS `TQI`,round((`a`.`SetupSec` / `a`.`Seizures`),1) AS `AnsDel`,round((`a`.`SetUpAdj` / `a`.`SetUpSeiz`),1) AS `AdjAnsDel`,round(((100 * `a`.`NormalD`) / `a`.`Seizures`),0) AS `NormalD`,round(((100 * `a`.`FailureD`) / `a`.`Seizures`),0) AS `FailureD`,round(((100 * `a`.`NoCircD`) / `a`.`Seizures`),0) AS `NoCircD`,round(((100 * `a`.`NoReqCircD`) / `a`.`Seizures`),0) AS `NoReqCircD`,round(((`a`.`SetupSec` / 60) + `a`.`ConnectMin`),1) AS `tCh`,round((`a`.`OutOctets` / 1000),1) AS `kOctetsXmt`,round((`a`.`InOctets` / 1000),1) AS `kOctetsRec`,
   `a`.`MaxTime` AS `MaxTime`,
   `a`.`Failed` AS `Failed`,
   `a`.`NormalD` AS `NormalDisc`,
   `a`.`FailureD` AS `FailureDisc`,
   `a`.`NoCircD` AS `NoCircDisc`,
   `a`.`NoReqCircD` AS `NoReqCircDisc`,
   `a`.`ASRmSeiz` AS `ASRmSeiz`,
   `a`.`GWip` AS `GWip`,
   `a`.`TrunkGroup` AS `TrunkGroup`,
   `a`.`CallType` AS `CallType`,
   `a`.`AccountGroup` AS `AccountGroup`,round(((100 * `a`.`FSRseiz`) / `a`.`Seizures`),0) AS `FSR`,
   `a`.`FSRseiz` AS `FSRSeiz`,
   `a`.`regionidprim` AS `regionidprim`,
   `a`.`nickname` AS `nickname`
FROM (`radiusinregionsub` `a` join `country_prefix` on((convert(`a`.`CountryCode` using utf8) = `country_prefix`.`Prefix`)));

-- Create syntax for VIEW 'radiusinregionsub'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `radiusinregionsub`
AS SELECT
   max(`a`.`DisconnectTime`) AS `MaxTime`,sum(`a`.`SetupSec`) AS `SetupSec`,sum((`a`.`SessionTime` / 60.0)) AS `ConnectMin`,sum((`a`.`Conn30Sec` / 60.0)) AS `Round30Min`,
   `a`.`CallType` AS `CallType`,
   `a`.`GWip` AS `GWip`,sum(`a`.`OutOctets`) AS `OutOctets`,sum(`a`.`InOctets`) AS `InOctets`,count((case when (`a`.`SessionTime` > 0) then `a`.`SetupTime` end)) AS `Completed`,
   `a`.`CountryCode` AS `CountryCode`,
   `a`.`Member` AS `Member`,sum(`a`.`OutPackets`) AS `OutPackets`,sum(`a`.`InPackets`) AS `InPackets`,sum((case when (`disconnecttext_master`.`ID` <> 34) then `a`.`SetupSec` end)) AS `SetUpAdj`,count((case when (`disconnecttext_master`.`ID` <> 34) then `a`.`SetupTime` end)) AS `SetUpSeiz`,sum((`a`.`Conn6Sec` / 60.0)) AS `Round6Min`,(case when (`a`.`GWip` like _ascii'213.132.233.%') then `trunkgroup`.`TrunkGroup` end) AS `TrunkGroup`,concat(`a`.`name`,_ascii' Out') AS `name`,concat(left(`a`.`name`,3),_ascii' Out') AS `nickname`,count(`a`.`SetupTime`) AS `Seizures`,count((case when (`disconnecttext_master`.`DisconnectGroup` = 1) then `a`.`SetupTime` end)) AS `NormalD`,count((case when (`disconnecttext_master`.`DisconnectGroup` = 4) then `a`.`SetupTime` end)) AS `FailureD`,count((case when ((`disconnecttext_master`.`DisconnectGroup` = 5) and (`disconnecttext_master`.`ID` <> 34)) then `a`.`SetupTime` end)) AS `FSRseiz`,count((case when (`disconnecttext_master`.`ID` = 34) then `a`.`SetupTime` end)) AS `NoCircD`,count((case when (`disconnecttext_master`.`ID` = 44) then `a`.`SetupTime` end)) AS `NoReqCircD`,_utf8'\'' AS `Blank`,right(`a`.`GWip`,3) AS `GWNickname`,count((case `disconnecttext_master`.`ASRmGroup` when 0 then `a`.`SetupTime` end)) AS `ASRmSeiz`,count((case when (`a`.`SessionTime` = 0) then `a`.`SetupTime` end)) AS `Failed`,
   `a`.`name` AS `AccountGroup`,
   `accounting_region`.`RegionName` AS `Region`,
   `accounting_region`.`mobile_proper` AS `mobile_proper`,
   `a`.`regionidprim` AS `regionidprim`
FROM ((((`tempaccounting_inmasterrev` `a` left join `accounting_region` on((`a`.`regionidprim` = `accounting_region`.`RegionID`))) left join `pots_ip` on((`a`.`CallType` = `pots_ip`.`CallType`))) left join `trunkgroup` on((`a`.`NAStrunk` = `trunkgroup`.`NAStrunk`))) left join `disconnecttext_master` on((`a`.`DisconnectCause` = `disconnecttext_master`.`IDh`))) group by `a`.`CallType`,`a`.`GWip`,`a`.`CountryCode`,`a`.`Member`,(case when (`a`.`GWip` like _ascii'213.132.233.%') then `trunkgroup`.`TrunkGroup` end),`a`.`name`,right(`a`.`GWip`,3),`a`.`name`,`accounting_region`.`RegionName`,`accounting_region`.`mobile_proper`,`a`.`regionidprim` order by `a`.`CountryCode`,`a`.`Member`,concat(`a`.`name`,_ascii' Out'),`a`.`GWip`;


-- Create syntax for VIEW 'radiusoutregion'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `radiusoutregion`
AS SELECT
   `a`.`name` AS `Name`,
   `country_prefix`.`Country` AS `Country`,
   `a`.`Region` AS `Region`,
   `a`.`mobile_proper` AS `mobile_proper`,
   `a`.`GWNickname` AS `gateway`,
   `a`.`Seizures` AS `Seizures`,
   `a`.`Completed` AS `Completed`,round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) AS `ASR`,(case `a`.`ASRmSeiz` when 0 then 0 else round(((100 * `a`.`Completed`) / `a`.`ASRmSeiz`),0) end) AS `ASRm`,(case when (`a`.`Completed` = 0) then NULL else round((`a`.`ConnectMin` / `a`.`Completed`),1) end) AS `ACD`,round(`a`.`ConnectMin`,0) AS `Minutes`,round(`a`.`Round30Min`,0) AS `BilledMin`,(round(((100 * `a`.`Completed`) / `a`.`Seizures`),0) * round(((100 * `a`.`Completed`) / `a`.`Seizures`),0)) AS `TQI`,round((`a`.`SetupSec` / `a`.`Seizures`),1) AS `AnsDel`,round((`a`.`SetUpAdj` / `a`.`SetUpSeiz`),1) AS `AdjAnsDel`,round(((100 * `a`.`NormalD`) / `a`.`Seizures`),0) AS `NormalD`,round(((100 * `a`.`FailureD`) / `a`.`Seizures`),0) AS `FailureD`,round(((100 * `a`.`NoCircD`) / `a`.`Seizures`),0) AS `NoCircD`,round(((100 * `a`.`NoReqCircD`) / `a`.`Seizures`),0) AS `NoReqCircD`,round(((`a`.`SetupSec` / 60) + `a`.`ConnectMin`),1) AS `tCh`,round((`a`.`OutOctets` / 1000),1) AS `kOctetsXmt`,round((`a`.`InOctets` / 1000),1) AS `kOctetsRec`,
   `a`.`MaxTime` AS `MaxTime`,
   `a`.`Failed` AS `Failed`,
   `a`.`NormalD` AS `NormalDisc`,
   `a`.`FailureD` AS `FailureDisc`,
   `a`.`NoCircD` AS `NoCircDisc`,
   `a`.`NoReqCircD` AS `NoReqCircDisc`,
   `a`.`ASRmSeiz` AS `ASRmSeiz`,
   `a`.`GWip` AS `GWip`,
   `a`.`TrunkGroup` AS `TrunkGroup`,
   `a`.`CallType` AS `CallType`,
   `a`.`AccountGroup` AS `AccountGroup`,round(((100 * `a`.`FSRseiz`) / `a`.`Seizures`),0) AS `FSR`,
   `a`.`FSRseiz` AS `FSRSeiz`,
   `a`.`regionidprim` AS `regionidprim`,
   `a`.`nickname` AS `nickname`
FROM (`radiusoutregionsub` `a` join `country_prefix` on((convert(`a`.`CountryCode` using utf8) = `country_prefix`.`Prefix`)));


-- Create syntax for VIEW 'radiusoutregionsub'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `radiusoutregionsub`
AS SELECT
   max(`a`.`DisconnectTime`) AS `MaxTime`,sum(`a`.`SetupSec`) AS `SetupSec`,sum((`a`.`SessionTime` / 60.0)) AS `ConnectMin`,sum((`a`.`Conn30Sec` / 60.0)) AS `Round30Min`,
   `a`.`CallType` AS `CallType`,
   `a`.`GWip` AS `GWip`,sum(`a`.`OutOctets`) AS `OutOctets`,sum(`a`.`InOctets`) AS `InOctets`,count((case when (`a`.`SessionTime` > 0) then `a`.`SetupTime` end)) AS `Completed`,
   `a`.`CountryCode` AS `CountryCode`,
   `a`.`Member` AS `Member`,sum(`a`.`OutPackets`) AS `OutPackets`,sum(`a`.`InPackets`) AS `InPackets`,sum((case when (`disconnecttext_master`.`ID` <> 34) then `a`.`SetupSec` end)) AS `SetUpAdj`,count((case when (`disconnecttext_master`.`ID` <> 34) then `a`.`SetupTime` end)) AS `SetUpSeiz`,sum((`a`.`Conn6Sec` / 60.0)) AS `Round6Min`,(case when (`a`.`GWip` like _ascii'213.132.233.%') then `trunkgroup`.`TrunkGroup` end) AS `TrunkGroup`,concat(`a`.`name`,_ascii' In') AS `name`,concat(left(`a`.`name`,3),_ascii' In') AS `nickname`,count(`a`.`SetupTime`) AS `Seizures`,count((case when (`disconnecttext_master`.`DisconnectGroup` = 1) then `a`.`SetupTime` end)) AS `NormalD`,count((case when (`disconnecttext_master`.`DisconnectGroup` = 4) then `a`.`SetupTime` end)) AS `FailureD`,count((case when ((`disconnecttext_master`.`DisconnectGroup` = 5) and (`disconnecttext_master`.`ID` <> 34)) then `a`.`SetupTime` end)) AS `FSRseiz`,count((case when (`disconnecttext_master`.`ID` = 34) then `a`.`SetupTime` end)) AS `NoCircD`,count((case when (`disconnecttext_master`.`ID` = 44) then `a`.`SetupTime` end)) AS `NoReqCircD`,_utf8'\'' AS `Blank`,right(`a`.`GWip`,3) AS `GWNickname`,count((case `disconnecttext_master`.`ASRmGroup` when 0 then `a`.`SetupTime` end)) AS `ASRmSeiz`,count((case when (`a`.`SessionTime` = 0) then `a`.`SetupTime` end)) AS `Failed`,
   `a`.`name` AS `AccountGroup`,
   `accounting_region`.`RegionName` AS `Region`,
   `accounting_region`.`mobile_proper` AS `mobile_proper`,
   `a`.`regionidprim` AS `regionidprim`
FROM ((((`tempaccounting_outmasterrev` `a` left join `accounting_region` on((`a`.`regionidprim` = `accounting_region`.`RegionID`))) left join `pots_ip` on((`a`.`CallType` = `pots_ip`.`CallType`))) left join `trunkgroup` on((`a`.`NAStrunk` = `trunkgroup`.`NAStrunk`))) left join `disconnecttext_master` on((`a`.`DisconnectCause` = `disconnecttext_master`.`IDh`))) group by `a`.`CallType`,`a`.`GWip`,`a`.`CountryCode`,`a`.`Member`,(case when (`a`.`GWip` like _ascii'213.132.233.%') then `trunkgroup`.`TrunkGroup` end),`a`.`name`,right(`a`.`GWip`,3),`a`.`name`,`accounting_region`.`RegionName`,`accounting_region`.`mobile_proper`,`a`.`regionidprim` order by `a`.`CountryCode`,`a`.`Member`,concat(`a`.`name`,_ascii' In'),`a`.`GWip`;


-- Create syntax for VIEW 'tempaccounting_inmasterdisconnect'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tempaccounting_inmasterdisconnect`
AS SELECT
   `tempaccounting_in`.`SetupDate` AS `SetupDate`,
   `tempaccounting_in`.`SetupTime` AS `SetupTime`,
   `tempaccounting_in`.`SetupTime2` AS `SetupTime2`,
   `tempaccounting_in`.`ConnectTime` AS `ConnectTime`,
   `tempaccounting_in`.`DisconnectTime` AS `DisconnectTime`,
   `tempaccounting_in`.`CallingID` AS `CallingID`,
   `tempaccounting_in`.`CalledID` AS `CalledID`,
   `tempaccounting_in`.`Member` AS `Member`,
   `tempaccounting_in`.`CountryCode` AS `CountryCode`,
   `tempaccounting_in`.`RegionID` AS `RegionID`,
   `tempaccounting_in`.`regionidprim` AS `regionidprim`,
   `tempaccounting_in`.`ConfID` AS `ConfID`,
   `tempaccounting_in`.`CallOrigin` AS `CallOrigin`,
   `tempaccounting_in`.`CallType` AS `CallType`,
   `tempaccounting_in`.`GWip` AS `GWip`,
   `tempaccounting_in`.`RxdCalledNumb` AS `RxdCalledNumb`,
   `tempaccounting_in`.`RxdCallingNumb` AS `RxdCallingNumb`,(case when (isnull(`tempaccounting_in`.`RemoteAddress`) and (`tempaccounting_in`.`CallType` = _ascii'VoIP')) then `tempaccounting_in`.`Username` else `tempaccounting_in`.`RemoteAddress` end) AS `RemoteAddress`,
   `tempaccounting_in`.`RemoteMedAddress` AS `RemoteMedAddress`,
   `tempaccounting_in`.`Username` AS `Username`,
   `tempaccounting_in`.`NAStrunk` AS `NAStrunk`,
   `tempaccounting_in`.`NASd` AS `NASd`,(case when isnull(`tempaccounting_in`.`SessionTime`) then 0 else `tempaccounting_in`.`SessionTime` end) AS `SessionTime`,
   `tempaccounting_in`.`DisconnectCause` AS `DisconnectCause`,
   `tempaccounting_in`.`OutPackets` AS `OutPackets`,
   `tempaccounting_in`.`InPackets` AS `InPackets`,
   `tempaccounting_in`.`OutOctets` AS `OutOctets`,
   `tempaccounting_in`.`InOctets` AS `InOctets`,time_to_sec(timediff(`tempaccounting_in`.`SetupTime`,
   `tempaccounting_in`.`ConnectTime`)) AS `SetupSec`,(case when (`tempaccounting_in`.`OutPackets` = 0) then NULL else (`tempaccounting_in`.`OutOctets` / `tempaccounting_in`.`OutPackets`) end) AS `OctPackOut`,(case when (`tempaccounting_in`.`InPackets` = 0) then NULL else (`tempaccounting_in`.`InOctets` / `tempaccounting_in`.`InPackets`) end) AS `OctPackIn`,
   `tempaccounting_in`.`v_t` AS `v_t`
FROM `tempaccounting_in` group by `tempaccounting_in`.`CalledID`,`tempaccounting_in`.`Member`,`tempaccounting_in`.`CountryCode`,`tempaccounting_in`.`RegionID`,`tempaccounting_in`.`regionidprim`,`tempaccounting_in`.`ConfID`,`tempaccounting_in`.`CallOrigin`,`tempaccounting_in`.`CallType`,`tempaccounting_in`.`GWip`,`tempaccounting_in`.`RxdCalledNumb`,`tempaccounting_in`.`RxdCallingNumb`,`tempaccounting_in`.`NAStrunk`,`tempaccounting_in`.`NASd`,`tempaccounting_in`.`DisconnectCause`,`tempaccounting_in`.`OutPackets`,`tempaccounting_in`.`InPackets`,`tempaccounting_in`.`OutOctets`,`tempaccounting_in`.`InOctets`,`tempaccounting_in`.`SetupTime`,`tempaccounting_in`.`SetupTime2`,`tempaccounting_in`.`ConnectTime`,`tempaccounting_in`.`DisconnectTime`,`tempaccounting_in`.`Username`,`tempaccounting_in`.`RemoteAddress`,`tempaccounting_in`.`RemoteMedAddress`,`tempaccounting_in`.`CallingID`,`tempaccounting_in`.`SessionTime`,`tempaccounting_in`.`SetupDate`,`tempaccounting_in`.`v_t` order by `tempaccounting_in`.`SetupDate`,`tempaccounting_in`.`SetupTime`,`tempaccounting_in`.`SetupTime2`;

-- Create syntax for VIEW 'tempaccounting_inmasterimt'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tempaccounting_inmasterimt`
AS SELECT
   `tempaccounting_inimt`.`SetupDate` AS `SetupDate`,
   `tempaccounting_inimt`.`SetupTime` AS `SetupTime`,
   `tempaccounting_inimt`.`SetupTime2` AS `SetupTime2`,
   `tempaccounting_inimt`.`ConnectTime` AS `ConnectTime`,
   `tempaccounting_inimt`.`DisconnectTime` AS `DisconnectTime`,
   `tempaccounting_inimt`.`CallingID` AS `CallingID`,
   `tempaccounting_inimt`.`CalledID` AS `CalledID`,
   `tempaccounting_inimt`.`Member` AS `Member`,
   `tempaccounting_inimt`.`CountryCode` AS `CountryCode`,
   `tempaccounting_inimt`.`RegionID` AS `RegionID`,
   `tempaccounting_inimt`.`regionidprim` AS `regionidprim`,
   `tempaccounting_inimt`.`ConfID` AS `ConfID`,
   `tempaccounting_inimt`.`CallOrigin` AS `CallOrigin`,
   `tempaccounting_inimt`.`CallType` AS `CallType`,
   `tempaccounting_inimt`.`GWip` AS `GWip`,
   `tempaccounting_inimt`.`RxdCalledNumb` AS `RxdCalledNumb`,
   `tempaccounting_inimt`.`RxdCallingNumb` AS `RxdCallingNumb`,(case when (isnull(`tempaccounting_inimt`.`RemoteAddress`) and (`tempaccounting_inimt`.`CallType` = _ascii'VoIP')) then `tempaccounting_inimt`.`Username` else `tempaccounting_inimt`.`RemoteAddress` end) AS `RemoteAddress`,
   `tempaccounting_inimt`.`RemoteMedAddress` AS `RemoteMedAddress`,
   `tempaccounting_inimt`.`Username` AS `Username`,
   `tempaccounting_inimt`.`NAStrunk` AS `NAStrunk`,
   `tempaccounting_inimt`.`NASd` AS `NASd`,(case when isnull(`tempaccounting_inimt`.`SessionTime`) then 0 else `tempaccounting_inimt`.`SessionTime` end) AS `SessionTime`,
   `tempaccounting_inimt`.`DisconnectCause` AS `DisconnectCause`,
   `tempaccounting_inimt`.`OutPackets` AS `OutPackets`,
   `tempaccounting_inimt`.`InPackets` AS `InPackets`,
   `tempaccounting_inimt`.`OutOctets` AS `OutOctets`,
   `tempaccounting_inimt`.`InOctets` AS `InOctets`,time_to_sec(timediff(`tempaccounting_inimt`.`SetupTime`,
   `tempaccounting_inimt`.`ConnectTime`)) AS `SetupSec`,(case when (`tempaccounting_inimt`.`OutPackets` = 0) then NULL else (`tempaccounting_inimt`.`OutOctets` / `tempaccounting_inimt`.`OutPackets`) end) AS `OctPackOut`,(case when (`tempaccounting_inimt`.`InPackets` = 0) then NULL else (`tempaccounting_inimt`.`InOctets` / `tempaccounting_inimt`.`InPackets`) end) AS `OctPackIn`,
   `tempaccounting_inimt`.`v_t` AS `v_t`
FROM `tempaccounting_inimt` group by `tempaccounting_inimt`.`CalledID`,`tempaccounting_inimt`.`Member`,`tempaccounting_inimt`.`CountryCode`,`tempaccounting_inimt`.`RegionID`,`tempaccounting_inimt`.`regionidprim`,`tempaccounting_inimt`.`ConfID`,`tempaccounting_inimt`.`CallOrigin`,`tempaccounting_inimt`.`CallType`,`tempaccounting_inimt`.`GWip`,`tempaccounting_inimt`.`RxdCalledNumb`,`tempaccounting_inimt`.`RxdCallingNumb`,`tempaccounting_inimt`.`NAStrunk`,`tempaccounting_inimt`.`NASd`,`tempaccounting_inimt`.`DisconnectCause`,`tempaccounting_inimt`.`OutPackets`,`tempaccounting_inimt`.`InPackets`,`tempaccounting_inimt`.`OutOctets`,`tempaccounting_inimt`.`InOctets`,`tempaccounting_inimt`.`SetupTime`,`tempaccounting_inimt`.`SetupTime2`,`tempaccounting_inimt`.`ConnectTime`,`tempaccounting_inimt`.`DisconnectTime`,`tempaccounting_inimt`.`Username`,`tempaccounting_inimt`.`RemoteAddress`,`tempaccounting_inimt`.`RemoteMedAddress`,`tempaccounting_inimt`.`CallingID`,`tempaccounting_inimt`.`SessionTime`,`tempaccounting_inimt`.`SetupDate`,`tempaccounting_inimt`.`v_t` order by `tempaccounting_inimt`.`SetupDate`,`tempaccounting_inimt`.`SetupTime`,`tempaccounting_inimt`.`SetupTime2`;

-- Create syntax for VIEW 'tempaccounting_inmastermaxsetup'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tempaccounting_inmastermaxsetup`
AS SELECT
   max(`tempaccounting_in`.`SetupTime`) AS `MaxSetupTime`,
   `tempaccounting_in`.`ConfID` AS `ConfID`,max(`tempaccounting_in`.`IDcol`) AS `MaxID`,
   `accounting_members`.`member_name` AS `Client`,
   `tempaccounting_in`.`GWip` AS `GWip`
FROM (`tempaccounting_in` left join `accounting_members` on(((`accounting_members`.`member_ip` like `tempaccounting_in`.`RemoteAddress`) and (`accounting_members`.`v_t` like `tempaccounting_in`.`v_t`)))) group by `tempaccounting_in`.`ConfID`,`accounting_members`.`member_name`,`tempaccounting_in`.`GWip`;

-- Create syntax for VIEW 'tempaccounting_inmasterrev'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tempaccounting_inmasterrev`
AS SELECT
   `a`.`SetupDate` AS `SetupDate`,
   `a`.`SetupTime` AS `SetupTime`,
   `a`.`SetupTime2` AS `SetupTime2`,
   `a`.`ConnectTime` AS `ConnectTime`,
   `a`.`DisconnectTime` AS `DisconnectTime`,
   `a`.`CallingID` AS `CallingID`,
   `a`.`CalledID` AS `CalledID`,
   `a`.`Member` AS `Member`,
   `a`.`CountryCode` AS `CountryCode`,
   `a`.`RegionID` AS `RegionID`,
   `a`.`regionidprim` AS `regionidprim`,
   `a`.`ConfID` AS `ConfID`,
   `a`.`CallOrigin` AS `CallOrigin`,
   `a`.`CallType` AS `CallType`,
   `a`.`GWip` AS `GWip`,
   `a`.`v_t` AS `v_t`,
   `a`.`RxdCalledNumb` AS `RxdCalledNumb`,
   `a`.`RxdCallingNumb` AS `RxdCallingNumb`,
   `a`.`RemoteAddress` AS `RemoteAddress`,
   `a`.`RemoteMedAddress` AS `RemoteMedAddress`,
   `a`.`Username` AS `Username`,
   `a`.`NAStrunk` AS `NAStrunk`,
   `a`.`NASd` AS `NASd`,(case when isnull(`a`.`SessionTime`) then 0 else `a`.`SessionTime` end) AS `SessionTime`,
   `a`.`DisconnectCause` AS `DisconnectCause`,
   `a`.`OutPackets` AS `OutPackets`,
   `a`.`InPackets` AS `InPackets`,
   `a`.`OutOctets` AS `OutOctets`,
   `a`.`InOctets` AS `InOctets`,(case when (`a`.`SessionTime` = 0) then 0 else (6 * round(((`a`.`SessionTime` / 6.000) + 0.499),0)) end) AS `Conn6Sec`,(case when ((`a`.`SessionTime` < 30) and (`a`.`SessionTime` > 0)) then 30 else (6 * round(((`a`.`SessionTime` / 6.000) + 0.499),0)) end) AS `Conn30Sec`,time_to_sec(timediff(`a`.`ConnectTime`,
   `a`.`SetupTime`)) AS `SetupSec`,(case when (`a`.`OutPackets` = 0) then NULL else (`a`.`OutOctets` / `a`.`OutPackets`) end) AS `OctPackOut`,(case when (`a`.`InPackets` = 0) then NULL else (`a`.`InOctets` / `a`.`InPackets`) end) AS `OctPackIn`,
   `accounting_members`.`member_name` AS `name`,
   `accounting_members`.`Type` AS `type`
FROM ((`tempaccounting_in` `a` join `tempaccounting_inmastermaxsetup` on((`a`.`IDcol` = `tempaccounting_inmastermaxsetup`.`MaxID`))) left join `accounting_members` on(((case when (`a`.`v_t` like _ascii'T') then `a`.`GWip` else `a`.`RemoteAddress` end) like `accounting_members`.`member_ip`))) order by `a`.`ConfID`,`a`.`SetupTime`;

-- Create syntax for VIEW 'tempaccounting_inpricesub'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tempaccounting_inpricesub`
AS SELECT
   distinct concat(`accounting_members`.`member_name`,_ascii' Out') AS `Name`,
   `tempaccounting_in`.`RemoteAddress` AS `remoteaddress`,
   `tempaccounting_in`.`v_t` AS `v_t`,
   `tempaccounting_in`.`regionidprim` AS `regionidprim`,
   `tempaccounting_in`.`SetupDate` AS `setupdate`
FROM (`tempaccounting_in` left join `accounting_members` on(((`accounting_members`.`member_ip` like `tempaccounting_in`.`RemoteAddress`) and (`accounting_members`.`v_t` like `tempaccounting_in`.`v_t`))));

-- Create syntax for VIEW 'tempaccounting_outmasterdisconnect'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tempaccounting_outmasterdisconnect`
AS SELECT
   `tempaccounting_out`.`SetupDate` AS `SetupDate`,
   `tempaccounting_out`.`SetupTime` AS `SetupTime`,
   `tempaccounting_out`.`SetupTime2` AS `SetupTime2`,
   `tempaccounting_out`.`ConnectTime` AS `ConnectTime`,
   `tempaccounting_out`.`DisconnectTime` AS `DisconnectTime`,
   `tempaccounting_out`.`CallingID` AS `CallingID`,
   `tempaccounting_out`.`CalledID` AS `CalledID`,
   `tempaccounting_out`.`Member` AS `Member`,
   `tempaccounting_out`.`CountryCode` AS `CountryCode`,
   `tempaccounting_out`.`RegionID` AS `RegionID`,
   `tempaccounting_out`.`regionidprim` AS `regionidprim`,
   `tempaccounting_out`.`ConfID` AS `ConfID`,
   `tempaccounting_out`.`CallOrigin` AS `CallOrigin`,
   `tempaccounting_out`.`CallType` AS `CallType`,
   `tempaccounting_out`.`GWip` AS `GWip`,
   `tempaccounting_out`.`RxdCalledNumb` AS `RxdCalledNumb`,
   `tempaccounting_out`.`RxdCallingNumb` AS `RxdCallingNumb`,(case when (isnull(`tempaccounting_out`.`RemoteAddress`) and (`tempaccounting_out`.`CallType` = _ascii'VoIP')) then `tempaccounting_out`.`Username` else `tempaccounting_out`.`RemoteAddress` end) AS `RemoteAddress`,
   `tempaccounting_out`.`RemoteMedAddress` AS `RemoteMedAddress`,
   `tempaccounting_out`.`Username` AS `Username`,
   `tempaccounting_out`.`NAStrunk` AS `NAStrunk`,
   `tempaccounting_out`.`NASd` AS `NASd`,(case when isnull(`tempaccounting_out`.`SessionTime`) then 0 else `tempaccounting_out`.`SessionTime` end) AS `SessionTime`,
   `tempaccounting_out`.`DisconnectCause` AS `DisconnectCause`,
   `tempaccounting_out`.`OutPackets` AS `OutPackets`,
   `tempaccounting_out`.`InPackets` AS `InPackets`,
   `tempaccounting_out`.`OutOctets` AS `OutOctets`,
   `tempaccounting_out`.`InOctets` AS `InOctets`,
   `tempaccounting_out`.`FinalCalledNumb` AS `FinalCalledNumb`,
   `tempaccounting_out`.`FinalCallingNumb` AS `FinalCallingNumb`,time_to_sec(timediff(`tempaccounting_out`.`SetupTime`,
   `tempaccounting_out`.`ConnectTime`)) AS `SetupSec`,(case when (`tempaccounting_out`.`OutPackets` = 0) then NULL else (`tempaccounting_out`.`OutOctets` / `tempaccounting_out`.`OutPackets`) end) AS `OctPackOut`,(case when (`tempaccounting_out`.`InPackets` = 0) then NULL else (`tempaccounting_out`.`InOctets` / `tempaccounting_out`.`InPackets`) end) AS `OctPackIn`,
   `tempaccounting_out`.`v_t` AS `v_t`
FROM `tempaccounting_out` group by `tempaccounting_out`.`CalledID`,`tempaccounting_out`.`Member`,`tempaccounting_out`.`CountryCode`,`tempaccounting_out`.`RegionID`,`tempaccounting_out`.`regionidprim`,`tempaccounting_out`.`ConfID`,`tempaccounting_out`.`CallOrigin`,`tempaccounting_out`.`CallType`,`tempaccounting_out`.`GWip`,`tempaccounting_out`.`RxdCalledNumb`,`tempaccounting_out`.`RxdCallingNumb`,`tempaccounting_out`.`NAStrunk`,`tempaccounting_out`.`NASd`,`tempaccounting_out`.`DisconnectCause`,`tempaccounting_out`.`OutPackets`,`tempaccounting_out`.`InPackets`,`tempaccounting_out`.`OutOctets`,`tempaccounting_out`.`InOctets`,`tempaccounting_out`.`SetupTime`,`tempaccounting_out`.`SetupTime2`,`tempaccounting_out`.`ConnectTime`,`tempaccounting_out`.`DisconnectTime`,`tempaccounting_out`.`Username`,`tempaccounting_out`.`RemoteAddress`,`tempaccounting_out`.`RemoteMedAddress`,`tempaccounting_out`.`CallingID`,`tempaccounting_out`.`SessionTime`,`tempaccounting_out`.`SetupDate`,`tempaccounting_out`.`FinalCalledNumb`,`tempaccounting_out`.`FinalCallingNumb`,`tempaccounting_out`.`v_t` order by `tempaccounting_out`.`SetupDate`,`tempaccounting_out`.`SetupTime`,`tempaccounting_out`.`SetupTime2`;

-- Create syntax for VIEW 'tempaccounting_outmasterimt'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tempaccounting_outmasterimt`
AS SELECT
   `tempaccounting_outimt`.`SetupDate` AS `SetupDate`,
   `tempaccounting_outimt`.`SetupTime` AS `SetupTime`,
   `tempaccounting_outimt`.`SetupTime2` AS `SetupTime2`,
   `tempaccounting_outimt`.`ConnectTime` AS `ConnectTime`,
   `tempaccounting_outimt`.`DisconnectTime` AS `DisconnectTime`,
   `tempaccounting_outimt`.`CallingID` AS `CallingID`,
   `tempaccounting_outimt`.`CalledID` AS `CalledID`,
   `tempaccounting_outimt`.`Member` AS `Member`,
   `tempaccounting_outimt`.`CountryCode` AS `CountryCode`,
   `tempaccounting_outimt`.`RegionID` AS `RegionID`,
   `tempaccounting_outimt`.`regionidprim` AS `regionidprim`,
   `tempaccounting_outimt`.`ConfID` AS `ConfID`,
   `tempaccounting_outimt`.`CallOrigin` AS `CallOrigin`,
   `tempaccounting_outimt`.`CallType` AS `CallType`,
   `tempaccounting_outimt`.`GWip` AS `GWip`,
   `tempaccounting_outimt`.`RxdCalledNumb` AS `RxdCalledNumb`,
   `tempaccounting_outimt`.`RxdCallingNumb` AS `RxdCallingNumb`,(case when (isnull(`tempaccounting_outimt`.`RemoteAddress`) and (`tempaccounting_outimt`.`CallType` = _ascii'VoIP')) then `tempaccounting_outimt`.`Username` else `tempaccounting_outimt`.`RemoteAddress` end) AS `RemoteAddress`,
   `tempaccounting_outimt`.`RemoteMedAddress` AS `RemoteMedAddress`,
   `tempaccounting_outimt`.`Username` AS `Username`,
   `tempaccounting_outimt`.`NAStrunk` AS `NAStrunk`,
   `tempaccounting_outimt`.`NASd` AS `NASd`,(case when isnull(`tempaccounting_outimt`.`SessionTime`) then 0 else `tempaccounting_outimt`.`SessionTime` end) AS `SessionTime`,
   `tempaccounting_outimt`.`DisconnectCause` AS `DisconnectCause`,
   `tempaccounting_outimt`.`OutPackets` AS `OutPackets`,
   `tempaccounting_outimt`.`InPackets` AS `InPackets`,
   `tempaccounting_outimt`.`OutOctets` AS `OutOctets`,
   `tempaccounting_outimt`.`InOctets` AS `InOctets`,
   `tempaccounting_outimt`.`FinalCalledNumb` AS `FinalCalledNumb`,
   `tempaccounting_outimt`.`FinalCallingNumb` AS `FinalCallingNumb`,time_to_sec(timediff(`tempaccounting_outimt`.`SetupTime`,
   `tempaccounting_outimt`.`ConnectTime`)) AS `SetupSec`,(case when (`tempaccounting_outimt`.`OutPackets` = 0) then NULL else (`tempaccounting_outimt`.`OutOctets` / `tempaccounting_outimt`.`OutPackets`) end) AS `OctPackOut`,(case when (`tempaccounting_outimt`.`InPackets` = 0) then NULL else (`tempaccounting_outimt`.`InOctets` / `tempaccounting_outimt`.`InPackets`) end) AS `OctPackIn`,
   `tempaccounting_outimt`.`v_t` AS `v_t`
FROM `tempaccounting_outimt` group by `tempaccounting_outimt`.`CalledID`,`tempaccounting_outimt`.`Member`,`tempaccounting_outimt`.`CountryCode`,`tempaccounting_outimt`.`RegionID`,`tempaccounting_outimt`.`regionidprim`,`tempaccounting_outimt`.`ConfID`,`tempaccounting_outimt`.`CallOrigin`,`tempaccounting_outimt`.`CallType`,`tempaccounting_outimt`.`GWip`,`tempaccounting_outimt`.`RxdCalledNumb`,`tempaccounting_outimt`.`RxdCallingNumb`,`tempaccounting_outimt`.`NAStrunk`,`tempaccounting_outimt`.`NASd`,`tempaccounting_outimt`.`DisconnectCause`,`tempaccounting_outimt`.`OutPackets`,`tempaccounting_outimt`.`InPackets`,`tempaccounting_outimt`.`OutOctets`,`tempaccounting_outimt`.`InOctets`,`tempaccounting_outimt`.`SetupTime`,`tempaccounting_outimt`.`SetupTime2`,`tempaccounting_outimt`.`ConnectTime`,`tempaccounting_outimt`.`DisconnectTime`,`tempaccounting_outimt`.`Username`,`tempaccounting_outimt`.`RemoteAddress`,`tempaccounting_outimt`.`RemoteMedAddress`,`tempaccounting_outimt`.`CallingID`,`tempaccounting_outimt`.`SessionTime`,`tempaccounting_outimt`.`SetupDate`,`tempaccounting_outimt`.`FinalCalledNumb`,`tempaccounting_outimt`.`FinalCallingNumb`,`tempaccounting_outimt`.`v_t` order by `tempaccounting_outimt`.`SetupDate`,`tempaccounting_outimt`.`SetupTime`,`tempaccounting_outimt`.`SetupTime2`;

-- Create syntax for VIEW 'tempaccounting_outmastermaxsetup'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tempaccounting_outmastermaxsetup`
AS SELECT
   max(`tempaccounting_out`.`SetupTime`) AS `MaxSetupTime`,
   `tempaccounting_out`.`ConfID` AS `ConfID`,max(`tempaccounting_out`.`IDcol`) AS `MaxID`,
   `accounting_members`.`member_name` AS `Client`,
   `tempaccounting_out`.`GWip` AS `GWip`
FROM (`tempaccounting_out` left join `accounting_members` on(((`accounting_members`.`member_ip` like `tempaccounting_out`.`RemoteAddress`) and (`accounting_members`.`v_t` like `tempaccounting_out`.`v_t`)))) group by `tempaccounting_out`.`ConfID`,`accounting_members`.`member_name`,`tempaccounting_out`.`GWip`;

-- Create syntax for VIEW 'tempaccounting_outmasterrev'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tempaccounting_outmasterrev`
AS SELECT
   `a`.`SetupDate` AS `SetupDate`,
   `a`.`SetupTime` AS `SetupTime`,
   `a`.`SetupTime2` AS `SetupTime2`,
   `a`.`ConnectTime` AS `ConnectTime`,
   `a`.`DisconnectTime` AS `DisconnectTime`,
   `a`.`CallingID` AS `CallingID`,
   `a`.`CalledID` AS `CalledID`,
   `a`.`Member` AS `Member`,
   `a`.`CountryCode` AS `CountryCode`,
   `a`.`RegionID` AS `RegionID`,
   `a`.`regionidprim` AS `regionidprim`,
   `a`.`ConfID` AS `ConfID`,
   `a`.`CallOrigin` AS `CallOrigin`,
   `a`.`CallType` AS `CallType`,
   `a`.`GWip` AS `GWip`,
   `a`.`v_t` AS `v_t`,
   `a`.`RxdCalledNumb` AS `RxdCalledNumb`,
   `a`.`RxdCallingNumb` AS `RxdCallingNumb`,
   `a`.`RemoteAddress` AS `RemoteAddress`,
   `a`.`RemoteMedAddress` AS `RemoteMedAddress`,
   `a`.`Username` AS `Username`,
   `a`.`NAStrunk` AS `NAStrunk`,
   `a`.`NASd` AS `NASd`,(case when isnull(`a`.`SessionTime`) then 0 else `a`.`SessionTime` end) AS `SessionTime`,
   `a`.`DisconnectCause` AS `DisconnectCause`,
   `a`.`OutPackets` AS `OutPackets`,
   `a`.`InPackets` AS `InPackets`,
   `a`.`OutOctets` AS `OutOctets`,
   `a`.`InOctets` AS `InOctets`,(case when (`a`.`SessionTime` = 0) then 0 else (6 * round(((`a`.`SessionTime` / 6.000) + 0.499),0)) end) AS `Conn6Sec`,(case when ((`a`.`SessionTime` < 30) and (`a`.`SessionTime` > 0)) then 30 else (6 * round(((`a`.`SessionTime` / 6.000) + 0.499),0)) end) AS `Conn30Sec`,time_to_sec(timediff(`a`.`ConnectTime`,
   `a`.`SetupTime`)) AS `SetupSec`,(case when (`a`.`OutPackets` = 0) then NULL else (`a`.`OutOctets` / `a`.`OutPackets`) end) AS `OctPackOut`,(case when (`a`.`InPackets` = 0) then NULL else (`a`.`InOctets` / `a`.`InPackets`) end) AS `OctPackIn`,
   `accounting_members`.`member_name` AS `name`,
   `accounting_members`.`Type` AS `type`
FROM ((`tempaccounting_out` `a` join `tempaccounting_outmastermaxsetup` on((`a`.`IDcol` = `tempaccounting_outmastermaxsetup`.`MaxID`))) left join `accounting_members` on(((case when (`a`.`v_t` like _ascii'T') then `a`.`GWip` else `a`.`RemoteAddress` end) like `accounting_members`.`member_ip`))) order by `a`.`ConfID`,`a`.`SetupTime`;

-- Create syntax for VIEW 'tempaccounting_outpricesub'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `tempaccounting_outpricesub`
AS SELECT
   distinct concat(`accounting_members`.`member_name`,_ascii' In') AS `Name`,
   `tempaccounting_out`.`RemoteAddress` AS `remoteaddress`,
   `tempaccounting_out`.`v_t` AS `v_t`,
   `tempaccounting_out`.`regionidprim` AS `regionidprim`,
   `tempaccounting_out`.`SetupDate` AS `setupdate`
FROM (`tempaccounting_out` left join `accounting_members` on(((`accounting_members`.`member_ip` like `tempaccounting_out`.`RemoteAddress`) and (`accounting_members`.`v_t` like `tempaccounting_out`.`v_t`))));


-- Create syntax for FUNCTION 'calc_rate'
CREATE DEFINER=`root`@`localhost` FUNCTION `calc_rate`( In_customer VARCHAR(50) , In_regionid int , In_setupdate  datetime) RETURNS float
    DETERMINISTIC
BEGIN

    DECLARE returnVal  float;

    SELECT CASE WHEN price IS NULL THEN 0 ELSE Price END AS price INTO returnVal FROM Accounting_Price WHERE RegionID=In_regionid and Customer like In_customer and Effective_Date=(select max(Effective_Date) from Accounting_Price where RegionID=In_regionid and Customer like In_customer and Effective_Date <= In_setupdate );

RETURN returnVal;

   END;

-- Create syntax for FUNCTION 'calc_regionnamemon'
CREATE DEFINER=`root`@`localhost` FUNCTION `calc_regionnamemon`( In_regionid int ) RETURNS varchar(50) CHARSET utf8
Return (SELECT regionname

FROM accounting_region

WHERE regionid=in_regionid);
