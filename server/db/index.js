'use strict';
var path = require('path');
var Sequelize = require('sequelize');

var DATABASE_URI = require(path.join(__dirname, '../env')).DATABASE_URI;
var DATABASE_PASS = require(path.join(__dirname, '../env')).DATABASE_PASS;

var db = new Sequelize (DATABASE_URI, 'root', DATABASE_PASS , {
  dialect: 'mysql',
  port: 3306
});

var _conn;

module.exports = {
  db: db,
  connect: function() {
    if (_conn) return _conn;
    _conn = db.authenticate();
    return _conn;
  }
};
