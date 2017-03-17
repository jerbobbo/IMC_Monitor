'use strict';
var path = require('path');
var router = require('express').Router();
var accountingGatewayModel = require(path.join(__dirname, '../../../db/models/accounting_gateway'));
var Sequelize = require('sequelize');

var ensureAuthenticated = function (req, res, next) {
    if (req.isAuthenticated()) {
        next();
    } else {
        res.status(401).end();
    }
};

router.get('/', ensureAuthenticated, function(req, res, next) {
  accountingGatewayModel.findAll({})
  .then(function(data) {
    res.status(200).json(data);
  }, next);
});

module.exports = router;
