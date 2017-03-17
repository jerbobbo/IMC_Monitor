'use strict';
var path = require('path');
var db = require(path.join(__dirname, '../')).db;
var Sequelize = require('sequelize');

var CountryDistinct = db.define('country_distinct', {
    country: {
      type: Sequelize.STRING,
      allowNull: false
    }
  },
  {
    timestamps: false,
    tableName: 'country_distinct'
});

module.exports = CountryDistinct;
