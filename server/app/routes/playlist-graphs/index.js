'use strict';
var path = require('path');
var router = require('express').Router();
var playlistGraphModel = require(path.join(__dirname, '../../../db/models/playlist_graph'));
var playlistModel = require(path.join(__dirname, '../../../db/models/playlist'));
var Sequelize = require('sequelize');

var ensureAuthenticated = function (req, res, next) {
    if (req.isAuthenticated()) {
        next();
    } else {
        res.status(401).end();
    }
};

// var ensureCorrectUser = function (req, res, next, graphUserId) {
//   if (req.user.id === graphUserId) next();
//   else res.status(401).end();
// };

// router.get('/:playlistId', ensureAuthenticated, function(req, res, next) {
//   playlistGraphModel.findAll({
//     playlist_id: req.params.playlistId,
//     include: [{
//       model: playlistModel
//     }]
//   })
//   .then(function(data) {
//     data.forEach( (graph) => {
//       if (graph.playlist.id !== req.user.id) return res.status(401).end();
//     });
//     res.status(200).json(data);
//   }, next);
// });

router.put('/:graphId', ensureAuthenticated, (req, res, next) => {
  playlistGraphModel.findById(req.params.graphId)
  .then( (_graph) => _graph.update( { order: req.body.order } ) )
  .then( (graph) => { res.status(200).json(graph); }, next );
});

router.post('/:playlistId', ensureAuthenticated, function(req, res, next) {
  var newGraph = req.body;
  newGraph.playlist_id = req.params.playlistId;
  playlistGraphModel.create(newGraph)
  .then(function(data) {
    res.status(201).json(data);
  }, next);
});

module.exports = router;
