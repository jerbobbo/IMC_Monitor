var Sequelize = require('sequelize');
var Promise = require('bluebird');
var chalk = require('chalk');
var dbConnect = require('./server/db').connect;
var db = require('./server/db').db;
var Models = require('./server/db/models');
// var TenantModels = require('./server/db/models/tenant');

var seedUsers = function () {

    var users = [
        {
            name: 'testing',
            email: 'testing@fsa.com',
            password: 'password'
        },
        {
            name: 'obama',
            email: 'obama@gmail.com',
            password: 'potus'
        }
    ];

    return Models.User.bulkCreate(users);

};
//
// var seedCompany = function () {
//
//     var companies = [
//         {
//             name: 'Brewtastic',
//             details: {
//               billing_address: '10 north pole',
//               city: 'canada city',
//               state: 'ME',
//               zip: '12345',
//               active: true
//             }
//         },
//         {
//             name: 'We Be Brewing',
//             details: {
//               billing_address: '10 north pole',
//               billing_address_2: 'apt 305',
//               city: 'canada city',
//               state: 'ME',
//               zip: '12345',
//               active: true
//             }
//         }
//     ];
//
//     return Models.Company.bulkCreate(companies);
//
// };
//
// var seedCompanyUser = function () {
//
//     var company_users = [
//         {
//             companyId: 1,
//             userId: 1,
//             permissions: {
//               admin: true,
//               roles: ['batches', 'sales', 'recipes']
//             }
//         },
//         {
//           companyId: 2,
//           userId: 2,
//           permissions: {
//             admin: true,
//             roles: ['batches', 'sales', 'recipes']
//           }
//         }
//     ];
//
//     return Models.CompanyUser.bulkCreate(company_users);
//
// };
//
// var dropAllTenantSchemas = function() {
//   return db.query('SELECT nspname FROM pg_namespace ; ')
//   .then(function(results) {
//     var dropTenantSchemas = [];
//     for (var i=0; i<results[0].length; i++) {
//       if (results[0][i].nspname.substring(0,6) === 'tenant') {
//         dropTenantSchemas.push(db.query('DROP SCHEMA IF EXISTS ' + results[0][i].nspname + ' CASCADE'));
//       }
//     }
//     return Promise.all(dropTenantSchemas);
//   });
// };
//
// var seedTenant = function(id) {
//   console.log('you got here', id);
//   db.query('CREATE SCHEMA IF NOT EXISTS tenant' + id);
//
//   var currSchema = 'tenant' + id;
//   var newTenantModels = [];
//
//   return Promise.each(Object.keys(TenantModels), function(key) {
//
//     var tempModel = TenantModels[key].schema(currSchema);
//
//     if ("associate" in tempModel) {
//       tempModel.associate(TenantModels, currSchema);
//     }
//
//     return tempModel.sync({ force: true });
//   });
// };
//
//
//
// var seedIngredients = function (id) {
//
//     var ingredients = [
//         {
//             name: 'Cascade Pellet',
//             status: 'stat',
//             category: 'Hops',
//             details: {
//               name: 'Cascade Pellet',
//               unit: 'unit',
//               numberValue: 123,
//               stringValue: 'test',
//               textValue: 'test text value'
//             }
//         },
//         {
//             name: 'Yakima Pellet',
//             status: 'stat',
//             category: 'Hops',
//             details: {
//               name: 'Cascade Pellet',
//               unit: 'unit',
//               numberValue: 123,
//               stringValue: 'test',
//               textValue: 'test text value'
//             }
//         },
//         {
//             name: 'Yakima Leaf',
//             status: 'stat',
//             category: 'Hops',
//             details: {
//               name: 'Cascade Pellet',
//               unit: 'unit',
//               numberValue: 123,
//               stringValue: 'test',
//               textValue: 'test text value'
//             }
//         },
//         {
//             name: 'Water',
//             status: 'stat1',
//             category: '',
//             details: {
//               name: 'Water',
//               unit: 'unit1',
//               numberValue: 456,
//               stringValue: 'test1',
//               textValue: 'test text value1'
//             }
//         },
//         {
//             name: 'Pils',
//             status: 'stat1',
//             category: 'Malts',
//             details: {
//               name: 'Water',
//               unit: 'unit1',
//               numberValue: 456,
//               stringValue: 'test1',
//               textValue: 'test text value1'
//             }
//         }
//     ];
//   return TenantModels.Ingredient.schema('tenant' + id).bulkCreate(ingredients);
// };
//
// var seedVesselTypes = function (id) {
//
//     var vesselTypes = [
//       {
//         type: 'Fermentation Vessel',
//         details: {
//           description: 'For fermenting'
//         }
//       },
//       {
//         type: 'Bright Tank',
//         details: {
//           description: 'For making things brighter'
//         }
//       },
//       {
//         type: 'Mash + Boil',
//         details: {
//           description: 'For Mash + Boil'
//         }
//       }
//     ];
//   return TenantModels.VesselType.schema('tenant' + id).bulkCreate(vesselTypes);
// };
//
// var seedVessels = function (id) {
//
//     var vessels = [
//         {
//             name: 'FV001',
//             status: 'online',
//             vesselTypeId: 1,
//             details: {
//               capacityBBL: 123,
//               capacityL: 33,
//               manufacturer: 'test',
//               notes: 'test notes value'
//             }
//         },
//         {
//             name: 'BT001',
//             status: 'online',
//             vesselTypeId: 2,
//             details: {
//               capacityBBL: 123,
//               capacityL: 33,
//               manufacturer: 'test',
//               notes: 'test notes value'
//             }
//         },
//         {
//             name: 'MB001',
//             status: 'online',
//             vesselTypeId: 3,
//             details: {
//               capacityBBL: 123,
//               capacityL: 33,
//               manufacturer: 'test',
//               notes: 'test notes value'
//             }
//         },
//         {
//             name: 'FV002',
//             status: 'online',
//             vesselTypeId: 1,
//             details: {
//               capacityBBL: 200,
//               capacityL: 50,
//               manufacturer: 'test',
//               notes: 'test notes value'
//             }
//         },
//         {
//             name: 'BT002',
//             status: 'online',
//             vesselTypeId: 2,
//             details: {
//               capacityBBL: 150,
//               capacityL: 36,
//               manufacturer: 'test',
//               notes: 'test notes value'
//             }
//         },
//         {
//             name: 'MB002',
//             status: 'online',
//             vesselTypeId: 3,
//             details: {
//               capacityBBL: 150,
//               capacityL: 36,
//               manufacturer: 'test',
//               notes: 'test notes value'
//             }
//         }
//     ];
//     return Promise.each(vessels, function(vessel) {
//       return TenantModels.Vessel.schema('tenant' + id).create(vessel)
//       .then(function(_vessel) {
//         _vessel.setDataValue('vesselTypeId', vessel.vesselTypeId);
//         //_vessel.setDataValue('parentTypeId', step.parentTypeId);
//         return _vessel.save();
//       });
//     });
//   // return TenantModels.Vessel.schema('tenant' + id).bulkCreate(vessels);
// };
//
// var seedRecipeTypes = function(id) {
//   var recipeTypes = [
//     {
//       type: 'Lager',
//       details: {
//         description: 'like Bud'
//       }
//     },
//     {
//       type: 'Porter',
//       details: {
//         description: 'Dark and delicious'
//       }
//     },
//     {
//       type: 'Ale',
//       details: {
//         description: 'Clean and Crisp'
//       }
//     }
//   ];
//   return TenantModels.RecipeType.schema('tenant' + id).bulkCreate(recipeTypes);
// };
//
// var seedRecipes = function(id) {
//   var recipes = [
//       {
//           name: 'One Arm Bandit Lager',
//           status: 'online',
//           recipeTypeId: 1,
//           parentTypeId: null,
//           details: {
//             bblWort: 15,
//             duration: 10,
//             srm: 3.5,
//             ibu: 60,
//             originalGravitySG: 1.063,
//             finalGravitySG: 1.036,
//             abvPct: 5,
//             version: 1,
//             notes: 'make it like you mean it'
//           }
//       },
//       {
//           name: 'Cole Porter',
//           status: 'online',
//           recipeTypeId: 2,
//           parentTypeId: null,
//           details: {
//             bblWort: 10,
//             duration: 11,
//             srm: 3.2,
//             ibu: 40,
//             originalGravitySG: 1.022,
//             finalGravitySG: 1.079,
//             abvPct: 6,
//             version: 1,
//             notes: 'make it smooth like jazz'
//           }
//       },
//       {
//           name: 'Wacky Lager',
//           status: 'deleted',
//           recipeTypeId: 1,
//           parentTypeId: null,
//           details: {
//             bblWort: 16,
//             duration: 12,
//             srm: 3.2,
//             ibu: 40,
//             originalGravitySG: 1.022,
//             finalGravitySG: 1.079,
//             abvPct: 6,
//             version: 1,
//             notes: 'do not use'
//           }
//       },
//       {
//           name: 'Queens Ale',
//           status: 'online',
//           recipeTypeId: 3,
//           parentTypeId: null,
//           details: {
//             bblWort: 10,
//             duration: 15,
//             srm: 3.2,
//             ibu: 40,
//             originalGravitySG: 1.022,
//             finalGravitySG: 1.079,
//             abvPct: 6,
//             version: 1,
//             notes: 'Fit for a queen'
//           }
//       },
//
//   ];
//   return Promise.each(recipes, function(recipe) {
//     return TenantModels.Recipe.schema('tenant' + id).create(recipe)
//     .then(function(_recipe) {
//       _recipe.setDataValue('recipeTypeId', recipe.recipeTypeId);
//       //_recipe.setDataValue('parentTypeId', step.parentTypeId);
//       return _recipe.save();
//     });
//   });
// };
//
// var seedRecipeVessels = function(id) {
//   var recipeVessels = [
//     {
//       recipeId: 1,
//       vesselTypeId: 1,
//       orderNum: 0,
//       durationDays: 4,
//       log: {
//       }
//     },
//     {
//       recipeId: 1,
//       vesselTypeId: 2,
//       orderNum: 1,
//       durationDays: 5,
//       log: {
//       }
//     },
//     {
//       recipeId: 2,
//       vesselTypeId: 1,
//       orderNum: 0,
//       durationDays: 3,
//       log: {
//       }
//     },
//     {
//       recipeId: 2,
//       vesselTypeId: 2,
//       orderNum: 1,
//       durationDays: 6,
//       log: {
//       }
//     },
//     {
//       recipeId: 4,
//       vesselTypeId: 1,
//       orderNum: 0,
//       durationDays: 6,
//       log: {
//       }
//     },
//     {
//       recipeId: 4,
//       vesselTypeId: 2,
//       orderNum: 1,
//       durationDays: 8,
//       log: {
//       }
//     },
//   ];
//
//   return Promise.each(recipeVessels, function(vessel) {
//     return TenantModels.RecipeVessel.schema('tenant' + id).create(vessel)
//     .then(function(_vessel) {
//       _vessel.setDataValue('recipeId', vessel.recipeId);
//       _vessel.setDataValue('vesselTypeId', vessel.vesselTypeId);
//       return _vessel.save();
//     });
//   });
// };
//
// var seedRecipeSteps = function(id) {
//   var recipeSteps = [
//     {
//       name: 'Mash + Boil',
//       recipeVesselId: 1,
//       tankDay: 1,
//       log: {
//       }
//     },
//     {
//       name: 'Add Ingredients',
//       recipeVesselId: 2,
//       tankDay: 1,
//       log: {
//       }
//     },
//     {
//       name: 'Transfer from Tank',
//       recipeVesselId: 3,
//       tankDay: 1,
//       log: {
//
//       }
//     },
//     {
//       name: 'Bottle this batch',
//       recipeVesselId: 4,
//       tankDay: 3,
//       log: {
//
//       }
//     }
//   ];
//
//   return Promise.each(recipeSteps, function(step) {
//     return TenantModels.RecipeStep.schema('tenant' + id).create(step)
//     .then(function(_step) {
//       _step.setDataValue('recipeVesselId', step.recipeVesselId);
//       return _step.save();
//     });
//   });
// };
//
// var seedRecipeIngredients = function(id) {
//   var recipeIngredients = [
//     {
//       ingredientId: 1,
//       recipeStepId: 1,
//       quantity: 2,
//       units: 'Liters',
//       log: {
//       }
//     },
//     {
//       ingredientId: 2,
//       recipeStepId: 2,
//       quantity: 4,
//       units: 'ounces',
//       log: {
//       }
//     },
//     {
//       ingredientId: 1,
//       recipeStepId: 3,
//       quantity: 4,
//       units: 'Liters',
//       log: {
//       }
//     },
//     {
//       ingredientId: 2,
//       recipeStepId: 4,
//       quantity: 6,
//       units: 'lbs',
//       log: {
//       }
//     },
//   ];
//   //console.log(Object.keys(TenantModels.RecipeIngredient.schema('tenant' + id).rawAttributes));
//   return Promise.each(recipeIngredients, function(ingredient) {
//     return TenantModels.RecipeIngredient.schema('tenant' + id).create(ingredient)
//     .then(function(_ingredient) {
//       _ingredient.setDataValue('recipeStepId', ingredient.recipeStepId);
//       _ingredient.setDataValue('ingredientId', ingredient.ingredientId);
//       return _ingredient.save();
//     });
//   });
//   //return TenantModels.RecipeIngredient.schema('tenant' + id).bulkCreate(recipeIngredients);
// };
//
// var seedBatches = function(id) {
//   var today = new Date();
//   var batches = [
//       {
//           recipeId: 1,
//           startDate: new Date(),
//           batchSize: 50,
//           status: 'online',
//           details: {
//             name: 'A001',
//             bblWort: 15,
//             type: 'Lager',
//             duration: 10,
//             srm: 3.5,
//             ibu: 60,
//             originalGravitySG: 1.063,
//             finalGravitySG: 1.036,
//             abvPct: 5,
//             notes: 'make it like you mean it'
//           }
//       },
//       {
//           recipeId: 2,
//           startDate: new Date().setDate(today.getDate() + 3),
//           batchSize: 40,
//           status: 'online',
//           details: {
//             name: 'A002',
//             bblWort: 10,
//             type: 'Porter',
//             duration: 11,
//             srm: 3.2,
//             ibu: 40,
//             originalGravitySG: 1.022,
//             finalGravitySG: 1.079,
//             abvPct: 6,
//             version: 1,
//             notes: 'make it smooth like jazz'
//           }
//       }
//   ];
//   return Promise.each(batches, function(batch) {
//     return TenantModels.Batch.schema('tenant' + id).create(batch)
//     .then(function(_batch) {
//       _batch.setDataValue('recipeId', batch.recipeId);
//       return _batch.save();
//     });
//   });
// };
//
// var seedBatchVessels = function(id) {
//   var today = new Date();
//   var batchVessels = [
//     {
//       batchId: 1,
//       vesselId: 3,
//       startDate: today,
//       endDate: today,
//       duration: 1,
//       log: {
//       }
//     },
//     {
//       batchId: 1,
//       vesselId: 1,
//       startDate: new Date().setDate(today.getDate() + 0),
//       endDate: new Date().setDate(today.getDate() + 3),
//       duration: 4,
//       log: {
//       }
//     },
//     {
//       batchId: 1,
//       vesselId: 2,
//       startDate: new Date().setDate(today.getDate() + 3),
//       endDate: new Date().setDate(today.getDate() + 7),
//       duration: 5,
//       log: {
//       }
//     },
//     {
//       batchId: 2,
//       vesselId: 6,
//       startDate: new Date().setDate(today.getDate() + 3),
//       endDate: new Date().setDate(today.getDate() + 3),
//       duration: 1,
//       log: {
//       }
//     },
//     {
//       batchId: 2,
//       vesselId: 4,
//       startDate: new Date().setDate(today.getDate() + 3),
//       endDate: new Date().setDate(today.getDate() + 8),
//       duration: 6,
//       log: {
//       }
//     },
//     {
//       batchId: 2,
//       vesselId: 5,
//       startDate: new Date().setDate(today.getDate() + 8),
//       endDate: new Date().setDate(today.getDate() + 12),
//       duration: 5,
//       log: {
//       }
//     }
//   ];
//
//   return Promise.each(batchVessels, function(vessel) {
//     return TenantModels.BatchVessel.schema('tenant' + id).create(vessel)
//     .then(function(_vessel) {
//       _vessel.setDataValue('batchId', vessel.batchId);
//       _vessel.setDataValue('vesselId', vessel.vesselId);
//       return _vessel.save();
//     });
//   });
// };
//
// var seedBatchSteps = function(id) {
//   var batchSteps = [
//     {
//       name: 'Mash + Boil',
//       batchVesselId: 1,
//       tankDay: 1,
//       log: {
//       }
//     },
//     {
//       name: 'Transfer from Tank',
//       batchVesselId: 2,
//       tankDay: 1,
//       log: {
//       }
//     },
//     {
//       name: 'Add Ingredients',
//       batchVesselId: 2,
//       tankDay: 1,
//       log: {
//       }
//     },
//     {
//       name: 'Transfer from Tank',
//       batchVesselId: 3,
//       tankDay: 1,
//       log: {
//       }
//     },
//     {
//       name: 'Add Ingredients',
//       batchVesselId: 3,
//       tankDay: 1,
//       log: {
//       }
//     },
//     {
//       name: 'Bottle this batch',
//       batchVesselId: 3,
//       tankDay: 3,
//       log: {
//
//       }
//     },
//     {
//       name: 'Mash + Boil',
//       batchVesselId: 4,
//       tankDay: 1,
//       log: {
//       }
//     },
//     {
//       name: 'Transfer from Tank',
//       batchVesselId: 5,
//       tankDay: 1,
//       log: {
//       }
//     },
//     {
//       name: 'Add Ingredients',
//       batchVesselId: 5,
//       tankDay: 1,
//       log: {
//       }
//     },
//     {
//       name: 'Transfer from Tank',
//       batchVesselId: 6,
//       tankDay: 1,
//       log: {
//       }
//     },
//     {
//       name: 'Add Ingredients',
//       batchVesselId: 6,
//       tankDay: 1,
//       log: {
//       }
//     },
//     {
//       name: 'Bottle this batch',
//       batchVesselId: 6,
//       tankDay: 3,
//       log: {
//
//       }
//     }
//   ];
//
//   return Promise.each(batchSteps, function(step) {
//     return TenantModels.BatchStep.schema('tenant' + id).create(step)
//     .then(function(_step) {
//       _step.setDataValue('batchVesselId', step.batchVesselId);
//       return _step.save();
//     });
//   });
// };
//
// var seedBatchIngredients = function(id) {
//   var batchIngredients = [
//     {
//       ingredientId: 1,
//       batchStepId: 1,
//       containerId: null,
//       quantity: 2,
//       units: 'Liters',
//       details: {},
//       log: {}
//     },
//     {
//       ingredientId: 2,
//       batchStepId: 3,
//       containerId: null,
//       quantity: 4,
//       units: 'ounces',
//       log: {}
//     },
//     {
//       ingredientId: 1,
//       batchStepId: 3,
//       containerId: null,
//       quantity: 4,
//       units: 'Liters',
//       log: {}
//     },
//     {
//       ingredientId: 1,
//       batchStepId: 5,
//       containerId: null,
//       quantity: 6,
//       units: 'lbs',
//       log: {}
//     },
//     {
//       ingredientId: 1,
//       batchStepId: 7,
//       containerId: null,
//       quantity: 4,
//       units: 'Liters',
//       log: {}
//     },
//     {
//       ingredientId: 2,
//       batchStepId: 9,
//       containerId: null,
//       quantity: 4,
//       units: 'ounces',
//       log: {}
//     }
//   ];
//   //console.log(Object.keys(TenantModels.RecipeIngredient.schema('tenant' + id).rawAttributes));
//   return Promise.each(batchIngredients, function(ingredient) {
//     return TenantModels.BatchIngredient.schema('tenant' + id).create(ingredient)
//     .then(function(_ingredient) {
//       _ingredient.setDataValue('batchStepId', ingredient.batchStepId);
//       _ingredient.setDataValue('ingredientId', ingredient.ingredientId);
//       return _ingredient.save();
//     });
//   });
//   //return TenantModels.RecipeIngredient.schema('tenant' + id).bulkCreate(recipeIngredients);
// };

var seedTenantModelsAndData = function() {
  var companyList;
  return Models.Company.findAll()
  .then(function(companies) {
    companyList = companies;
    return Promise.each(companyList, function(company) {
      return seedTenant(company.id)
      .then(function() {
        return seedIngredients(company.id);
        })
      .then(function() {
        return seedVesselTypes(company.id);
        })
      .then(function() {
        return seedVessels(company.id);
        })
      .then(function() {
        return seedRecipeTypes(company.id);
        })
      .then(function() {
        return seedRecipes(company.id);
        })
      .then(function() {
        return seedRecipeVessels(company.id);
        })
      .then(function() {
        return seedRecipeSteps(company.id);
        })
      .then(function() {
        return seedRecipeIngredients(company.id);
        })
      .then(function() {
        return seedBatches(company.id);
        })
      .then(function() {
        return seedBatchVessels(company.id);
        })
      .then(function() {
        return seedBatchSteps(company.id);
        })
      .then(function() {
        return seedBatchIngredients(company.id);
      });
    });
  });
};

dbConnect()
    .then(function () {
     return db.sync({ force: true });
    })
    .then(function () {
      return seedUsers();
    })
    // .then(function () {
    //   return seedCompany();
    // })
    // .then(function () {
    //   return seedCompanyUser();
    // })
    // .then(function() {
    //   return dropAllTenantSchemas();
    // })
    // .then(function() {
    //   return seedTenantModelsAndData();
    // })
    .then(function () {
      console.log(chalk.green('Seed successful!'));
      process.kill(0);
    })
    .catch(function (err) {
      console.error(err);
      process.kill(1);
    });
