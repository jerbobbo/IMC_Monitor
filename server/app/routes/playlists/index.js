'use strict';
var path = require('path');
var router = require('express').Router();
var models = require(path.join(__dirname, '../../../db/models/'));
var Sequelize = require('sequelize');

var ensureAuthenticated = function (req, res, next) {
    if (req.isAuthenticated()) {
        next();
    } else {
        res.status(401).end();
    }
};

router.get('/:id', ensureAuthenticated, function (req, res, next) {
  models.Playlist.findById(req.params.id, {
    include: [ models.PlaylistGraph ],
    order: ['order']
  })
    .then( (playlist) => res.send(playlist), next );
});

router.get('/', ensureAuthenticated, function(req, res, next) {
  models.Playlist.findAll({
    where: {
      user_id: req.user.id
    }
  })
  .then(function(data) {
    res.status(200).json(data);
  }, next);
});

router.post('/:playlistId/playlist-graph', ensureAuthenticated, function(req, res, next) {
  var newGraph = req.body;
  newGraph.playlist_id = req.params.playlistId;
  models.PlaylistGraph.create({
    playlist_id: newGraph.playlist_id,
    order: newGraph.order,
    title: '',
    country: newGraph.params.country.country,
    route_code_id: newGraph.params.routeCode.id === '%' ? 0 : newGraph.params.routeCode.id,
    origin_member_id: newGraph.params.originMember.id === '%' ? 0 : newGraph.params.originMember.id,
    term_member_id: newGraph.params.termMember.id === '%' ? 0 : newGraph.params.termMember.id,
    origin_address_id: newGraph.params.originAddress.id === '%' ? 0 : newGraph.params.originAddress.id,
    term_address_id: newGraph.params.termAddress.id === '%' ? 0 : newGraph.params.termAddress.id,
    gw_id: newGraph.params.gw.id === '%' ? 0 : newGraph.params.gw.id
  })
  .then(function(data) {
    res.status(201).json(data);
  }, next);
});

router.post('/', ensureAuthenticated, function(req, res, next) {
  models.Playlist.create({
    user_id: req.user.id,
    name: req.body.name
  })
  .then(function(data) {
    res.status(201).json(data);
  }, next);
});



module.exports = router;
