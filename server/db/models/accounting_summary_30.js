/* jshint indent: 2 */

'use strict';
const path = require('path');
const db = require(path.join(__dirname, '../')).db;
const Sequelize = require('sequelize');
const CountryPrefix = require(path.join(__dirname, 'country_prefix'));
const AccountingRegionName = require(path.join(__dirname, 'accounting_region_name'));
const AccountingMembersName = require(path.join(__dirname, 'accounting_members_name'));
const AccountingGateway = require(path.join(__dirname, 'accounting_gateway'));

const AccountingSummary30 = db.define('accounting_summary_30', {

    batch_time_30: {
      type: Sequelize.TIME,
      allowNull: false,
      defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
      primaryKey: true
    },
    batch_num: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      primaryKey: true
    },
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
    },
    raw_seizures: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    origin_seizures: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    term_seizures: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    completed: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    origin_asrm_seiz: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    term_asrm_seiz: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    origin_ner_seiz: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    term_ner_seiz: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    origin_packet_loss: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    origin_jitter: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    term_packet_loss: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    term_jitter: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    conn_minutes: {
      type: Sequelize.DECIMAL,
      allowNull: false,
      defaultValue: "0.000000"
    },
    origin_ans_del: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    origin_adj_ans_del: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    term_ans_del: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    term_adj_ans_del: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    origin_normal_disc: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    origin_failure_disc: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    origin_no_circ_disc: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    origin_no_req_circ_disc: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    term_normal_disc: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    term_failure_disc: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    term_no_circ_disc: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    term_no_req_circ_disc: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    min_time: {
      type: Sequelize.DATE,
      allowNull: false
    },
    max_time: {
      type: Sequelize.DATE,
      allowNull: false
    },
    origin_fsr_seiz: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    },
    term_fsr_seiz: {
      type: Sequelize.INTEGER(11),
      allowNull: false,
      defaultValue: "0"
    }
  }, {
    tableName: 'accounting_summary_30',
    timestamps: false
  });

  AccountingSummary30.belongsTo(CountryPrefix, {foreignKey: 'country_code'} );
  AccountingSummary30.belongsTo(AccountingRegionName, {foreignKey: 'route_code_id'} );
  AccountingSummary30.belongsTo(AccountingMembersName, {as: 'OriginMemberName', foreignKey: 'origin_member_id'} );
  AccountingSummary30.belongsTo(AccountingMembersName, {as: 'TermMemberName', foreignKey: 'term_member_id'} );
  AccountingSummary30.belongsTo(AccountingGateway, {foreignKey: 'gw_id'} );

  module.exports = AccountingSummary30;
