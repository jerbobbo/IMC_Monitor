-- Create syntax for TABLE 'accounting_cdr'
CREATE TABLE `accounting_cdr` (
  `batch_num` int(11) unsigned NOT NULL,
  `setup_time` datetime NOT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime DEFAULT NULL,
  `disconnect_cause` int(11) DEFAULT NULL,
  `origin_calling_numb` varchar(32) DEFAULT NULL,
  `origin_called_numb` varchar(32) DEFAULT NULL,
  `origin_in_packets` int(11) unsigned NOT NULL,
  `origin_out_packets` int(11) unsigned NOT NULL,
  `origin_in_octets` int(11) unsigned NOT NULL,
  `origin_out_octets` int(11) unsigned NOT NULL,
  `origin_In_packet_loss` int(11) unsigned NOT NULL,
  `origin_in_delay` int(11) unsigned NOT NULL,
  `origin_in_jitter` int(11) unsigned NOT NULL,
  `term_calling_numb` varchar(32) DEFAULT NULL,
  `term_called_numb` varchar(32) DEFAULT NULL,
  `term_in_packets` int(11) unsigned NOT NULL,
  `term_out_packets` int(11) unsigned NOT NULL,
  `term_in_octets` int(11) unsigned NOT NULL,
  `term_out_octets` int(11) unsigned NOT NULL,
  `term_in_packet_loss` int(11) unsigned NOT NULL,
  `term_in_delay` int(11) unsigned NOT NULL,
  `term_in_jitter` int(11) unsigned NOT NULL,
  `routing_digits` varchar(32) DEFAULT NULL,
  `call_duration` int(11) unsigned NOT NULL,
  `post_dial_delay` int(11) unsigned NOT NULL,
  `conf_id` varchar(64) NOT NULL DEFAULT '',
  `origin_protocol_id` int(11) unsigned NOT NULL,
  `origin_address_id` int(11) unsigned NOT NULL,
  `origin_member_id` int(11) unsigned DEFAULT NULL,
  `gw_id` int(11) unsigned NOT NULL,
  `term_protocol_id` int(11) unsigned NOT NULL,
  `term_address_id` int(11) unsigned NOT NULL,
  `term_member_id` int(11) unsigned DEFAULT NULL,
  `origin_remote_media_id` int(11) unsigned DEFAULT NULL,
  `term_remote_media_id` int(11) DEFAULT NULL,
  `country_code` varchar(8) NOT NULL DEFAULT '',
  `region_id` int(11) unsigned DEFAULT NULL,
  `region_name_id` int(11) unsigned DEFAULT NULL,
  `last_origin_attempt` tinyint(4) DEFAULT NULL,
  `last_term_attempt` tinyint(4) DEFAULT NULL,
  KEY `id` (`batch_num`),
  KEY `countryCode` (`country_code`),
  KEY `originAddressId` (`origin_address_id`),
  KEY `termAddressId` (`term_address_id`),
  KEY `gwId` (`gw_id`),
  KEY `originMemberId` (`origin_member_id`),
  KEY `termMemberId` (`term_member_id`),
  KEY `regionId` (`region_id`),
  KEY `regionNameId` (`region_name_id`),
  KEY `conf_id` (`conf_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'accounting_gateways'
CREATE TABLE `accounting_gateways` (
  `address` varchar(16) COLLATE ascii_bin NOT NULL DEFAULT '',
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `address` (`address`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'accounting_import'
CREATE TABLE `accounting_import` (
  `seiz_id` int(11) unsigned NOT NULL,
  `batch_num` int(11) unsigned NOT NULL,
  `setup_time` datetime NOT NULL,
  `connect_time` datetime DEFAULT NULL,
  `disconnect_time` datetime NOT NULL,
  `disconnect_cause` int(11) NOT NULL,
  `origin_calling_numb` varchar(32) DEFAULT '',
  `origin_called_numb` varchar(32) NOT NULL DEFAULT '',
  `origin_in_packets` int(11) unsigned NOT NULL,
  `origin_out_packets` int(11) unsigned NOT NULL,
  `origin_in_octets` int(11) unsigned NOT NULL,
  `origin_out_octets` int(11) unsigned NOT NULL,
  `origin_In_packet_loss` int(11) unsigned NOT NULL,
  `origin_in_delay` int(11) unsigned NOT NULL,
  `origin_in_jitter` int(11) unsigned NOT NULL,
  `term_calling_numb` varchar(32) NOT NULL DEFAULT '',
  `term_called_numb` varchar(32) NOT NULL DEFAULT '',
  `term_in_packets` int(11) unsigned NOT NULL,
  `term_out_packets` int(11) unsigned NOT NULL,
  `term_in_octets` int(11) unsigned NOT NULL,
  `term_out_octets` int(11) unsigned NOT NULL,
  `term_in_packet_loss` int(11) unsigned NOT NULL,
  `term_in_delay` int(11) unsigned NOT NULL,
  `term_in_jitter` int(11) unsigned NOT NULL,
  `routing_digits` varchar(32) NOT NULL DEFAULT '',
  `call_duration` int(11) unsigned NOT NULL,
  `post_dial_delay` int(11) unsigned NOT NULL,
  `conf_id` varchar(64) NOT NULL DEFAULT '',
  `origin_protocol_id` int(11) unsigned NOT NULL,
  `origin_address_id` int(11) unsigned NOT NULL,
  `gw_id` int(11) unsigned NOT NULL,
  `term_protocol_id` int(11) unsigned NOT NULL,
  `term_address_id` int(11) unsigned NOT NULL,
  `origin_remote_media_id` int(11) unsigned NOT NULL,
  `term_remote_media_id` int(11) unsigned NOT NULL,
  `country_code` varchar(8) NOT NULL DEFAULT '',
  `region_id` int(11) unsigned NOT NULL,
  `route_code_id` int(11) unsigned NOT NULL,
  `codec_id` int(11) unsigned DEFAULT NULL,
  `last_origin_attempt` tinyint(4) DEFAULT NULL,
  `last_term_attempt` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`seiz_id`),
  KEY `id` (`batch_num`),
  KEY `countryCode` (`country_code`),
  KEY `originAddressId` (`origin_address_id`),
  KEY `termAddressId` (`term_address_id`),
  KEY `gwId` (`gw_id`),
  KEY `regionId` (`region_id`),
  KEY `regionNameId` (`route_code_id`),
  KEY `conf_id` (`conf_id`),
  KEY `route_code_id` (`route_code_id`),
  KEY `disconnect_time` (`disconnect_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'accounting_intc'
CREATE TABLE `accounting_intc` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `account` varchar(6) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'accounting_ip'
CREATE TABLE `accounting_ip` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(16) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `address` (`address`)
) ENGINE=InnoDB AUTO_INCREMENT=10549 DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'accounting_members'
CREATE TABLE `accounting_members` (
  `member_id` int(11) unsigned NOT NULL,
  `address_id` int(11) unsigned NOT NULL,
  `type_id` int(11) unsigned NOT NULL,
  `vtr_id` int(11) unsigned NOT NULL,
  `intc_id` int(11) unsigned DEFAULT NULL,
  `plan_id` int(11) unsigned DEFAULT NULL,
  UNIQUE KEY `address_id_2` (`address_id`,`type_id`,`vtr_id`),
  KEY `member_id` (`member_id`),
  KEY `address_id` (`address_id`),
  CONSTRAINT `accounting_members_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `accounting_members_name` (`id`),
  CONSTRAINT `accounting_members_ibfk_2` FOREIGN KEY (`address_id`) REFERENCES `accounting_ip` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'accounting_members_name'
CREATE TABLE `accounting_members_name` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=515 DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'accounting_plan'
CREATE TABLE `accounting_plan` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pricing_plan` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'accounting_price'
CREATE TABLE `accounting_price` (
  `Customer` varchar(50) COLLATE ascii_bin NOT NULL,
  `RegionID` int(11) NOT NULL,
  `Effective_Date` datetime NOT NULL,
  `Price` float NOT NULL,
  `initial_increment` float DEFAULT NULL,
  `additional_increment` float DEFAULT NULL,
  `price_pk` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`price_pk`)
) ENGINE=MyISAM AUTO_INCREMENT=6789432 DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'accounting_region'
CREATE TABLE `accounting_region` (
  `prefix` varchar(4) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `region_name` varchar(32) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `region_code` varchar(8) COLLATE ascii_bin DEFAULT '',
  `mobile_proper` char(1) COLLATE ascii_bin DEFAULT NULL,
  `route_code` int(11) DEFAULT NULL,
  `region_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `date_region` datetime DEFAULT NULL,
  `transparent` tinyint(4) NOT NULL,
  PRIMARY KEY (`region_id`),
  KEY `Prefix` (`prefix`),
  KEY `RegionName` (`region_name`)
) ENGINE=InnoDB AUTO_INCREMENT=49627 DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'accounting_region_name'
CREATE TABLE `accounting_region_name` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `country_code` varchar(4) DEFAULT NULL,
  `region_name` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `regionName` (`region_name`)
) ENGINE=InnoDB AUTO_INCREMENT=193901 DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'accounting_summary'
CREATE TABLE `accounting_summary` (
  `batch_time` datetime NOT NULL,
  `batch_time_30` datetime NOT NULL,
  `batch_time_120` datetime NOT NULL,
  `batch_time_24h` datetime NOT NULL,
  `batch_num` int(11) unsigned NOT NULL,
  `origin_member_id` int(11) unsigned NOT NULL,
  `term_member_id` int(11) unsigned NOT NULL,
  `origin_address_id` int(10) unsigned NOT NULL,
  `term_address_id` int(10) unsigned NOT NULL,
  `country_code` varchar(8) NOT NULL DEFAULT '',
  `route_code_id` int(11) unsigned NOT NULL,
  `gw_id` int(11) unsigned NOT NULL,
  `raw_seizures` int(11) DEFAULT NULL,
  `origin_seizures` int(11) NOT NULL DEFAULT '0',
  `term_seizures` int(11) NOT NULL DEFAULT '0',
  `completed` int(11) NOT NULL DEFAULT '0',
  `origin_asrm_seiz` int(11) NOT NULL DEFAULT '0',
  `term_asrm_seiz` int(11) NOT NULL DEFAULT '0',
  `origin_ner_seiz` int(11) NOT NULL DEFAULT '0',
  `term_ner_seiz` int(11) NOT NULL DEFAULT '0',
  `origin_packet_loss` int(11) NOT NULL DEFAULT '0',
  `origin_jitter` int(11) NOT NULL DEFAULT '0',
  `term_packet_loss` int(11) NOT NULL DEFAULT '0',
  `term_jitter` int(11) NOT NULL DEFAULT '0',
  `conn_minutes` decimal(38,6) NOT NULL DEFAULT '0.000000',
  `origin_ans_del` int(11) NOT NULL DEFAULT '0',
  `origin_adj_ans_del` int(11) NOT NULL DEFAULT '0',
  `term_ans_del` int(11) NOT NULL DEFAULT '0',
  `term_adj_ans_del` int(11) NOT NULL DEFAULT '0',
  `origin_normal_disc` int(11) NOT NULL DEFAULT '0',
  `origin_failure_disc` int(11) NOT NULL DEFAULT '0',
  `origin_no_circ_disc` int(11) NOT NULL DEFAULT '0',
  `origin_no_req_circ_disc` int(11) NOT NULL DEFAULT '0',
  `term_normal_disc` int(11) NOT NULL DEFAULT '0',
  `term_failure_disc` int(11) NOT NULL DEFAULT '0',
  `term_no_circ_disc` int(11) NOT NULL DEFAULT '0',
  `term_no_req_circ_disc` int(11) NOT NULL DEFAULT '0',
  `min_time` datetime NOT NULL,
  `max_time` datetime NOT NULL,
  `origin_fsr_seiz` int(11) NOT NULL DEFAULT '0',
  `term_fsr_seiz` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`batch_time`,`batch_time_30`,`batch_time_120`,`batch_time_24h`,`batch_num`,`origin_member_id`,`term_member_id`,`origin_address_id`,`term_address_id`,`country_code`,`route_code_id`,`gw_id`),
  KEY `origin_member_id` (`origin_member_id`),
  KEY `term_member_id` (`term_member_id`),
  KEY `country_code` (`country_code`),
  KEY `route_code_id` (`route_code_id`),
  KEY `gw_id` (`gw_id`),
  KEY `batch_time` (`batch_time`),
  KEY `batch_num` (`batch_num`),
  KEY `batch_time_30` (`batch_time_30`),
  KEY `batch_time_120` (`batch_time_120`),
  KEY `batch_time_24h` (`batch_time_24h`),
  KEY `origin_address_id` (`origin_address_id`),
  KEY `term_address_id` (`term_address_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'accounting_summary_120'
CREATE TABLE `accounting_summary_120` (
  `batch_time_120` datetime NOT NULL,
  `batch_num` int(11) unsigned NOT NULL,
  `origin_member_id` int(11) unsigned NOT NULL,
  `term_member_id` int(11) unsigned NOT NULL,
  `origin_address_id` int(11) unsigned NOT NULL,
  `term_address_id` int(11) unsigned NOT NULL,
  `country_code` varchar(8) NOT NULL DEFAULT '',
  `route_code_id` int(11) unsigned NOT NULL,
  `gw_id` int(11) unsigned NOT NULL,
  `raw_seizures` int(11) DEFAULT NULL,
  `origin_seizures` int(11) NOT NULL DEFAULT '0',
  `term_seizures` int(11) NOT NULL DEFAULT '0',
  `completed` int(11) NOT NULL DEFAULT '0',
  `origin_asrm_seiz` int(11) NOT NULL DEFAULT '0',
  `term_asrm_seiz` int(11) NOT NULL DEFAULT '0',
  `origin_ner_seiz` int(11) NOT NULL DEFAULT '0',
  `term_ner_seiz` int(11) NOT NULL DEFAULT '0',
  `origin_packet_loss` int(11) NOT NULL DEFAULT '0',
  `origin_jitter` int(11) NOT NULL DEFAULT '0',
  `term_packet_loss` int(11) NOT NULL DEFAULT '0',
  `term_jitter` int(11) NOT NULL DEFAULT '0',
  `conn_minutes` decimal(38,6) NOT NULL DEFAULT '0.000000',
  `origin_ans_del` int(11) NOT NULL DEFAULT '0',
  `origin_adj_ans_del` int(11) NOT NULL DEFAULT '0',
  `term_ans_del` int(11) NOT NULL DEFAULT '0',
  `term_adj_ans_del` int(11) NOT NULL DEFAULT '0',
  `origin_normal_disc` int(11) NOT NULL DEFAULT '0',
  `origin_failure_disc` int(11) NOT NULL DEFAULT '0',
  `origin_no_circ_disc` int(11) NOT NULL DEFAULT '0',
  `origin_no_req_circ_disc` int(11) NOT NULL DEFAULT '0',
  `term_normal_disc` int(11) NOT NULL DEFAULT '0',
  `term_failure_disc` int(11) NOT NULL DEFAULT '0',
  `term_no_circ_disc` int(11) NOT NULL DEFAULT '0',
  `term_no_req_circ_disc` int(11) NOT NULL DEFAULT '0',
  `min_time` datetime NOT NULL,
  `max_time` datetime NOT NULL,
  `origin_fsr_seiz` int(11) NOT NULL DEFAULT '0',
  `term_fsr_seiz` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`batch_time_120`,`batch_num`,`origin_member_id`,`term_member_id`,`origin_address_id`,`term_address_id`,`country_code`,`route_code_id`,`gw_id`),
  KEY `origin_member_id` (`origin_member_id`),
  KEY `term_member_id` (`term_member_id`),
  KEY `country_code` (`country_code`),
  KEY `route_code_id` (`route_code_id`),
  KEY `gw_id` (`gw_id`),
  KEY `batch_num` (`batch_num`),
  KEY `batch_time_30` (`batch_time_120`),
  KEY `origin_address_id` (`origin_address_id`),
  KEY `term_address_id` (`term_address_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'accounting_summary_24h'
CREATE TABLE `accounting_summary_24h` (
  `batch_time_24h` datetime NOT NULL,
  `batch_num` int(11) unsigned NOT NULL,
  `origin_member_id` int(11) unsigned NOT NULL,
  `term_member_id` int(11) unsigned NOT NULL,
  `origin_address_id` int(11) unsigned NOT NULL,
  `term_address_id` int(11) unsigned NOT NULL,
  `country_code` varchar(8) NOT NULL DEFAULT '',
  `route_code_id` int(11) unsigned NOT NULL,
  `gw_id` int(11) unsigned NOT NULL,
  `raw_seizures` int(11) NOT NULL,
  `origin_seizures` int(11) NOT NULL DEFAULT '0',
  `term_seizures` int(11) NOT NULL DEFAULT '0',
  `completed` int(11) NOT NULL DEFAULT '0',
  `origin_asrm_seiz` int(11) NOT NULL DEFAULT '0',
  `term_asrm_seiz` int(11) NOT NULL DEFAULT '0',
  `origin_ner_seiz` int(11) NOT NULL DEFAULT '0',
  `term_ner_seiz` int(11) NOT NULL DEFAULT '0',
  `origin_packet_loss` int(11) NOT NULL DEFAULT '0',
  `origin_jitter` int(11) NOT NULL DEFAULT '0',
  `term_packet_loss` int(11) NOT NULL DEFAULT '0',
  `term_jitter` int(11) NOT NULL DEFAULT '0',
  `conn_minutes` decimal(38,6) NOT NULL DEFAULT '0.000000',
  `origin_ans_del` int(11) NOT NULL DEFAULT '0',
  `origin_adj_ans_del` int(11) NOT NULL DEFAULT '0',
  `term_ans_del` int(11) NOT NULL DEFAULT '0',
  `term_adj_ans_del` int(11) NOT NULL DEFAULT '0',
  `origin_normal_disc` int(11) NOT NULL DEFAULT '0',
  `origin_failure_disc` int(11) NOT NULL DEFAULT '0',
  `origin_no_circ_disc` int(11) NOT NULL DEFAULT '0',
  `origin_no_req_circ_disc` int(11) NOT NULL DEFAULT '0',
  `term_normal_disc` int(11) NOT NULL DEFAULT '0',
  `term_failure_disc` int(11) NOT NULL DEFAULT '0',
  `term_no_circ_disc` int(11) NOT NULL DEFAULT '0',
  `term_no_req_circ_disc` int(11) NOT NULL DEFAULT '0',
  `min_time` datetime NOT NULL,
  `max_time` datetime NOT NULL,
  `origin_fsr_seiz` int(11) NOT NULL DEFAULT '0',
  `term_fsr_seiz` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`batch_time_24h`,`batch_num`,`origin_member_id`,`term_member_id`,`origin_address_id`,`term_address_id`,`country_code`,`route_code_id`,`gw_id`),
  KEY `origin_member_id` (`origin_member_id`),
  KEY `term_member_id` (`term_member_id`),
  KEY `country_code` (`country_code`),
  KEY `route_code_id` (`route_code_id`),
  KEY `gw_id` (`gw_id`),
  KEY `batch_num` (`batch_num`),
  KEY `batch_time_30` (`batch_time_24h`),
  KEY `origin_address_id` (`origin_address_id`),
  KEY `term_address_id` (`term_address_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'accounting_summary_30'
CREATE TABLE `accounting_summary_30` (
  `batch_time_30` datetime NOT NULL,
  `batch_num` int(11) unsigned NOT NULL,
  `origin_member_id` int(11) unsigned NOT NULL,
  `term_member_id` int(11) unsigned NOT NULL,
  `origin_address_id` int(11) unsigned NOT NULL,
  `term_address_id` int(10) unsigned NOT NULL,
  `country_code` varchar(8) NOT NULL DEFAULT '',
  `route_code_id` int(11) unsigned NOT NULL,
  `gw_id` int(11) unsigned NOT NULL,
  `raw_seizures` int(11) NOT NULL,
  `origin_seizures` int(11) NOT NULL DEFAULT '0',
  `term_seizures` int(11) NOT NULL DEFAULT '0',
  `completed` int(11) NOT NULL DEFAULT '0',
  `origin_asrm_seiz` int(11) NOT NULL DEFAULT '0',
  `term_asrm_seiz` int(11) NOT NULL DEFAULT '0',
  `origin_ner_seiz` int(11) NOT NULL DEFAULT '0',
  `term_ner_seiz` int(11) NOT NULL DEFAULT '0',
  `origin_packet_loss` int(11) NOT NULL DEFAULT '0',
  `origin_jitter` int(11) NOT NULL DEFAULT '0',
  `term_packet_loss` int(11) NOT NULL DEFAULT '0',
  `term_jitter` int(11) NOT NULL DEFAULT '0',
  `conn_minutes` decimal(38,6) NOT NULL DEFAULT '0.000000',
  `origin_ans_del` int(11) NOT NULL DEFAULT '0',
  `origin_adj_ans_del` int(11) NOT NULL DEFAULT '0',
  `term_ans_del` int(11) NOT NULL DEFAULT '0',
  `term_adj_ans_del` int(11) NOT NULL DEFAULT '0',
  `origin_normal_disc` int(11) NOT NULL DEFAULT '0',
  `origin_failure_disc` int(11) NOT NULL DEFAULT '0',
  `origin_no_circ_disc` int(11) NOT NULL DEFAULT '0',
  `origin_no_req_circ_disc` int(11) NOT NULL DEFAULT '0',
  `term_normal_disc` int(11) NOT NULL DEFAULT '0',
  `term_failure_disc` int(11) NOT NULL DEFAULT '0',
  `term_no_circ_disc` int(11) NOT NULL DEFAULT '0',
  `term_no_req_circ_disc` int(11) NOT NULL DEFAULT '0',
  `min_time` datetime NOT NULL,
  `max_time` datetime NOT NULL,
  `origin_fsr_seiz` int(11) NOT NULL DEFAULT '0',
  `term_fsr_seiz` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`batch_time_30`,`batch_num`,`origin_member_id`,`term_member_id`,`origin_address_id`,`term_address_id`,`country_code`,`route_code_id`,`gw_id`),
  KEY `origin_member_id` (`origin_member_id`),
  KEY `term_member_id` (`term_member_id`),
  KEY `country_code` (`country_code`),
  KEY `route_code_id` (`route_code_id`),
  KEY `gw_id` (`gw_id`),
  KEY `batch_num` (`batch_num`),
  KEY `batch_time_30` (`batch_time_30`),
  KEY `origin_address_id` (`origin_address_id`),
  KEY `term_address_id` (`term_address_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'accounting_summary_primary'
CREATE TABLE `accounting_summary_primary` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `origin_member_id` int(11) unsigned NOT NULL,
  `term_member_id` int(11) unsigned NOT NULL,
  `origin_address_id` int(11) unsigned NOT NULL,
  `term_address_id` int(11) unsigned NOT NULL,
  `country_code` int(11) unsigned NOT NULL,
  `route_code_id` int(11) unsigned NOT NULL,
  `gw_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `origin_member_id` (`origin_member_id`),
  KEY `term_member_id` (`term_member_id`),
  KEY `origin_address_id` (`origin_address_id`),
  KEY `term_address_id` (`term_address_id`),
  KEY `country_code` (`country_code`),
  KEY `route_code_id` (`route_code_id`),
  KEY `gw_id` (`gw_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8192 DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'accounting_type'
CREATE TABLE `accounting_type` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` char(3) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'accounting_vtr'
CREATE TABLE `accounting_vtr` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Create syntax for VIEW 'country_distinct'
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `country_distinct`
AS SELECT
   distinct `a`.`Country` AS `country`
FROM `country_prefix` `a` where `a`.`Prefix` in (select `accounting_region`.`prefix` from `accounting_region`) order by `a`.`Country`;

-- Create syntax for TABLE 'country_prefix'
CREATE TABLE `country_prefix` (
  `Country` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `Prefix` varchar(8) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `Continent` char(2) COLLATE ascii_bin DEFAULT NULL,
  PRIMARY KEY (`Prefix`)
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'disconnect_text_master'
CREATE TABLE `disconnect_text_master` (
  `disconnect_text` varchar(255) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `id` int(11) NOT NULL,
  `id_hex` varchar(3) COLLATE ascii_bin NOT NULL DEFAULT '',
  `disconnect_group` int(11) NOT NULL,
  `asrm_group` tinyint(4) NOT NULL,
  `ner_group` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=ascii COLLATE=ascii_bin;

-- Create syntax for TABLE 'playlist_graphs'
CREATE TABLE `playlist_graphs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `playlist_id` int(10) unsigned NOT NULL,
  `order` int(10) unsigned NOT NULL,
  `title` varchar(256) DEFAULT NULL,
  `country` varchar(256) DEFAULT NULL,
  `route_code_id` int(11) unsigned DEFAULT NULL,
  `origin_member_id` int(11) unsigned DEFAULT NULL,
  `term_member_id` int(11) unsigned DEFAULT NULL,
  `gw_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `playlist_id` (`playlist_id`)
) ENGINE=InnoDB AUTO_INCREMENT=254 DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'playlists'
CREATE TABLE `playlists` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL,
  `name` varchar(256) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `playlists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'sessions'
CREATE TABLE `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int(11) unsigned NOT NULL,
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'users'
CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL DEFAULT '',
  `salt` varchar(255) DEFAULT NULL,
  `userPermission` tinyint(4) DEFAULT '1',
  `adminPermission` tinyint(4) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'voip_codecs'
CREATE TABLE `voip_codecs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `name_2` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- Create syntax for TABLE 'voip_protocol'
CREATE TABLE `voip_protocol` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `protocol` varchar(8) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
