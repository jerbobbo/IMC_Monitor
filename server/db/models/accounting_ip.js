'use strict';
const path = require('path');
const db = require(path.join(__dirname, '../')).db;
const Sequelize = require('sequelize');

const AccountingIp = db.define('accounting_ip', {
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
    timestamps: false,
    tableName: 'accounting_ip'
});

module.exports = AccountingIp;
