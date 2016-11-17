'use strict';

var fsp = require('fs-promise');
var mysql = require('promise-mysql');
//var db;
var config = require('../config/db-config');
//var getDbConnection = require('../config/db-connection');
//var Promise = require('bluebird');

var timestamp = new Date();

var pool = mysql.createPool( {
	host: 'localhost',
	user: config.DATABASE_USER,
	password: config.DATABASE_PASS,
	database: config.DATABASE_URI,
  connectionLimt: 10
});

var monitorlogfile ="IMC_Monitor.log";
var monitorcsvfile ="Monitor.sansay.csv";



fsp.readdir('../seed/cdr')
.then(function(_files) {
	return _files.filter(isCDR);
})
.then( function(files) {
	for (var i = 0; i < 1; i++) {
		console.log(files[i]);
		fsp.readFile('../seed/cdr/' + files[i], 'ascii')
		.then(function(data) {
			var lines = data.split('\n');
				lines.forEach( function(line) {
					var lineData = line.split(';');

					if (lineData.length === 71) {
						var hexDisconnectCause = decToHex(lineData[11]);
						var setupTime = convertDate(lineData[6]);
						var connectTime = convertDate(lineData[7]);
						var disconnectTime = convertDate(lineData[8]);
						var originCallingNumb = lineData[15];
						var originCalledNumb = lineData[17];
						var originInPackets = lineData[25];
						var originOutPackets = lineData[26];
						var originInOctets = lineData[27];
						var originOutOctets = lineData[28];
						var originInPacketLoss = lineData[29];
						var originInDelay = lineData[30];
						var originInJitter = lineData[31];
						var termCallingNumb = lineData[34];
						var termCalledNumb = lineData[36];



						var promiseArray = [];

						promiseArray.push(findProtocolId(lineData[14]));
						promiseArray.push(findOrCreateAddressId(lineData[16]));
						promiseArray.push(findOrCreateGatewayId(lineData[18]));
						promiseArray.push(findProtocolId(lineData[33]));
						promiseArray.push(findOrCreateAddressId(lineData[37]));
						promiseArray.push(findOrCreateAddressId(lineData[39]));
						promiseArray.push(findOrCreateAddressId(lineData[20]));

						Promise.all(promiseArray)
						.then( function(results) {
							var originProtocolId = results[0];
							var originAddressId = results[1];
							var gwId = results[2];
							var termProtocolId = results[3];
							var termAddressId = results[4];
							var termRemoteMediaId = results[5];
							var originRemoteMediaId = results[6];

							console.log(results);
						});

					}
				});
		})
		.catch(console.log)
	}
	//console.log(files);
});

function findOrCreateAddressId(address) {
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
}
function findOrCreateGatewayId(address) {
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

function findOrCreateMemberId(address_id) {
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

function findProtocolId(protocolType) {
	return pool.query("select id from voip_protocol where protocol like '" + protocolType + "' limit 1")
	.then(function(res) {
		if (res.length > 0) return res[0].id;
	})
	.catch(console.log)
}

function decToHex(num) {
	return (+num).toString(16);
}

function isCDR(fileName) {
	return fileName.substr(-3) === 'cdr';
}

function convertDate(dateString) {
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
}

// Promise.using(getDbConnection(), function(conn) {
// 	return conn.query('select * from accounting_intc')
// })
// .then( function(rows) {
// 	console.log(rows);
// })
// .catch(console.log);
