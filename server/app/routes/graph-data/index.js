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
  console.log(req.query.country);
  console.log('you got here');
  // var groupBy = ['batch_time'];
  var now = new Date();
  // now.setHours(now.getHours() + 4);
  var yesterday = new Date();
  yesterday.setHours(yesterday.getHours() - 4);
  yesterday.setDate(yesterday.getDate() - 1);
  // yesterday.setDate(yesterday.getDate() - 1);
  var ageRange = [yesterday, now];
  var countryName = req.query.country || '%';
  var originMemberId = req.query.originMemberId || '%';
  var termMemberId = req.query.termMemberId || '%';
  var routeCodeId = req.query.routeCodeId || '%';
  var gwId = req.query.gwId || '%';

  accountingSummaryModel.findAll({
    attributes: [
      'batch_time',
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
          $like: countryName
        }
     }
    }],
    where: {
      batch_time: {
        $between: ageRange
      },
      route_code_id: {
        $like: routeCodeId
      },
      origin_member_id: {
        $like: originMemberId
      },
      term_member_id: {
        $like: termMemberId
      },
      gw_id: {
        $like: gwId
      }
    },
    group: 'batch_time'
  })
  .then(function(data) {
    // console.log('graph data:', data);
    res.status(200).json(data);
  }, next);
});

module.exports = router;
