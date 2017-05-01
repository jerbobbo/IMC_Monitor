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

router.get('/:country/:originMemberId/:termMemberId', (req, res, next) => {

  const params = req.params;

  console.log(params);

  models.AccountingSummary30.findAll({
    attributes: [],
    include: [
      {
        model: models.AccountingGateway,
        attributes: ['id', 'address']
      },
      {
        model: models.CountryPrefix,
        attributes: [],
        where: {
          country: { $like: params.country === 'All' ? '%' : params.country }
        }
      }
    ],
    where: {
      origin_member_id: { $like: params.originMemberId === 'All' ? '%' : params.originMemberId },
      term_member_id: { $like: params.termMemberId === 'All' ? '%' : params.termMemberId },
    },
    group: ['id', 'address'],
    order: ['id', 'address'],
    raw: true
  })
  .then( (results) => {
    res.status(200).json(results);
  }, next);
});

router.get('/', ensureAuthenticated, function(req, res, next) {
  models.AccountingGateway.findAll({})
  .then(function(data) {
    res.status(200).json(data);
  }, next);
});

module.exports = router;
