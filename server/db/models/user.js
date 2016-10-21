'use strict';
var crypto = require('crypto');
var db = require('../').db
var Sequelize = require('sequelize');
var _ = require('lodash');

var User = db.define('user', {
    name: {
      type: Sequelize.STRING
    },
    email: {
      type: Sequelize.STRING
    },
    password: {
      type: Sequelize.STRING
    },
    salt: {
      type: Sequelize.STRING
    }

  },
  {
    instanceMethods: {
      correctPassword: function (candidatePassword) {
          return encryptPassword(candidatePassword, this.salt) === this.password;
      },
      sanitize: function () {
        return _.omit(this.toJSON(), ['password', 'salt']);
      }
    },

    hooks: {
      beforeCreate: function (record) {
        generateSaltAndEncrypt.call(record.dataValues);
      },
      beforeBulkCreate: function (records, fields) {
        records.forEach(function(record) {
          generateSaltAndEncrypt.call(record.dataValues);
        });
      },
      beforeUpdate: function (instance) {
        if (instance.changed(password)) {
          generateSaltAndEncrypt.call(instance);
        }
      }
    }
  }

);

function generateSaltAndEncrypt() {
  this.salt = generateSalt();
  this.password = encryptPassword(this.password, this.salt);
}

// generateSalt, encryptPassword and the pre 'save' and 'correctPassword' operations
// are all used for local authentication security.
function generateSalt() {
    return crypto.randomBytes(16).toString('base64');
}

function encryptPassword (plainText, salt) {
    var hash = crypto.createHash('sha1');
    hash.update(plainText);
    hash.update(salt);
    return hash.digest('hex');
}

//Sequelize.models.user

module.exports = User;
