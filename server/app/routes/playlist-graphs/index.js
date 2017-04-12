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

router.put('/:graphId', ensureAuthenticated, (req, res, next) => {
  playlistGraphModel.findById(req.params.graphId)
  .then( (_graph) => _graph.update( { order: req.body.order } ) )
  .then( (graph) => { res.status(200).json(graph); }, next );
});

router.delete('/:graphId', ensureAuthenticated, (req, res, next) => {
  playlistGraphModel.findById(req.params.graphId)
  .then( (graph) => graph.destroy() )
  .then( () => res.status(204).end() , next);
});



module.exports = router;
