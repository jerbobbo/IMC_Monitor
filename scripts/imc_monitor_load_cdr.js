'use strict';

var fsp = require('fs-promise');
var mysql = require('promise-mysql');
//var db;
var config = require('../config/db-config');
//var getDbConnection = require('../config/db-connection');
var Promise = require('bluebird');
var fn = require('./cdr_import_functions');

var timestamp = new Date();


fsp.readdir('../seed/cdr')
.then(function(_files) {
	return _files.filter(fn.isCDR);
})
.then( function(files) {
	for (var i = 0; i < 1; i++) {
		console.log(files[i]);
		var batchNum;
		var insertData = [];
		fn.getNextBatchNum()
		.then(function(_num) {
			batchNum = _num;
			return fsp.readFile('../seed/cdr/' + files[i], 'ascii');
		})
		.then(function(data) {
			var lines = data.split('\n');
			lines.forEach( function(line) {
				var lineData = line.split(';');

				if (lineData.length === 71) {
					var disconnectCause = lineData[11],
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
					routingDigits = lineData[52],
					callDuration = lineData[53],
					postDialDelay = lineData[54],
					confId = lineData[57];

					var promiseArray = [];

					promiseArray.push(fn.findProtocolId(lineData[14]));
					promiseArray.push(fn.findOrCreateAddressId(lineData[16]));
					promiseArray.push(fn.findOrCreateGatewayId(lineData[18]));
					promiseArray.push(fn.findProtocolId(lineData[33]));
					promiseArray.push(fn.findOrCreateAddressId(lineData[37]));
					promiseArray.push(fn.findOrCreateAddressId(lineData[39]));
					promiseArray.push(fn.findOrCreateAddressId(lineData[20]));
					promiseArray.push(fn.calcRegionIdAndCountryId(lineData[52]));

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
						insertData.push( "('" + [
							batchNum,
							setupTime,
							connectTime,
							disconnectTime,
							disconnectCause,
							originCallingNumb,
							originCalledNumb,
							originInPackets,
							originOutPackets,
							originInPacketLoss,
							originInDelay,
							originInJitter,
							termCallingNumb,
							termCalledNumb,
							termInPackets,
							termOutPackets,
							termInOctets,
							termOutOctets,
							termInPacketLoss,
							termInDelay,
							termInJitter,
							routingDigits,
							callDuration,
							postDialDelay,
							confId,
							originProtocolId,
							originAddressId,
							gwId,
							termProtocolId,
							termAddressId,
							originRemoteMediaId,
							termRemoteMediaId,
							countryCode,
							regionId
						].join("','") + "')" );
						console.log(insertData);
					})
					.catch(console.log);
				}
			}); //end forEach

			.then(function() {
				insertData = insertData.join(',');
				console.log(insertData);
				fn.insertCdrData(insertData)
				.then(function() {
					console.log(files[i], ' data was imported');
				})
				.catch(console.log)
			}) //end readFile
			.catch(console.log)
		} //end for loop
		// fn.closePool();
	}) //end function(files)
	.catch(console.log)
