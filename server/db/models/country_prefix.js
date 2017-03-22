'use strict';
var path = require('path');
var db = require(path.join(__dirname, '../')).db;
var Sequelize = require('sequelize');
var AccountingRegion = require(path.join(__dirname, 'accounting_region'));

var CountryPrefix = db.define('country_prefix', {
    prefix: {
      type: Sequelize.STRING,
      allowNull: false,
      primaryKey: true
    },
    country: {
      type: Sequelize.STRING,
      allowNull: false
    }
  },
  {
    timestamps: false,
    tableName: 'country_prefix'
});

CountryPrefix.belongsTo(AccountingRegion, {foreignKey: 'prefix', targetKey: 'prefix'});
module.exports = CountryPrefix;
