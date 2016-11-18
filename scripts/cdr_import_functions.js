'use strict';
var mysql = require('promise-mysql');
var config = require('../config/db-config');

var pool = mysql.createPool( {
	host: 'localhost',
	user: config.DATABASE_USER,
	password: config.DATABASE_PASS,
	database: config.DATABASE_URI,
  connectionLimt: 10
});

module.exports = {

  findOrCreateAddressId: function(address) {
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
  				return findOrCreateMemberId(_res[0].id)
  				.then(function() {
  					return _res[0].id;
  				});
  			});
  		}
  	})
  	.catch(console.log)
  },

  findOrCreateGatewayId: function(address) {
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
  },

  findOrCreateMemberId: function(address_id) {
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
  },

  findProtocolId: function(protocolType) {
  	return pool.query("select id from voip_protocol where protocol like '" + protocolType + "' limit 1")
  	.then(function(res) {
  		if (res.length > 0) return res[0].id;
  	})
  	.catch(console.log)
  },

  decToHex: function(num) {
  	return (+num).toString(16);
  },

  isCDR: function(fileName) {
  	return fileName.substr(-3) === 'cdr';
  },

  convertDate: function(dateString) {
  	if (dateString === 'NA') return '';
  	var monthNumber = {
  		'Jan': '01',
  		'Feb': '02',
  		'Mar': '03',
  		'Apr': '04',
  		'May': '05',
  		'Jun': '06',
  		'Jul': '07',
  		'Aug': '08',
  		'Sep': '09',
  		'Oct': '10',
  		'Nov': '11',
  		'Dec': '12'
  	};
  	var dateData = dateString.split(' ');
  	return dateData[4] + '-' + monthNumber[dateData[1]] + '-' + dateData[2] + ' ' + dateData[3];
  },

  getNextBatchNum: function() {
  	return pool.query("select max(batchNum) as maxBatch from accounting_cdr")
  	.then(function(res) {
  		if (res.length > 0) return res[0].maxBatch + 1;
  		else return 1;
  	})
  	.catch(console.log)
  },

  calcRegionIdAndCountryId: function(routingDig) {
  	routingDig = routingDig.substring(1);
  	var countryCode;
  	var codeLength = 3;

  	if ( /^1204|^1242|^1246|^1250|^1264|^1268|^1284|^1289|^1306|^1340|^1345|^1403|^1416|^1418|^1438|^1441|^1450|^1473|^1506|^1514|^1519|^1604|^1613|^1647|^1649|^1664|^1671|^1684|^1705|^1709|^1758|^1767|^1778|^1780|^1784|^1787|^1807|^1808|^1809|^1819|^1829|^1849|^1867|^1868|^1869|^1876|^1902|^1905|^1907|^1939|^61891006|^61891007|^61891008|^61891010|^61891011|^61891012|^6189162|^6189164|^6721/.test(routingDig))
  		codeLength = 4;
  	else if ( /^20|^27|^30|^31|^32|^33|^34|^36|^39|^40|^41|^43|^44|^45|^46|^47|^48|^49|^51|^52|^53|^54|^55|^56|^57|^58|^60|^61|^62|^63|^64|^65|^66|^81|^82|^84|^86|^87|^90|^91|^92|^93|^94|^95|^98/.test(routingDig) )
  		codeLength = 2;
  	else if ( /^1|^7/.test(routingDig) )
  		codeLength = 1;

  	countryCode = routingDig.substring(0, codeLength);

  	return pool.query("select regionid, CONCAT(prefix,regioncode) as routingDigits,prefix from accounting_region where prefix = '" + countryCode + "' order by regioncode desc")
  	.then(function(res) {
  		var match;
  		for (var i = 0; i < res.length && !match; i++) {
  			var re = new RegExp("^" + res[i].routingDigits);
  			if (re.test(routingDig))
  				match = res[i].regionid;
  		}
  		return {
  			regionId: match,
  			countryCode: countryCode
  		};
  	})
  	.catch(console.log)
  },

  insertCdrData: function(insertData) {
    return pool.query('insert into accounting_cdr values ' + insertData);
  },

  closePool: function() {
    pool.end();
  }
};
