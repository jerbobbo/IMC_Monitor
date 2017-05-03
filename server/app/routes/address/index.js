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

router.get('/origin', ensureAuthenticated, (req, res, next) => {

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
        model: models.AccountingIp,
        as: 'OriginAddress',
        attributes: ['id', 'address']
      }
    ],
    where: {
      origin_member_id: { $like: query.originMemberId || '%' },
      term_member_id: { $like: query.termMemberId || '%' },
      term_address_id: { $like: query.termAddressId || '%' },
      gw_id: { $like: query.gwId || '%' },
      route_code_id: { $like: query.routeCodeId || '%' }
    },
    group: ['OriginAddress.id', 'address'],
    order: ['address'],
    raw: true
  })
  .then(function(data) {
    res.status(200).json(data);
  }, next);
});

router.get('/term', ensureAuthenticated, (req, res, next) => {

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
        model: models.AccountingIp,
        as: 'TermAddress',
        attributes: ['id', 'address']
      }
    ],
    where: {
      term_member_id: { $like: query.termMemberId || '%' },
      origin_member_id: { $like: query.originMemberId || '%' },
      origin_address_id: { $like: query.originAddressId || '%' },
      gw_id: { $like: query.gwId || '%' },
      route_code_id: { $like: query.routeCodeId || '%' }
    },
    group: ['TermAddress.id', 'address'],
    order: ['address'],
    raw: true
  })
  .then(function(data) {
    res.status(200).json(data);
  }, next);
});


module.exports = router;
