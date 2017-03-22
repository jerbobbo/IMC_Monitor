'use strict';
var path = require('path');
var db = require(path.join(__dirname, '../')).db;
var Sequelize = require('sequelize');

var AccountingMembersName = db.define('accounting_members_name', {
    id: {
      type: Sequelize.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    name: {
      type: Sequelize.STRING,
      allowNull: false
    }
  },
  {
    timestamps: false,
    tableName: 'accounting_members_name'
});

module.exports = AccountingMembersName;
