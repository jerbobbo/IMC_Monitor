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

router.get('/', (req, res, next) => {

  const query = req.query;

  models.AccountingSummaryPrimary.findAll({
    attributes: [],
    include: [{
      model: models.CountryPrefix,
      attributes: ['country'],
    }],
    where: {
      origin_member_id: { $like: query.originMemberId || '%' },
      term_member_id: { $like: query.termMemberId || '%' },
      origin_address_id: { $like: query.originAddressId || '%' },
      term_address_id: { $like: query.termAddressId || '%' },
      gw_id: { $like: query.gwId || '%' }
    },
    group: ['country'],
    order: ['country'],
    raw: true
  })
  .then( (results) => {
    res.status(200).json(results);
  }, next);
});

// router.get('/', ensureAuthenticated, (req, res, next) => {
//   models.CountryDistinct.findAll({
//     attributes: ['country']
//   })
//   .then(function(data) {
//     res.status(200).json(data);
//   }, next);
// });

module.exports = router;
