'use strict';
const path = require('path');
const router = require('express').Router();
const Sequelize = require('sequelize');
const models = require(path.join(__dirname, '../../../db/models/'));

const ensureAuthenticated = function (req, res, next) {
    if (req.isAuthenticated()) {
        next();
    } else {
        res.status(401).end();
    }
};

router.get('/:originMemberId/:termMemberId/:gwId', (req, res, next) => {

  const params = req.params;

  models.AccountingSummary30.findAll({
    attributes: [],
    include: [{
      model: models.CountryPrefix,
      attributes: ['country'],
    }],
    where: {
      origin_member_id: { $like: params.originMemberId === 'All' ? '%' : params.originMemberId },
      term_member_id: { $like: params.termMemberId === 'All' ? '%' : params.termMemberId },
      gw_id: { $like: params.gwId === 'All' ? '%' : params.gwId }
    },
    group: ['country'],
    order: ['country'],
    raw: true
  })
  .then( (results) => {
    res.status(200).json(results);
  }, next);
});

router.get('/', ensureAuthenticated, (req, res, next) => {
  models.CountryDistinct.findAll({
    attributes: ['country']
  })
  .then(function(data) {
    res.status(200).json(data);
  }, next);
});

module.exports = router;
