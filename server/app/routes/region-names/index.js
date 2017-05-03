'use strict';
const path = require('path');
const router = require('express').Router();
const models = require(path.join(__dirname, '../../../db/models/'));
const Sequelize = require('sequelize');

const ensureAuthenticated = (req, res, next) => {
    if (req.isAuthenticated()) {
        next();
    } else {
        res.status(401).end();
    }
};

router.get('/', ensureAuthenticated, (req, res, next) => {

  const query = req.query;

  models.AccountingSummaryPrimary.findAll({
    attributes: [],
    include: [
      {
        model: models.CountryPrefix,
        attributes: [],
        where: { country: { $like: req.query.country || '%'} }
      },
      {
        model: models.AccountingRegionName,
        attributes: ['id', 'region_name']
      }
    ],
    where: {
      origin_member_id: { $like: query.originMemberId || '%' },
      term_member_id: { $like: query.termMemberId || '%' },
      origin_address_id: { $like: query.originAddressId || '%' },
      term_address_id: { $like: query.termAddressId || '%' },
      gw_id: { $like: query.gwId || '%' }
    },
    group: ['accounting_region_name.id', 'region_name'],
    order: ['region_name'],
    raw: true
  })
  .then(function(data) {
    res.status(200).json(data);
  }, next);
});

// router.get('/', ensureAuthenticated, (req, res, next) => {
//   models.AccountingRegionName.findAll({
//     attributes: ['region_name'],
//     group: ['region_name'],
//     order: ['region_name']
//   })
//   .then( (data) => {
//     res.status(200).json(data);
//   }, next);
// });

module.exports = router;
