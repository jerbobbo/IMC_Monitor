/* jshint indent: 2 */

'use strict';
const path = require('path');
const db = require(path.join(__dirname, '../')).db;
const Sequelize = require('sequelize');
const CountryPrefix = require(path.join(__dirname, 'country_prefix'));
const AccountingRegionName = require(path.join(__dirname, 'accounting_region_name'));
const AccountingMembersName = require(path.join(__dirname, 'accounting_members_name'));
const AccountingGateway = require(path.join(__dirname, 'accounting_gateway'));
const AccountingIp= require(path.join(__dirname, 'accounting_ip'));

const AccountingSummaryPrimary = db.define('accounting_summary_primary', {

    origin_member_id: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      primaryKey: true
    },
    term_member_id: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      primaryKey: true
    },
    origin_address_id: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      primaryKey: true
    },
    term_address_id: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      primaryKey: true
    },
    country_code: {
      type: Sequelize.STRING,
      allowNull: false,
      defaultValue: "",
      primaryKey: true
    },
    route_code_id: {
      type: Sequelize.INTEGER(11),
      allowNull: true,
      primaryKey: true
    },
    gw_id: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      primaryKey: true
    }
  }, {
    tableName: 'accounting_summary_primary',
    timestamps: false
  });

  AccountingSummaryPrimary.belongsTo(CountryPrefix, {foreignKey: 'country_code'} );
  AccountingSummaryPrimary.belongsTo(AccountingRegionName, {foreignKey: 'route_code_id'} );
  AccountingSummaryPrimary.belongsTo(AccountingMembersName, {as: 'OriginMemberName', foreignKey: 'origin_member_id'} );
  AccountingSummaryPrimary.belongsTo(AccountingMembersName, {as: 'TermMemberName', foreignKey: 'term_member_id'} );
  AccountingSummaryPrimary.belongsTo(AccountingIp, {as: 'OriginAddress', foreignKey: 'origin_address_id'} );
  AccountingSummaryPrimary.belongsTo(AccountingIp, {as: 'TermAddress', foreignKey: 'term_address_id'} );
  AccountingSummaryPrimary.belongsTo(AccountingGateway, {foreignKey: 'gw_id'} );

  module.exports = AccountingSummaryPrimary;
