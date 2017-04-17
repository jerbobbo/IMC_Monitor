'use strict';
var path = require('path');
var router = require('express').Router();
var models = require(path.join(__dirname, '../../../db/models'));
var Sequelize = require('sequelize');
var Promise = require('bluebird');

var ensureAuthenticated = function (req, res, next) {
    if (req.isAuthenticated()) {
        next();
    } else {
        res.status(401).end();
    }
};

router.put('/:graphId', ensureAuthenticated, (req, res, next) => {
  models.PlaylistGraph.findById(req.params.graphId)
  .then( (_graph) => _graph.update( { order: req.body.order } ) )
  .then( (graph) => { res.status(200).json(graph); }, next );
});

router.delete('/:graphId', ensureAuthenticated, (req, res, next) => {
  var playlistId;

  models.PlaylistGraph.findById(req.params.graphId)
  .then( (graph) => {
    playlistId = graph.playlist_id;
    return graph.destroy();
  })
  .then( () => {
    return models.Playlist.findById(playlistId, {
      include: [ models.PlaylistGraph ],
      order: ['order']
    });
  })
  .then( (graphs) => {
    console.log('graphs', graphs);
    var newOrder = 0;
    return Promise.each(graphs.playlist_graphs, (graph) => graph.update( { order: newOrder++ }) );
  })
  .then( () => res.status(204).end() , next);
});



module.exports = router;
