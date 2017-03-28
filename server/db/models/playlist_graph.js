'use strict';
var path = require('path');
var db = require(path.join(__dirname, '../')).db;
var Sequelize = require('sequelize');
var Playlist = require(path.join(__dirname, 'playlist'));

var PlaylistGraph = db.define('playlist_graph', {

    order: {
      type: Sequelize.INTEGER,
      allowNull: false
    },
    title: {
      type: Sequelize.STRING,
      allowNull: false
    },
    country: {
      type: Sequelize.STRING,
      allowNull: false
    },
    route_code_id: {
      type: Sequelize.INTEGER,
      allowNull: false
    },
    origin_member_id: {
      type: Sequelize.INTEGER,
      allowNull: false
    },
    term_member_id: {
      type: Sequelize.INTEGER,
      allowNull: false
    },
    gw_id: {
      type: Sequelize.INTEGER,
      allowNull: false
    }

  },
  {
    timestamps: false
});

PlaylistGraph.belongsTo(Playlist, { foreignKey: 'playlist_id' });
module.exports = PlaylistGraph;
