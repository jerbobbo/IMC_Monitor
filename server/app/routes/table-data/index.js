'use strict';
const path = require('path');
const router = require('express').Router();
const models = require(path.join(__dirname, '../../../db/models'));
const Sequelize = require('sequelize');
const permission = require(path.join(__dirname, '../../configure/permission'));

const ensureAuthenticated = function (req, res, next) {
    if (req.isAuthenticated()) {
        next();
    } else {
        res.status(401).end();
    }
};

router.get('/', ensureAuthenticated, permission({ userPermission: true }), function(req, res, next) {

  // var whereClause = {
  //   route_code_id: {
  //     $like: req.query.routeCodeId || '%'
  //   },
  //   origin_member_id: {
  //     $like: req.query.originMemberId || '%'
  //   },
  //   term_member_id: {
  //     $like: req.query.termMemberId || '%'
  //   },
  //   gw_id: {
  //     $like: req.query.gwId || '%'
  //   }
  // };


  var ageRange = [req.query.from, req.query.to];
  var groupBy = req.query.groupBy.split(',');

  var countryAttributes = [],
    regionAttributes = [],
    gwAttributes = [],
    originAttributes = [],
    termAttributes = [];

  groupBy.forEach( (field) => {
    switch(field) {
      case 'country':
        countryAttributes.push(field);
        break;
      case 'region_name':
        regionAttributes.push(field);
        break;
      case 'address':
        gwAttributes.push(field);
        break;
      case 'OriginMemberName.name':
        originAttributes.push(['name', 'origin_member_name']);
        break;
      case 'TermMemberName.name':
        termAttributes.push(['name', 'term_member_name']);
    }
  });

  var includeSet = [
    {
    model: models.CountryPrefix,
    attributes: countryAttributes,
    where: {
      country: {
        $like: req.query.country || '%'
        }
      }
    },
    {
    model: models.AccountingRegionName,
    attributes: regionAttributes,
    where: {
      id: {
        $like: req.query.routeCodeId || '%'
        }
      }
    },
    {
    model: models.AccountingMembersName,
    as: 'OriginMemberName',
    attributes: originAttributes,
    where: {
      id: {
        $like: req.query.originMemberId || '%'
        }
      }
    },
    {
    model: models.AccountingMembersName,
    as: 'TermMemberName',
    attributes: termAttributes,
    where: {
      id: {
        $like: req.query.termMemberId || '%'
        }
      }
    },
    {
    model: models.AccountingGateway,
    attributes: gwAttributes,
    where: {
      id: {
        $like: req.query.gwId || '%'
        }
      }
    }
  ];

  console.log(includeSet);

  var aggregateAttr = [
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
  ];

  models.AccountingSummary.findAll({
    attributes: aggregateAttr,
    include: includeSet,
    // where: whereClause,
    group: groupBy,
    raw: true
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
