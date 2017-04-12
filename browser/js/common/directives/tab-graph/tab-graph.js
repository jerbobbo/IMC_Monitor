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
          params: '=',
          graphTitle: '@',
          period: '@',
          name: '@',
          index: '@',
          twoColumns: '='
        },
        templateUrl: 'js/common/directives/tab-graph/tab-graph.html',

        controller: function($scope, GraphFactory) {
          function init() {
            var params = `country=${ $scope.params.country }&routeCodeId=${ $scope.params.routeCodeId }&originMemberId=${ $scope.params.originMemberId }&termMemberId=${ $scope.params.termMemberId }&gwId=${ $scope.params.gwId }`;

            GraphFactory.getData(params)
            .then(function(results) {
              $scope.data = results;

              $scope.graphTypes = ['ASR', 'ACD', 'Seizures', 'AnswerDelay', 'NoCircuit', 'Normal', 'Failure'];

              $scope.currType = $scope.graphTypes[0];
            });
          }

          init();

          $scope.toggleState = function(type) {
            $scope.currType = type;
          };

          $scope.isCurrentType = function(type) {
            return $scope.currType == type;
          };

          $scope.$watch( 'index', () => { init(); });

        }
    };

});
