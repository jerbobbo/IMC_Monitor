'use strict';
var path = require('path');
var router = require('express').Router();
var playlistModel = require(path.join(__dirname, '../../../db/models/playlist'));
var Sequelize = require('sequelize');

var ensureAuthenticated = function (req, res, next) {
    if (req.isAuthenticated()) {
        next();
    } else {
        res.status(401).end();
    }
};

router.get('/', ensureAuthenticated, function(req, res, next) {
  playlistModel.findAll({
    id: req.user.id
  })
  .then(function(data) {
    res.status(200).json(data);
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
