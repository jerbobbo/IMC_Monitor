'use strict';
var path = require('path');
var router = require('express').Router();
var accountingMembersNameModel = require(path.join(__dirname, '../../../db/models/accounting_members_name'));
var Sequelize = require('sequelize');

var ensureAuthenticated = function (req, res, next) {
    if (req.isAuthenticated()) {
        next();
    } else {
        res.status(401).end();
    }
};

router.get('/', ensureAuthenticated, function(req, res, next) {
  accountingMembersNameModel.findAll({})
  .then(function(data) {
    res.status(200).json(data);
  }, next);
});

module.exports = router;
