'use strict';
var path = require('path');
var router = require('express').Router();
var models = require(path.join(__dirname, '../../../db/models/'));
var Sequelize = require('sequelize');

router.post('/', (req, res, next) => {
  return models.User.create(req.body)
  .then( (newUser) => res.status(201).send(newUser), next );
});

module.exports = router;
