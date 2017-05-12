'use strict';
var path = require('path');
var db = require(path.join(__dirname, '../')).db;
var Sequelize = require('sequelize');
var Playlist = require('./playlist');

var PlaylistGraph = db.define('playlist_graph', {

    order: {
      type: Sequelize.INTEGER,
      allowNull: false
    },
    country: {
      type: Sequelize.STRING,
      allowNull: true
    },
    route_code_id: {
      type: Sequelize.INTEGER,
      allowNull: true
    },
    origin_member_id: {
      type: Sequelize.INTEGER,
      allowNull: true
    },
    term_member_id: {
      type: Sequelize.INTEGER,
      allowNull: true
    },
    origin_address_id: {
      type: Sequelize.INTEGER,
      allowNull: true
    },
    term_address_id: {
      type: Sequelize.INTEGER,
      allowNull: true
    },
    gw_id: {
      type: Sequelize.INTEGER,
      allowNull: true
    }

  },
  {
    timestamps: false
});

module.exports = PlaylistGraph;
