'use strict';
var path = require('path');
var router = require('express').Router();
var accountingSummaryModel = require(path.join(__dirname, '../../../db/models/accounting_summary'));
var countryPrefixModel = require(path.join(__dirname, '../../../db/models/country_prefix'));
var Sequelize = require('sequelize');

var ensureAuthenticated = function (req, res, next) {
    if (req.isAuthenticated()) {
        next();
    } else {
        res.status(401).end();
    }
};

router.get('/', ensureAuthenticated, function(req, res, next) {

  var intervalMap = {
    daily: {
      setOldest: (date) => {
        date.setHours(date.getHours() - 4);
        date.setDate(date.getDate() - 1);
      },
      groupBy: 'batch_time'
    },
    weekly: {
      setOldest: (date) => {
        date.setDate(date.getDate() - 8);
      },
      groupBy: 'batch_time_30'
    },
    monthly: {
      setOldest: (date) => {
        date.setDate(date.getDate() - 34);
      },
      groupBy: 'batch_time_120'
    },
    yearly: {
      setOldest: (date) => {
        date.setDate(date.getDate() - 395);
      },
      groupBy: 'batch_time_24h'
    },
  };

  var interval = intervalMap[req.query.interval];

  var whereClause = {
    route_code_id: {
      $like: req.query.routeCodeId
    },
    origin_member_id: {
      $like: req.query.originMemberId
    },
    term_member_id: {
      $like: req.query.termMemberId
    },
    gw_id: {
      $like: req.query.gwId
    }
  };


  // var now = convertDateToUTC( new Date() );
  var now = new Date();
  console.log('now', now);
  // var oldestDate = convertDateToUTC( new Date() );
  var oldestDate = new Date();
  console.log('oldestDate', oldestDate);
  interval.setOldest(oldestDate);
  console.log('oldestDate - changed', oldestDate);
  var ageRange = [oldestDate, now];

  whereClause[interval.groupBy] = {
    $between: ageRange
  };

  accountingSummaryModel.findAll({
    attributes: [
      interval.groupBy,
      'country_code',
      [Sequelize.fn('SUM', Sequelize.col('origin_seizures')), 'originSeiz'],
      [Sequelize.fn('SUM', Sequelize.col('completed')), 'completed'],
      [Sequelize.fn('SUM', Sequelize.col('conn_minutes')), 'connMinutes'],
      [Sequelize.fn('SUM', Sequelize.col('origin_asrm_seiz')), 'originAsrmSeiz'],
      [Sequelize.fn('SUM', Sequelize.col('origin_ner_seiz')), 'originNerSeiz'],
      [Sequelize.fn('SUM', Sequelize.col('origin_fsr_seiz')), 'originFsrSeiz'],
      [Sequelize.fn('SUM', Sequelize.col('origin_no_circ_disc')), 'originNoCirc'],
      [Sequelize.fn('SUM', Sequelize.col('origin_no_req_circ_disc')), 'originNoReqCirc'],
      [Sequelize.fn('SUM', Sequelize.col('origin_normal_disc')), 'originNormalDisc'],
      [Sequelize.fn('SUM', Sequelize.col('origin_failure_disc')), 'originFailDisc'],
      [Sequelize.fn('SUM', Sequelize.col('origin_ans_del')), 'originAnsDel'],
      [Sequelize.fn('SUM', Sequelize.col('origin_adj_ans_del')), 'originAdjAnsDel'],
      [Sequelize.fn('SUM', Sequelize.col('origin_packet_loss')), 'originPacketLoss'],
      [Sequelize.fn('SUM', Sequelize.col('origin_jitter')), 'originJitter'],
      [Sequelize.fn('SUM', Sequelize.col('term_asrm_seiz')), 'termAsrmSeiz'],
      [Sequelize.fn('SUM', Sequelize.col('term_ner_seiz')), 'termNerSeiz'],
      [Sequelize.fn('SUM', Sequelize.col('term_fsr_seiz')), 'termFsrSeiz'],
      [Sequelize.fn('SUM', Sequelize.col('term_no_circ_disc')), 'termNoCirc'],
      [Sequelize.fn('SUM', Sequelize.col('term_no_req_circ_disc')), 'termNoReqCirc'],
      [Sequelize.fn('SUM', Sequelize.col('term_normal_disc')), 'termNormalDisc'],
      [Sequelize.fn('SUM', Sequelize.col('term_failure_disc')), 'termFailDisc'],
      [Sequelize.fn('SUM', Sequelize.col('term_ans_del')), 'termAnsDel'],
      [Sequelize.fn('SUM', Sequelize.col('term_adj_ans_del')), 'termAdjAnsDel'],
      [Sequelize.fn('SUM', Sequelize.col('term_seizures')), 'termSeiz'],
      [Sequelize.fn('SUM', Sequelize.col('term_packet_loss')), 'termPacketLoss'],
      [Sequelize.fn('SUM', Sequelize.col('term_jitter')), 'termJitter']


    ],
    include: [{
      model: countryPrefixModel,
      attributes: [],
      where: {
        country: {
          $like: req.query.country
        }
     }
    }],
    where: whereClause,
    group: interval.groupBy
  })
  .then(function(data) {
    // console.log('graph data:', data);
    res.status(200).json(data);
  }, next);
});

function convertDateToUTC(date) {
  return new Date(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate(), date.getUTCHours(), date.getUTCMinutes(), date.getUTCSeconds());
}

module.exports = router;
