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

function isCDR(fileName) {
	return fileName.substr(-3) === 'cdr';
}

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

					var originAddressId, memberId;
					if (lineData[16].length <= 16) {
						findOrCreateAddressId(lineData[16])
						.then(function(_id) {
							originAddressId = _id;
							return originAddressId;
						})
						.then(function(_originId) {
							findOrCreateMemberId(_originId)
							.then(function(_memberId) {
								memberId = _memberId;
								console.log('originID: ', originAddressId, ' memberId: ', memberId);
							});
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
			.then(function() {
				return pool.query("select id from accounting_ip where address like '" + address + "' limit 1");
			})
			.then(function(_res) {
				return _res[0].id;
			});
		}
	})
	.catch(console.log)
}

function findOrCreateMemberId(address_id) {
	return pool.query("select member_id from accounting_members where address_id like '" + address_id + "' limit 1")
	.then(function(res) {
		if (res.length > 0) return res[0].member_id;
		else {
			console.log('no id found: ', address_id);
			return pool.query("insert into accounting_members(member_id, address_id, type_id, vtr_id, intc_id) select 514, '" + address_id + "', 2, 3, 2")
			.then(function() {
				return pool.query("select member_id from accounting_members where address_id like '" + address_id + "' limit 1");
			})
			.then(function(_res) {
				return _res[0].member_id;
			});
		}
	})
	.catch(console.log)
}


// Promise.using(getDbConnection(), function(conn) {
// 	return conn.query('select * from accounting_intc')
// })
// .then( function(rows) {
// 	console.log(rows);
// })
// .catch(console.log);
