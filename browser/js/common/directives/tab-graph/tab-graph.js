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

//will be tab-graph in html tag
app.directive('tabGraph', function (GraphFactory) {

    return {
        restrict: 'E',
        scope: {
          where: '@',
          graphTitle: '@',
          period: '@',
          name: '@',
          index: '@'
        },
        templateUrl: 'js/common/directives/tab-graph/tab-graph.html',

        controller: function($scope, GraphFactory) {
          var params = $scope.where;
          GraphFactory.getData(params)
          .then(function(results) {
            $scope.data = results;

            $scope.graphTypes = ['ASR', 'ACD', 'Seizures', 'AnswerDelay', 'NoCircuit', 'Normal', 'Failure'];

            $scope.currType = $scope.graphTypes[0];

            $scope.toggleState = function(type) {
              $scope.currType = type;
            };

            $scope.isCurrentType = function(type) {
              return $scope.currType == type;
            };

          });
        }
    };

});
