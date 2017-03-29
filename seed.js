var Sequelize = require('sequelize');
var Promise = require('bluebird');
var chalk = require('chalk');
var dbConnect = require('./server/db').connect;
var db = require('./server/db').db;
var Models = require('./server/db/models');
// var TenantModels = require('./server/db/models/tenant');

var seedUsers = function () {

    var users = [
        // {
        //     name: 'testing',
        //     email: 'testing@fsa.com',
        //     password: 'password'
        // },
        // {
        //     name: 'obama',
        //     email: 'obama@gmail.com',
        //     password: 'potus'
        // }
    ];

    return Models.User.bulkCreate(users);

};

dbConnect()
    // .then(function () {
    //  return db.sync({ force: true });
    // })
    .then(function () {
      return seedUsers();
    })
    .then(function () {
      console.log(chalk.green('Seed successful!'));
      process.kill(0);
    })
    .catch(function (err) {
      console.error(err);
      process.kill(1);
    });
