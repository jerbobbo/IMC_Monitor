'use strict';

var fsp = require('fs-promise');
var mysql = require('promise-mysql');
//var db;
var config = require('../config/db-config');
//var getDbConnection = require('../config/db-connection');
var Promise = require('bluebird');
var fn = require('./cdr_import_functions');
var path = require('path');

var timestamp = new Date();

fn.initialize()
.then(function() {
	return fsp.readdir('../seed/cdr');
})
.then(function(_files) {
	return _files.filter(fn.isCDR);
})
.then( function(files) {
	//for testing on a failing cdr file, uncomment this line:
	//return Promise.each( files.slice(4,5), importCDR );
	return Promise.each( files, importCDR );
})
.then(function() {
	console.log('all files imported');
	fn.closeDb();
})
.catch(console.log)



function importCDR (file) {
	var batchNum;
	return fn.getNextBatchNum()
	.then(function(_num) {
		batchNum = _num;
		console.log(file);
		return fsp.readFile(path.join(__dirname, '../seed/cdr/' + file), 'ascii');
	})
	.then(function(data) {
		var lines = data.split('\n');
		return Promise.map( lines, function(line) {
			var lineData = line.split(';');
			var insertData = [];

			if (fn.validateLine(lineData)) {
				var disconnectCause = +lineData[11],
				setupTime = fn.convertDate(lineData[6]),
				connectTime = fn.convertDate(lineData[7]),
				disconnectTime = fn.convertDate(lineData[8]),
				originCallingNumb = lineData[15],
				originCalledNumb = lineData[17],
				originInPackets = lineData[25],
				originOutPackets = lineData[26],
				originInOctets = lineData[27],
				originOutOctets = lineData[28],
				originInPacketLoss = lineData[29],
				originInDelay = lineData[30],
				originInJitter = lineData[31],
				termCallingNumb = lineData[34],
				termCalledNumb = lineData[36],
				termInPackets = lineData[44],
				termOutPackets = lineData[45],
				termInOctets = lineData[46],
				termOutOctets = lineData[47],
				termInPacketLoss = lineData[48],
				termInDelay = lineData[49],
				termInJitter = lineData[50],
				// routingDigits = lineData[52],
				routingDigits = fn.calcRoutingDigits(originCalledNumb),
				callDuration = lineData[53],
				postDialDelay = lineData[54],
				confId = lineData[57];

				//console.log(lineData[14], lineData[33]);

				var promiseArray = [];

				promiseArray.push(fn.findProtocolId(lineData[14]));
				promiseArray.push(fn.findOrCreateAddressId(lineData[16]));
				promiseArray.push(fn.findOrCreateGatewayId(lineData[18]));
				promiseArray.push(fn.findProtocolId(lineData[33]));
				promiseArray.push(fn.findOrCreateAddressId(lineData[37]));
				promiseArray.push(fn.findOrCreateAddressId(lineData[39], true));
				promiseArray.push(fn.findOrCreateAddressId(lineData[20], true));
				promiseArray.push(fn.calcRegionIdAndCountryId(routingDigits));

				return Promise.all(promiseArray)
				.then( function(results) {
					var originProtocolId = results[0],
					originAddressId = results[1],
					gwId = results[2],
					termProtocolId = results[3],
					termAddressId = results[4],
					termRemoteMediaId = results[5],
					originRemoteMediaId = results[6],
					countryCode = results[7].countryCode,
					regionId = results[7].regionId;

					// console.log(results);
						insertData.push( "(" + [
							batchNum,
							setupTime,
							connectTime,
							disconnectTime,
							disconnectCause,
							fn.addQuotes(originCallingNumb),
							fn.addQuotes(originCalledNumb),
							originInPackets,
							originOutPackets,
							originInOctets,
							originOutOctets,
							originInPacketLoss,
							originInDelay,
							originInJitter,
							fn.addQuotes(termCallingNumb),
							fn.addQuotes(termCalledNumb),
							termInPackets,
							termOutPackets,
							termInOctets,
							termOutOctets,
							termInPacketLoss,
							termInDelay,
							termInJitter,
							fn.addQuotes(routingDigits),
							callDuration,
							postDialDelay,
							fn.addQuotes(confId),
							originProtocolId,
							originAddressId,
							gwId,
							termProtocolId,
							termAddressId,
							originRemoteMediaId,
							termRemoteMediaId,
							fn.addQuotes(countryCode),
							regionId
						].join(",") + ")" );
					return insertData;
				});
			}
			else {
				return;
			}
		})
		.then(function(result) {
			var finalInsertData = result.filter( function(elem) {
				return elem !== undefined;
			});
			finalInsertData = finalInsertData.join(',');
			//console.log(finalInsertData);
			return fn.insertCdrData(finalInsertData);
		})
		.then(function() {
			console.log(file, ' data was imported');
		})
		.catch(console.log)
	});
}
