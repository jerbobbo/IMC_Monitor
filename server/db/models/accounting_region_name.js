'use strict';
const path = require('path');
const db = require(path.join(__dirname, '../')).db;
const Sequelize = require('sequelize');
const AccountingRegion = require(path.join(__dirname, 'accounting_region'));
const CountryPrefix = require(path.join(__dirname, 'country_prefix'));

const AccountingRegionName = db.define('accounting_region_name', {
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
