'use strict';
var path = require('path');
var router = require('express').Router();
var Sequelize = require('sequelize');
var countryDistinctModel = require(path.join(__dirname, '../../../db/models/country_distinct'));

var ensureAuthenticated = function (req, res, next) {
    if (req.isAuthenticated()) {
        next();
    } else {
        res.status(401).end();
    }
};

router.get('/', ensureAuthenticated, function(req, res, next) {
  countryDistinctModel.findAll({
    attributes: ['country']
  })
  .then(function(data) {
    res.status(200).json(data);
  }, next);
});

module.exports = router;
