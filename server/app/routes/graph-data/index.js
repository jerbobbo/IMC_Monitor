'use strict';
var path = require('path');
var router = require('express').Router();
var accountingSummaryModel = require(path.join(__dirname, '../../../db/models/accounting_summary'));
var Sequelize = require('sequelize');

router.get('/', function(req, res, next) {
  res.send('Hello');
});

router.post('/', function(req, res, next) {
  // var groupBy = req.body.groupBy;
  // var ageRange = req.body.ageRange;
  console.log('you got here');
  var groupBy = ['batch_time'];
  var now = new Date();
  // now.setHours(now.getHours() + 4);
  var yesterday = new Date();
  // yesterday.setHours(yesterday.getHours() + 4);
  yesterday.setDate(yesterday.getDate() - 1);
  var ageRange = [yesterday, now];

  accountingSummaryModel.findAll({
    attributes: [
      'batch_time',
      'country_code',
      [Sequelize.fn('SUM', Sequelize.col('origin_seizures')), 'originSeiz'],
      [Sequelize.fn('SUM', Sequelize.col('term_seizures')), 'termSeiz'],
      [Sequelize.fn('SUM', Sequelize.col('completed')), 'completed'],
      [Sequelize.fn('SUM', Sequelize.col('origin_asrm_seiz')), 'originAsrmSeiz']

    ],
    where: {
      batch_time: {
        $between: ageRange
      },
      country_code: '964'
    },
    group: groupBy
  })
  .then(function(data) {
    // console.log('graph data:', data);
    res.status(200).json(data);
  }, next);
});

module.exports = router;
