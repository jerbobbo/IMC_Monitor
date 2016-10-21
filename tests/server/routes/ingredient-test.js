var Sequelize = require('sequelize');
var seed = require('../../../testseed');

var sinon = require('sinon');
var expect = require('chai').expect;

var supertest = require('supertest');
var app = require('../../../server/app');

// Require in all models.
require('../../../server/db/models');

var path = require('path');
var Ingredient = require(path.join(__dirname, '../../../server/db/models')).Ingredient;

describe('Ingredient Routes', function () {

	var testIngredient = {
		name: 'Bitters',
		status: 'aStatus',
		category: 'aCategory',
		details: {
			name: 'aName',
          	unit: 'aUnit',
          	numberValue: 789,
          	stringValue: 'test2',
          	textValue: 'test text value2'
		}
	};

	beforeEach('Clear test db, establish a connection to new db, and seed db', function (done) {
		seed.connect()
		.then(function () {
			done();
		});
	});

	describe('Create an Ingredient', function () {

		it('should successfully add new Ingredient with response 201', function (done) {
			supertest.agent(app).post('/api/ingredient/', testIngredient)
			.expect(201);
			done();
		});
	});

	describe('Edit/Delete an Ingredient', function () {
		var ingId;

		beforeEach('Create test Ingredient', function (done) {
			Ingredient.create(testIngredient)
			.then(function (ingredient) {
				ingId = ingredient._id;
				done();
			});
		});

		it('should successfully edit some fields on the Ingredient', function (done) {
			testIngredient.status = 'newStatus';
			testIngredient.category = 'newCategory';

			supertest.agent(app).post('/api/ingredient/' + ingId, testIngredient)
			.expect(201);
			done();
		});

		it('should successfully delete the Ingredient with response 204', function (done) {
			supertest.agent(app).delete('/api/ingredient/' + ingId)
			.expect(204);
			done();
		});
	});

});
