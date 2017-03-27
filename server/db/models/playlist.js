'use strict';
var path = require('path');
var db = require(path.join(__dirname, '../')).db;
var Sequelize = require('sequelize');
var User = require(path.join(__dirname, 'user'));

var Playlist = db.define('playlist', {
    user_id: {
      type: Sequelize.STRING,
      allowNull: false
    }
  },
  {
    timestamps: false
});

Playlists.belongsTo(User, { foreignKey: 'user_id' });
module.exports = Playlist;
