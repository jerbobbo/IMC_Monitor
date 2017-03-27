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
    graph_params: {
      type: Sequelize.STRING,
      allowNull: false
    }
  },
  {
    timestamps: false
});

PlaylistGraph.belongsTo(Playlist, { foreignKey: 'playlist_id' });
module.exports = PlaylistGraph;
