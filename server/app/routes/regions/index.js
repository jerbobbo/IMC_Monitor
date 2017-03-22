'use strict';
var path = require('path');
var router = require('express').Router();
var regionModel = require(path.join(__dirname, '../../../db/models/accounting_region'));
var Sequelize = require('sequelize');
var countryPrefixModel = require(path.join(__dirname, '../../../db/models/country_prefix'));

var ensureAuthenticated = function (req, res, next) {
    if (req.isAuthenticated()) {
        next();
    } else {
        res.status(401).end();
    }
};

router.get('/', ensureAuthenticated, function(req, res, next) {
  regionModel.findAll({
    include: [{
      model: countryPrefixModel,
      attributes: [[Sequelize.fn('DISTINCT', Sequelize.col('country'))]],
      where: { prefix: Sequelize.col('regionmodel.prefix') }
    }]
  })
  .then(function(data) {
    res.status(200).json(data);
  }, next);
});

module.exports = router;
