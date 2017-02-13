app.config(function ($stateProvider) {
  $stateProvider.state('graphs', {
    url: '/graphs',
    templateUrl: 'js/graphs/graphs.html'
    // controller: 'GraphCtrl'
  });
});

app.factory('GraphFactory', function($http) {
  return {
    getData: function(params) {
      return $http.get('/api/graph-data?' + params)
      .then(function(response) {
        return response.data;
      });
    }
  };
});

// app.controller('GraphCtrl', function($scope, GraphFactory) {
//   var params = $scope.where + '&' + $scope.groupBy;
//   GraphFactory.getData(params)
//   .then(function(results) {
//     $scope.data = results;
//   });
// });
