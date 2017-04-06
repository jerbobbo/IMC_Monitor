'use strict';
var path = require('path');
var router = require('express').Router();
var playlistModel = require(path.join(__dirname, '../../../db/models/playlist'));
var playlistGraphModel = require(path.join(__dirname, '../../../db/models/playlist_graph'));
var Sequelize = require('sequelize');

var ensureAuthenticated = function (req, res, next) {
    if (req.isAuthenticated()) {
        next();
    } else {
        res.status(401).end();
    }
};

router.get('/:id', ensureAuthenticated, function (req, res, next) {
  playlistModel.findById(req.params.id, { include: [ playlistGraphModel ]})
  .then( (playlist) => res.status(200).json(playlist), next );
});

router.get('/', ensureAuthenticated, function(req, res, next) {
  playlistModel.findAll({
    id: req.user.id
  })
  .then(function(data) {
    res.status(200).json(data);
  }, next);
});

router.post('/:playlistId/playlist-graph', ensureAuthenticated, function(req, res, next) {
  var newGraph = req.body;
  newGraph.playlist_id = req.params.playlistId;
  playlistGraphModel.create({
    playlist_id: newGraph.playlist_id,
    order: newGraph.order,
    title: newGraph.graphTitle,
    country: newGraph.params.country,
    route_code_id: newGraph.params.routeCodeId,
    origin_member_id: newGraph.params.originMemberId,
    term_member_id: newGraph.params.termMemberId,
    gw_id: newGraph.params.gwId
  })
  .then(function(data) {
    res.status(201).json(data);
  }, next);
});

router.post('/', ensureAuthenticated, function(req, res, next) {
  playlistModel.create({
    user_id: req.user.id,
    name: req.body.name
  })
  .then(function(data) {
    res.status(201).json(data);
  }, next);
});



module.exports = router;
