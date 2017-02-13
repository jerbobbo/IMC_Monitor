'use strict';
var path = require('path');
var Sequelize = require('sequelize');
var chalk = require('chalk');

var DATABASE_URI = require(path.join(__dirname, '../env')).DATABASE_URI;
var DATABASE_PASS = require(path.join(__dirname, '../env')).DATABASE_PASS;
var DATABASE_USER = require(path.join(__dirname, '../env')).DATABASE_USER;

var db = new Sequelize (DATABASE_URI, DATABASE_USER, DATABASE_PASS , {
  dialect: 'mysql',
  port: 3306
});

var _conn;

module.exports = {
  db: db,
  connect: function() {
    if (_conn) return _conn;
    _conn = db.authenticate();
    console.log(chalk.blue('Connected to Database'));
    return _conn;
  }
};
