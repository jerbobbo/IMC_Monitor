'use strict';

var fsp = require('fs-promise');
var mysql = require('promise-mysql');
//var db;
//var config = require('../config/db-config');
var getDbConnection = require('../config/db-connection');
var Promise = require('bluebird');

var timestamp = new Date();

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
			var lines = data.split('/n');
			console.log(lines);
		})
		.catch(console.log)
	}
	//console.log(files);
});

Promise.using(getDbConnection(), function(conn) {
	return conn.query('select * from accounting_intc')
})
.then( function(rows) {
	console.log(rows);
})
.catch(console.log);
