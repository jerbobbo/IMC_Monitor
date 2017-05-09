'use strict';
const path = require('path');
const router = require('express').Router();
const Sequelize = require('sequelize');
const models = require(path.join(__dirname, '../../../db/models/'));
const stripTableName = require(path.join(__dirname, '../../../helper/stripTableName'));

const ensureAuthenticated = (req, res, next) => {
    if (req.isAuthenticated()) {
        next();
    } else {
        res.status(401).end();
    }
};

router.get( '/', (req, res, next) => {

  const query = req.query;

  models.AccountingSummaryPrimary.findAll({
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
          country: { $like: query.country || '%' }
        }
      }
    ],
    where: {
      origin_member_id: { $like: query.originMemberId || '%' },
      term_member_id: { $like: query.termMemberId || '%' },
      origin_address_id: { $like: query.originAddressId || '%' },
      term_address_id: { $like: query.termAddressId || '%' },
      route_code_id: { $like: query.routeCodeId || '%' }
    },
    group: ['accounting_gateway.id', 'address'],
    order: ['address'],
    raw: true
  })
  .then( (results) => {
    results = stripTableName(results, 'address');
    res.status(200).json(results);
  }, next);
});

// router.get('/', ensureAuthenticated, (req, res, next) => {
//   models.AccountingGateway.findAll({})
//   .then(function(data) {
//     res.status(200).json(data);
//   }, next);
// });

module.exports = router;
