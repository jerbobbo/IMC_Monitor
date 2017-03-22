'use strict';
var path = require('path');
var db = require(path.join(__dirname, '../')).db;
var Sequelize = require('sequelize');
var AccountingRegion = require(path.join(__dirname, 'accounting_region'));
var CountryPrefix = require(path.join(__dirname, 'country_prefix'));

var AccountingRegionName = db.define('accounting_region_name', {
    id: {
      type:Sequelize.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    country_code: {
      type: Sequelize.STRING,
      allowNull: false
    },
    region_name: {
      type: Sequelize.STRING,
      allowNull: false
    }
  },
  {
    timestamps: false,
    tableName: 'accounting_region_name'
});

AccountingRegionName.belongsTo(AccountingRegion, {foreignKey: 'id', targetKey: 'route_code'});
AccountingRegionName.belongsTo(CountryPrefix, {foreignKey: 'country_code'});

module.exports = AccountingRegionName;
