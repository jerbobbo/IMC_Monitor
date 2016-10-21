'use strict';
var router = require('express').Router();
module.exports = router;

router.use('/members', require('./members'));

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
