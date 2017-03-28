//will be tab-graph in html tag
app.directive('tabGraph', function (d3Service, $window, GraphFactory) {

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
