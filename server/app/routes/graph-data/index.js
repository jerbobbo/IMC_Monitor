'use strict';
var path = require('path');
var router = require('express').Router();
var accountingSummaryModel = require(path.join(__dirname, '../../../db/models/accounting_summary'));
var Sequelize = require('sequelize');

var ensureAuthenticated = function (req, res, next) {
    if (req.isAuthenticated()) {
        next();
    } else {
        res.status(401).end();
    }
};

router.get('/', ensureAuthenticated, function(req, res, next) {
  console.log(req.query.country);
  var groupBy = req.query.groupBy.split(',');
  console.log('groupBy: ', groupBy);
  // var ageRange = req.body.ageRange;
  console.log('you got here');
  // var groupBy = ['batch_time'];
  var now = new Date();
  // now.setHours(now.getHours() + 4);
  var yesterday = new Date();
  // yesterday.setHours(yesterday.getHours() + 4);
  yesterday.setDate(yesterday.getDate() - 1);
  var ageRange = [yesterday, now];
  var countryCode = req.query.country || '%';
  var originMemberId = req.query.originMember || '%';

  accountingSummaryModel.findAll({
    attributes: [
      'batch_time',
      'country_code',
      [Sequelize.fn('SUM', Sequelize.col('origin_seizures')), 'originSeiz'],
      [Sequelize.fn('SUM', Sequelize.col('term_seizures')), 'termSeiz'],
      [Sequelize.fn('SUM', Sequelize.col('completed')), 'completed'],
      [Sequelize.fn('SUM', Sequelize.col('origin_asrm_seiz')), 'originAsrmSeiz'],
      [Sequelize.fn('SUM', Sequelize.col('conn_minutes')), 'connMinutes']

    ],
    where: {
      batch_time: {
        $between: ageRange
      },
      country_code: {
        $like: countryCode
      }
    },
    group: groupBy
  })
  .then(function(data) {
    // console.log('graph data:', data);
    res.status(200).json(data);
  }, next);
});

module.exports = router;
