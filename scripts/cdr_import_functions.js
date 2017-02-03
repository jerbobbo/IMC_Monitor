'use strict';
var mysql = require('promise-mysql');
var config = require('../config/db-config');
var Promise = require('bluebird');

var pool = mysql.createPool( {
	host: 'localhost',
	user: config.DATABASE_USER,
	password: config.DATABASE_PASS,
	database: config.DATABASE_URI,
  connectionLimt: 10
});

var regionTable = {};

pool.query('select prefix, CONCAT(prefix,region_code) as routing_digits, region_id, prefix, route_code from accounting_region')
.then(function(result) {
	result.forEach(function(elem) {
		if (!regionTable[elem.prefix]) regionTable[elem.prefix] = {};
		regionTable[elem.prefix][elem.routing_digits] = { regionId: elem.region_id, routeCode: elem.route_code };
	});
	//console.log(regionTable);
});

function findOrCreateGatewayId (address) {
	// console.log('GatewayId');

	var conn, foundId;
	return pool.getConnection()
	.then(function(_conn) {
		conn = _conn;
  	return conn.query("select id from accounting_gateways where address like '" + address + "' limit 1");
	})
	.then(function(res) {
		if (res.length === 0) {
			console.log('no gateway_id found: ', address);
			return conn.query("insert into accounting_gateways(address) select '" + address + "'")
			.then(function() {
				return conn.query("select id from accounting_gateways where address like '" + address + "' limit 1");
			})
			.then(function(_res) {
				foundId = _res[0].id;
				return pool.releaseConnection(conn);
			})
			.catch(console.log)
		}
		else {
			foundId = res[0].id;
			return pool.releaseConnection(conn);
		}
	})
	.then(function() {
		//console.log('you got here');
		return foundId;
	})
	.catch(function(err) {
		console.log('findOrCreateGatewayId ', address, err);
	});
}

function findOrCreateMemberId (address_id) {
	// console.log('MemberId');
	var conn, foundId;
	return pool.getConnection()
	.then(function(_conn) {
		conn = _conn;
  	return conn.query("select member_id from accounting_members where address_id =" + address_id + " limit 1");
	})
	.then(function(res) {
		if (res.length === 0) {
			console.log('no member_id found for address_id ', address_id);
			return conn.query("insert into accounting_members(member_id, address_id, type_id, vtr_id, intc_id) select 514, '" + address_id + "', 2, 3, 2")
			.then(function() {
				return conn.query("select member_id from accounting_members where address_id =" + address_id + " limit 1");
			})
			.then(function(_res) {
				foundId = _res[0].member_id;
				return pool.releaseConnection(conn);
			})
			.catch(console.log)
		}
		else {
			foundId = res[0].member_id;
			return pool.releaseConnection(conn);
		}
	})
	.then(function() {
		// console.log('you got here')
		return foundId;
	})
	.catch(function(err) {
		console.log('findOrCreateMemberId ', address_id, err);
	});
}

function findOrCreateAddressId (address, isMediaAddress) {
	// console.log('AddressId');
	var conn, foundId;
	return pool.getConnection()
	.then(function(_conn) {
		conn = _conn;
		return conn.query("select id from accounting_ip where address like '" + address + "' limit 1");
	})
	.then(function(res) {
		if (res.length === 0) {
			console.log('no address_id found for address: ', address);
			return conn.query("insert into accounting_ip(address) select '" + address + "'")
			.then(function() {
				return conn.query("select id from accounting_ip where address like '" + address + "' limit 1");
			})
			.then(function(_res) {
				foundId = _res[0].id;
				return pool.releaseConnection(conn);
			})
			.catch(function(err) {
				console.log(err);
				if (err.errno === 1062) {
					return conn.query("select id from accounting_ip where address like '" + address + "' limit 1")
					.then(function(_res) {
						foundId = _res[0].id;
						return pool.releaseConnection(conn);
					});
				}
			});
		}
		else {
			foundId = res[0].id;
			return pool.releaseConnection(conn);
		}
	})
	.then(function() {
		// console.log('you got here');
		if (!isMediaAddress) findOrCreateMemberId(foundId);
		return foundId;
	})
	.catch(function(err) {
		console.log('findOrCreateAddressId ', address, err);
	});
}

  function findProtocolId (protocolType) {
		// console.log('protocolType');
  	return pool.query("select id from voip_protocol where protocol like '" + protocolType + "' limit 1")
  	.then(function(res) {
  		if (res.length > 0) return res[0].id;
  	})
  	.catch(console.log)
  }

	function findCodecId (codec) {
		// console.log('codecId');
		return pool.query("select id from voip_codecs where name like '" + codec + "' limit 1")
  	.then(function(res) {
  		if (res.length > 0) return res[0].id;
			else return 'NULL';
  	})
  	.catch(console.log)
	}

	function matchCodec (origList, termList) {
		// console.log('matchCodec');
		var match;
		var origListArr = origList.split(',');
		var termListArr = termList.split(',');
		// console.log('origListArr', origListArr);
		// console.log('termListArr', termListArr);
		for (var i = 0; i < origListArr.length && !match; i++) {
			for (var j = 0; j < termListArr.length && !match; j++) {
				if (origListArr[i] === termListArr[j]) match = origListArr[i];
			}
		}
		// console.log('match', match);
		if (!match) return 'NULL';
		return findCodecId(match);
	}


  function decToHex (num) {
  	return (+num).toString(16);
  }

  function isCDR (fileName) {
  	return fileName.substr(-3) === 'cdr';
  }

  function convertDate (dateString) {
  	if (dateString === 'NA') return 'NULL';
  	return "STR_TO_DATE('" + dateString + "', '%a %b %d %H:%i:%s %Y')";
  }

  function getNextBatchNum () {
  	return pool.query("select max(batch_num) as max_batch from accounting_summary")
  	.then(function(res) {
  		if (res.length > 0) return res[0].max_batch + 1;
  		else return 1;
  	})
  	.catch(console.log);
  }

	function calcRoutingDigits (calledNum, member_id) {
			//these members send call without prefix
			if ([72, 231, 249, 267].indexOf(member_id) !== -1) return calledNum;
			//STE sends call with 2-digit prefix of 77 or 78
			if ( /^77|^78/.test(calledNum) ) return calledNum.substring(2);
			return calledNum.substring(4);
	}

  function calcRegionIdAndCountryId (routingDig) {
    var re = new RegExp("[0-9]");
  	routingDig = routingDig.substring(routingDig.search(re));
    //console.log(routingDig);
  	var countryCode;
  	var codeLength = 3;

  	if ( /^1204|^1242|^1246|^1250|^1264|^1268|^1284|^1289|^1306|^1340|^1345|^1403|^1416|^1418|^1438|^1441|^1450|^1473|^1506|^1514|^1519|^1604|^1613|^1647|^1649|^1664|^1671|^1684|^1705|^1709|^1758|^1767|^1778|^1780|^1784|^1787|^1807|^1808|^1809|^1819|^1829|^1849|^1867|^1868|^1869|^1876|^1902|^1905|^1907|^1939|^61891006|^61891007|^61891008|^61891010|^61891011|^61891012|^6189162|^6189164|^6721/.test(routingDig))
  		codeLength = 4;
  	else if ( /^20|^27|^30|^31|^32|^33|^34|^36|^39|^40|^41|^43|^44|^45|^46|^47|^48|^49|^51|^52|^53|^54|^55|^56|^57|^58|^60|^61|^62|^63|^64|^65|^66|^81|^82|^84|^86|^87|^90|^91|^92|^93|^94|^95|^98/.test(routingDig) )
  		codeLength = 2;
  	else if ( /^1|^7/.test(routingDig) )
  		codeLength = 1;

  	countryCode = routingDig.substring(0, codeLength);

			// console.log(routingDig, res);
  		var match = 'NULL', routeCode = 'NULL';
			if (regionTable[countryCode]) {
				var countryTable = Object.keys(regionTable[countryCode]);
				var regionDigits;
				for (var i = countryTable.length - 1; i >= 0  && match === 'NULL'; i--) {
					//console.log('countryCode: ', countryCode, 'key: ', countryTable[i], routingDig);
					regionDigits = countryTable[i];
					var regex = new RegExp("^" + regionDigits);
					if (regex.test(routingDig)) {
						match = regionTable[countryCode][regionDigits].regionId;
						routeCode = regionTable[countryCode][regionDigits].routeCode;
					}

				}
			}
			//console.log('match: ', match);
  		return {
  			regionId: match,
  			countryCode: countryCode,
				routeCode: routeCode
  		};
  }

	function calcDestination (originCalledNum, originAddress) {
		// console.log('calcDestination');
		var addressId, routingDigits;
		return findOrCreateAddressId( originAddress )
		.then(function(_addressId) {
			addressId = _addressId;
			return findOrCreateMemberId(_addressId);
		})
		.then(function(_memberId) {
			return calcRoutingDigits( originCalledNum, _memberId );
		})
		.then(function(_routingDigits) {
			routingDigits = _routingDigits;
			return calcRegionIdAndCountryId(_routingDigits);
		})
		.then(function(results) {
			return {
				regionId: results.regionId,
				countryCode: results.countryCode,
				routeCode: results.routeCode,
				routingDigits: routingDigits,
				originAddressId: addressId
			};
		})
		.catch(console.log);
	}

	function validateLine (line) {
		// console.log([line[57].length, line[14].length, line[6], line[7], line[8]].join(', '));
		//console.log(line.length);
		if (line.length !== 71) return false;
		if (line[57].length !== 35) return false;
		if (line[14].length === 6 || line[33].length === 6) return false;
		if (line[6] !== 'NA' && !/\w{3}\s\w{3}\s+\d+\s\d{2}:\d{2}:\d{2}\s\d{4}/.test(line[6])) return false;
		if (line[7] !== 'NA' && !/\w{3}\s\w{3}\s+\d+\s\d{2}:\d{2}:\d{2}\s\d{4}/.test(line[7])) return false;
		if (line[8] !== 'NA' && !/\w{3}\s\w{3}\s+\d+\s\d{2}:\d{2}:\d{2}\s\d{4}/.test(line[8])) return false;
		//console.log('validated');
		return true;
	}

	function naToNull (data) {
		if (data === 'NA') return 'NULL';
		return data;
	}

  function insertCdrData (insertData) {
		var conn;
		return pool.getConnection()
		.then(function(_conn) {
			conn = _conn;
			return conn.query('insert into accounting_import values ' + insertData);
		})
		.then(function() {
			return pool.releaseConnection(conn);
		})
		.catch(console.log)

  }

  function addQuotes (data) {
    if (data && data !== 'NULL') {
      return "'" + data + "'";
    }
		return 'NULL';
  }

	function initialize () {
		var conn;
		var dbQueries = [
			// 'SET autocommit=0',
			'SET unique_checks=0',
			'SET foreign_key_checks=0',
			'TRUNCATE TABLE accounting_import'];
		return pool.getConnection()
		.then(function(_conn) {
			conn = _conn;
			return Promise.each(dbQueries, function(query) {
				return conn.query(query)
				.then(function() {
					console.log('query succeeded: ', query);
				});
			});
		})
		.then(function() {
			return pool.releaseConnection(conn);
		})
		.catch(console.log);
	}

  function closeDb () {
		var dbQueries = [
			`update accounting_import a
			inner join accounting_members d on a.origin_address_id = d.address_id
			set a.last_origin_attempt =
			  (case when a.seiz_id =
			    (select max(seiz_id)
			      from (select * from accounting_import) b
			      where b.conf_id = a.conf_id and b.origin_address_id = a.origin_address_id and b.disconnect_time in (
			      select max(disconnect_time) from (select * from accounting_import) f where f.conf_id = a.conf_id))
			      then 1 else 0 end)`,
			`update accounting_import a
			inner join accounting_members d on a.term_address_id = d.address_id
			set a.last_term_attempt =
			  (case when a.seiz_id =
			    (select max(seiz_id) from (select * from accounting_import) b
			    where b.conf_id = a.conf_id
			    and b.term_address_id in (select c.address_id from accounting_members c where c.member_id = d.member_id )
			    and b.disconnect_time in (
			    select max(disconnect_time) from (select * from accounting_import) f where f.conf_id = a.conf_id and f.term_address_id in (select g.address_id from accounting_members g where g.member_id = d.member_id) ))
			    then 1 else 0 end)`,
					`insert into accounting_summary select FROM_UNIXTIME(FLOOR(UNIX_TIMESTAMP(a.disconnect_time)/300)*300) as batch_num,
a.batch_num,
b.member_id as origin_member_id, c.member_id as term_member_id,
country_code, route_code_id, gw_id,
sum(case when a.last_origin_attempt = true then 1 else 0 end) as origin_seizures,
sum(case when a.last_term_attempt = true then 1 else 0 end) as term_seizures,
sum(case when a.call_duration > 0 then 1 else 0 end) as completed,
sum(case when a.last_origin_attempt = true and d.asrm_group = false then 1 else 0 end) as origin_asrm_seiz,
sum(case when a.last_term_attempt = true and d.asrm_group = false then 1 else 0 end) as term_asrm_seiz,
sum(case when a.last_origin_attempt = true and d.ner_group = true then 1 else 0 end) as origin_ner_seiz,
sum(case when a.last_term_attempt = true and d.ner_group = true then 1 else 0 end) as term_ner_seiz,
sum(origin_in_packet_loss) as orig_in_packet_loss, sum(origin_in_jitter) as origin_jitter,
sum(term_in_packet_loss) as term_packet_loss, sum(term_in_jitter) as term_jitter,
sum(call_duration/60.0) as conn_minutes,
sum(case when a.last_origin_attempt = true then post_dial_delay else 0 end) as origin_ans_del,
sum(case when a.last_origin_attempt = true and disconnect_cause = 34 then post_dial_delay else 0 end) as origin_adj_ans_del,
sum(case when a.last_term_attempt = true then post_dial_delay else 0 end) as term_ans_del,
sum(case when a.last_term_attempt = true and disconnect_cause = 34 then post_dial_delay else 0 end) as term_adj_ans_del,
sum(case when d.disconnect_group = 1 and a.last_origin_attempt = true then 1 else 0 end) as origin_normal_disc,
sum(case when d.disconnect_group = 2 and a.last_origin_attempt = true then 1 else 0 end) as origin_failure_disc,
sum(case when d.disconnect_group = 3 and a.last_origin_attempt = true then 1 else 0 end) as origin_no_circ_disc,
sum(case when d.id = 44 and a.last_origin_attempt = true then 1 else 0 end) as origin_no_req_circ_disc,
sum(case when d.disconnect_group = 1 and a.last_term_attempt = true then 1 else 0 end) as term_normal_disc,
sum(case when d.disconnect_group = 2 and a.last_term_attempt = true then 1 else 0 end) as term_failure_disc,
sum(case when d.disconnect_group = 3 and a.last_term_attempt = true then 1 else 0 end) as term_no_circ_disc,
sum(case when d.id = 44 and a.last_term_attempt = true then 1 else 0 end) as term_no_req_circ_disc,
min(disconnect_time) as min_time, max(disconnect_time) as max_time, 0 as origin_fsr_seiz, 0 as term_fsr_seiz
from accounting_import a
join accounting_members b on a.origin_address_id = b.address_id
join accounting_members c on a.term_address_id = c.address_id
join disconnect_text_master d on a.disconnect_cause = d.id
group by FROM_UNIXTIME(FLOOR(UNIX_TIMESTAMP(a.disconnect_time)/300)*300), batch_num, country_code, route_code_id, gw_id, origin_member_id, b.member_id, c.member_id`,
					// 'SET autocommit=1',
					'SET unique_checks=1',
					'SET foreign_key_checks=1'
					];

		return pool.getConnection()
		.then(function(conn) {
			return Promise.each(dbQueries, function(query) {
				return conn.query(query)
				.then(function() {
					console.log('query succeeded: ', query);
				});
			});
		})
		.then(function() {
			return pool.end();
		})
		.then(function() {
			console.log('database connection closed');
		})
		.catch(console.log)

  }

module.exports = {
  findOrCreateMemberId: findOrCreateMemberId,
  findOrCreateAddressId: findOrCreateAddressId,
  findOrCreateGatewayId: findOrCreateGatewayId,
  findProtocolId: findProtocolId,
  isCDR: isCDR,
  decToHex: decToHex,
  convertDate: convertDate,
  getNextBatchNum: getNextBatchNum,
	calcRoutingDigits: calcRoutingDigits,
	calcDestination: calcDestination,
  calcRegionIdAndCountryId: calcRegionIdAndCountryId,
	matchCodec: matchCodec,
	validateLine: validateLine,
  insertCdrData: insertCdrData,
  addQuotes: addQuotes,
	initialize: initialize,
  closeDb: closeDb
};
