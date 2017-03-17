'use strict';
var path = require('path');
var db = require(path.join(__dirname, '../')).db;
var Sequelize = require('sequelize');

var AccountingGateway = db.define('accounting_gateway', {
    id: {
      type: Sequelize.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    address: {
      type: Sequelize.STRING,
      allowNull: false
    }
  },
  {
    timestamps: false
});

module.exports = AccountingGateway;
