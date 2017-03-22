'use strict';
var path = require('path');
var router = require('express').Router();
var regionNameModel = require(path.join(__dirname, '../../../db/models/accounting_region_name'));
var countryPrefixModel = require(path.join(__dirname, '../../../db/models/country_prefix'));
var Sequelize = require('sequelize');

var ensureAuthenticated = function (req, res, next) {
    if (req.isAuthenticated()) {
        next();
    } else {
        res.status(401).end();
    }
};

router.get('/:countryName', ensureAuthenticated, function(req, res, next) {
  regionNameModel.findAll({
    include: [{
      model: countryPrefixModel,
      attributes: ['country'],
      where: { country: req.params.countryName }
    }]
  })
  .then(function(data) {
    res.status(200).json(data);
  }, next);
});

router.get('/', ensureAuthenticated, function(req, res, next) {
  regionNameModel.findAll({
    attributes: ['region_name'],
    group: ['region_name'],
    order: ['region_name']
  })
  .then(function(data) {
    res.status(200).json(data);
  }, next);
});

module.exports = router;
