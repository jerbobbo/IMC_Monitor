'use strict';
var router = require('express').Router();
module.exports = router;

router.use('/members', require('./members'));
router.use('/graph-data', require('./graph-data'));
router.use('/table-data', require('./table-data'));
router.use('/gateways', require('./gateways'));
router.use('/countries', require('./countries'));
router.use('/region-names', require('./region-names'));
router.use('/playlists', require('./playlists'));
router.use('/playlist-graphs', require('./playlist-graphs'));
router.use('/users', require('./users'));

// Make sure this is after all of
// the registered routes!
router.use(function (req, res) {
    res.status(404).end();
});

router.use(function(err, req, res, next){
  if(err.status) {
    console.error('wooo');
    console.error(err);
    return res.status(err.status).send(err);
  }
  res.status(404).send(err);
});
