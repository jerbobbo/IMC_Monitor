'use strict';

var fsp = require('fs-promise');
var fs = require('fs');
var mysql = require('promise-mysql');
//var db;
const ftpConfig = require('../config/ftp-config');
//var getDbConnection = require('../config/db-connection');
var Promise = require('bluebird');
var fn = require('./cdr_import_functions');
var path = require('path');

var PromiseFtp = require('promise-ftp');

var timestamp = new Date();
const cdrDir = path.join(__dirname, '../seed/sansay_cdrs/');

var ftp = new PromiseFtp();
var fileNames = [];


fn.initialize()
.then(function() {
	return Promise.each(ftpConfig.SERVERS, fetchCDR);
})
.then(function() {
	console.log('All CDRs downloaded');
	return fsp.readdir(cdrDir);
})
.then(function(_files) {
	return _files.filter(fn.isCDR);
})
.then( function(files) {
	console.log('files:',files);
	fileNames = files;
	return Promise.each( files, importCDR );
})
.then(function() {
	console.log('all files imported');
	return clearCdrs(fileNames);
})
.then(function() {
	fn.closeDb();
})
.catch(console.log)


function clearCdrs (fileArr) {
	console.log('fileArr: ', fileArr);
	return Promise.each( fileArr, function(file) {
		fsp.remove(cdrDir + file);
	})
	.then(function() {
		console.log('cdr files deleted');
	})
	.catch(console.log)
}

function fetchCDR(serverUrl, idx) {
	var fileName;
	return ftp.connect( {
		host: serverUrl,
		user: ftpConfig.USERNAME,
		password: ftpConfig.PASSWORD
	})
	.then(function(serverMessage) {
		console.log('Server Message: ', serverMessage);
		return ftp.list('-t /CDR/*.cdr');
	})
	.then(function(list) {
		console.log(list[0]);
		fileName = list[0].name;
		return ftp.get('/CDR/' + fileName);
	})
	.then(function(stream) {
		return new Promise( function(resolve, reject) {
			stream.once('close', resolve);
			stream.once('error', reject);
			stream.pipe(fs.createWriteStream(cdrDir + idx + '-' + fileName));
		});
	})
	.then(function() {
		return ftp.end();
	})
	.catch(console.log)
}

function importCDR (file) {
	var batchNum;
	return fn.getNextBatchNum()
	.then(function(_num) {
		batchNum = _num;
		console.log('importing ', file);
		return fsp.readFile(path.join(cdrDir + file), 'ascii');
	})
	.then(function(data) {
		var lines = data.split('\n');
		if (lines.length === 0) console.log('file is empty');
		//console.log(lines);
		return Promise.map( lines, function(line) {
			var lineData = line.split(';');
			var insertData = [];
			if (fn.validateLine(lineData)) {
				var disconnectCause = +lineData[11],
				seizId = lineData[0],
				setupTime = fn.convertDate(lineData[6]),
				connectTime = fn.convertDate(lineData[7]),
				disconnectTime = fn.convertDate(lineData[8]),
				disconnectDate = new Date(lineData[8]),
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
				//routingDigits = fn.calcRoutingDigits(originCalledNumb),
				callDuration = lineData[53],
				postDialDelay = lineData[54],
				confId = lineData[57];

				//console.log(disconnectDate);

				var promiseArray = [];

				promiseArray.push(fn.findProtocolId(lineData[14]));
				promiseArray.push(fn.calcDestination(originCalledNumb, lineData[16]));
				//promiseArray.push(fn.findOrCreateAddressId(lineData[16]));
				promiseArray.push(fn.findOrCreateGatewayId(lineData[18]));
				promiseArray.push(fn.findProtocolId(lineData[33]));
				promiseArray.push(fn.findOrCreateAddressId(lineData[37]));
				promiseArray.push(fn.findOrCreateAddressId(lineData[39], true));
				promiseArray.push(fn.findOrCreateAddressId(lineData[20], true));

				return Promise.all(promiseArray)
				.then( function(results) {
					var originProtocolId = results[0],
					originAddressId = results[1].originAddressId,
					countryCode = results[1].countryCode,
					regionId = results[1].regionId,
					routeCode = results[1].routeCode,
					routingDigits = results[1].routingDigits,
					gwId = results[2],
					termProtocolId = results[3],
					termAddressId = results[4],
					termRemoteMediaId = results[5],
					originRemoteMediaId = results[6];

					// console.log(results);
						insertData.push( "(" + [
							seizId,
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
							regionId,
							routeCode
						].join(",") + ",NULL,NULL)" );
					return insertData;
				});
			}
			else {
				return;
			}
		})
		.then(function(result) {
			// if (result.length === 0) console.log('file was empty');
			var finalInsertData = result.filter( function(elem) {
				return elem !== undefined;
			});
			finalInsertData = finalInsertData.join(',');
			fsp.writeFile(path.join(__dirname, file + '-insertData.txt'), finalInsertData);
			// console.log('finalInsertData:', finalInsertData);
			return fn.insertCdrData(finalInsertData);
		})
		.then(function() {
			console.log(file, ' data was imported');
		})
		.catch(console.log)
	});
}
