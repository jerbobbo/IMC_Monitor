'use strict';
var fsp = require('fs-promise');
var mysql = require('promise-mysql');
var config = require('../config/db-config');
var path = require('path');

var pool = mysql.createPool( {
	host: 'localhost',
	user: config.DATABASE_USER,
	password: config.DATABASE_PASS,
	database: config.DATABASE_URI,
  connectionLimt: 10
});

// console.log(path.join(__dirname, process.argv[2]));
pool.query('SET FOREIGN_KEY_CHECKS=0')
.then(function() {
  return pool.query('truncate table accounting_region');
})
.then(function() {
  fsp.readFile(path.join(__dirname, process.argv[2]), 'ascii')
  .then(function(data) {
    var lines = data.split('\n');
    lines.forEach(function(line, idx) {
      //console.log(line);
      var lineData = line.split('\t');
      if (lineData.length === 8) {
        var prefix = lineData[0],
        regionName = lineData[1],
        regionCode = lineData[2],
        mobileProper = lineData[3],
        routeCode = lineData[4],
        regionId = lineData[5];

        var dateData = lineData[6].split(' ');
        dateData = dateData[0].split('/');
        //pad with 0 if only 1 digit month or day
        dateData[0] = ((dateData[0].toString().length === 1) ? '0': '') + dateData[0];
        dateData[1] = ((dateData[1].toString().length === 1) ? '0': '') + dateData[1];
        var dateRegion = [dateData[2], dateData[0], dateData[1]].join('-');
        dateRegion += ' 00:00:00';
        var transparent = (lineData[7] = 'y') ? 1 : 0;

        var selectData = [prefix, regionName, regionCode, mobileProper, routeCode, regionId, dateRegion, transparent].join("','");

          console.log(selectData);
          pool.query("insert into accounting_region values ('" + selectData + "')")
          .catch(console.log)
      }

    });
  })
  .catch(console.log);
  pool.query('SET FOREIGN_KEY_CHECKS=1')
  .then(function() {
    pool.end();
  })
  .catch(console.log)
})
.catch(console.log);
