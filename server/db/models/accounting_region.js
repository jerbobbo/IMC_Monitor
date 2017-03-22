'use strict';
var path = require('path');
var db = require(path.join(__dirname, '../')).db;
var Sequelize = require('sequelize');

var AccountingRegion = db.define('accounting_region', {
    prefix: {
      type: Sequelize.STRING,
      allowNull: false
    },
    region_name: {
      type: Sequelize.STRING,
      allowNull: false
    },
    region_code: {
      type: Sequelize.STRING,
      allowNull: false
    },
    mobile_proper: {
      type: Sequelize.BOOLEAN,
      allowNull: false
    },
    route_code: {
      type: Sequelize.INTEGER,
      allowNull: false
    },
    region_id: {
      type:Sequelize.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    date_region: {
      type: Sequelize.DATE,
      allowNull: false
    },
    transparent: {
      type: Sequelize.BOOLEAN,
      allowNull: false
    }
  },
  {
    timestamps: false,
    tableName: 'accounting_region'
});

module.exports = AccountingRegion;
