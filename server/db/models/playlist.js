'use strict';
var path = require('path');
var db = require(path.join(__dirname, '../')).db;
var Sequelize = require('sequelize');
var User = require('./user');

var Playlist = db.define('playlist', {
    user_id: {
      type: Sequelize.STRING,
      allowNull: false
    },
    name: {
      type: Sequelize.STRING,
      allowNull: false
    }

  },
  {
    timestamps: false
});

module.exports = Playlist;
