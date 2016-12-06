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

pool.query('select prefix, CONCAT(prefix,regioncode) as routingDigits, regionid ,prefix from accounting_region')
.then(function(result) {
	result.forEach(function(elem) {
		if (!regionTable[elem.prefix]) regionTable[elem.prefix] = {};
		regionTable[elem.prefix][elem.routingDigits] = elem.regionid;
	});
	//console.log(regionTable);
});

  function findOrCreateGatewayId (address) {
  	return pool.query("select id from accounting_gateways where address like '" + address + "' limit 1")
  	.then(function(res) {
  		if (res.length > 0) return res[0].id;
  		else {
  			console.log('no id found: ', address);
  			return pool.query("insert into accounting_gateways(address) select '" + address + "'")
  			.catch(function() {
  				return pool.query("select id from accounting_gateways where address like '" + address + "' limit 1");
  			})
  			.then(function() {
  				return pool.query("select id from accounting_gateways where address like '" + address + "' limit 1");
  			})
  			.then(function(_res) {
  				return _res[0].id;
  			});
  		}
  	})
  	.catch(console.log)
  }

  function findOrCreateMemberId (address_id) {
  	return pool.query("select member_id from accounting_members where address_id =" + address_id + " limit 1")
  	.then(function(res) {
  		if (res.length > 0) return res[0].member_id;
  		else {
  			console.log('no id found: ', address_id);
  			return pool.query("insert into accounting_members(member_id, address_id, type_id, vtr_id, intc_id) select 514, '" + address_id + "', 2, 3, 2")
  			.catch(function() {
  				return pool.query("select member_id from accounting_members where address_id =" + address_id + " limit 1");
  			})
  			.then(function() {
  				return pool.query("select member_id from accounting_members where address_id =" + address_id + " limit 1");
  			})
  			.then(function(_res) {
  				return _res[0].member_id;
  			});
  		}
  	})
  	.catch(console.log)
  }

  function findOrCreateAddressId (address, mediaAddress) {
    return pool.query("select id from accounting_ip where address like '" + address + "' limit 1")
    .then(function(res) {
      if (res.length > 0) return res[0].id;
      else {
        console.log('no id found: ', address);
        return pool.query("insert into accounting_ip(address) select '" + address + "'")
        .catch(function() {
          return pool.query("select id from accounting_ip where address like '" + address + "' limit 1");
        })
        .then(function() {
          return pool.query("select id from accounting_ip where address like '" + address + "' limit 1");
        })
        .then(function(_res) {
          if (!mediaAddress) findOrCreateMemberId(_res[0].id);
					return _res[0].id
				})
				.catch(console.log)
      }
    })
    .catch(console.log)
  }

  function findProtocolId (protocolType) {
  	return pool.query("select id from voip_protocol where protocol like '" + protocolType + "' limit 1")
  	.then(function(res) {
  		if (res.length > 0) return res[0].id;
  	})
  	.catch(console.log)
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
  	return pool.query("select max(batchNum) as maxBatch from accounting_cdr")
  	.then(function(res) {
  		if (res.length > 0) return res[0].maxBatch + 1;
  		else return 1;
  	})
  	.catch(console.log)
  }

	function calcRoutingDigits (calledNum) {
		if ( /^77|^78/.test(calledNum) )
			return calledNum.substring(2);
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
  		var match = 'NULL';
			if (regionTable[countryCode]) {
				var countryTable = Object.keys(regionTable[countryCode]);
				for (var i = countryTable.length - 1; i >= 0  && match === 'NULL'; i--) {
					//console.log('countryCode: ', countryCode, 'key: ', countryTable[i], routingDig);
					var regex = new RegExp("^" + countryTable[i]);
					if (regex.test(routingDig))
	  				match = regionTable[countryCode][countryTable[i]];
				}
			}
			//console.log('match: ', match);
  		return {
  			regionId: match,
  			countryCode: countryCode
  		};
  }

	function validateLine (line) {
		if (line.length !== 71) return false;
		if (line[57].length !== 35) return false;
		if (line[14].length === 6 || line[33].length === 6) return false;
		if (line[6] !== 'NA' && !/\w{3}\s\w{3}\s\d+\s\d{2}:\d{2}:\d{2}\s\d{4}/.test(line[6])) return false;
		if (line[7] !== 'NA' && !/\w{3}\s\w{3}\s\d+\s\d{2}:\d{2}:\d{2}\s\d{4}/.test(line[7])) return false;
		if (line[8] !== 'NA' && !/\w{3}\s\w{3}\s\d+\s\d{2}:\d{2}:\d{2}\s\d{4}/.test(line[8])) return false;
		return true;
	}

  function insertCdrData (insertData) {
    return pool.query('insert into accounting_cdr values ' + insertData);
  }

  function addQuotes (data) {
    if (data && data !== 'NULL') {
      return "'" + data + "'";
    }
		return 'NULL';
  }

	function initialize () {
		var dbQueries = ['SET autocommit=0','SET unique_checks=0','SET foreign_key_checks=0','set session bulk_insert_buffer_size = 1024 * 1024 * 512', 'set global innodb_buffer_pool_size = 1024 * 1024 * 512'];
		return Promise.map(dbQueries, pool.query)
		.catch(console.log);
	}

  function closeDb () {
		var dbQueries = ['SET autocommit=1','SET unique_checks=1','SET foreign_key_checks=1'];
		return Promise.map(dbQueries, pool.query)
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
  calcRegionIdAndCountryId: calcRegionIdAndCountryId,
	validateLine: validateLine,
  insertCdrData: insertCdrData,
  addQuotes: addQuotes,
	initialize: initialize,
  closeDb: closeDb
};
