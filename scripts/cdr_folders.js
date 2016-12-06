'use strict';

var fsp = require('fs-promise');
var fs = require('fs');
var mysql = require('promise-mysql');
//var db;
var config = require('../config/db-config');
//var getDbConnection = require('../config/db-connection');
var Promise = require('bluebird');
var path = require('path');

var timestamp = new Date();
var cdrDir = path.join(__dirname, '../seed/cdr/');

fsp.readdir(cdrDir)
.then(function(files) {
	files.forEach(function(file) {
		var folderName = file.substring(11, 15);
		var newFolder = path.join(__dirname, '../seed/cdr/', folderName)
		fsp.mkdir(newFolder)
		.then(function() {
			fsp.rename(path.join(__dirname, '../seed/cdr/', file), newFolder + '/' + file)
		})
		.catch(function() {
			fsp.rename(path.join(__dirname, '../seed/cdr/', file), newFolder + '/' + file)
		})
		.catch(console.log);

	});
});
