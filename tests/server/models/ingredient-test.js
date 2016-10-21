var Sequelize = require('sequelize');
var seed = require('../../../testseed');

var sinon = require('sinon');
var expect = require('chai').expect;

// Require in all models.
require('../../../server/db/models');

var path = require('path');
var Ingredient = require(path.join(__dirname, '../../../server/db/models/tenant')).Ingredient;

describe('Ingredient', function () {

	beforeEach('Clear test db, establish a connection to new db, and seed db', function (done) {
		seed.connect();
		done();
	});

	describe('Ingredient Methods', function () {
		//No methods currently on model
	});
});
