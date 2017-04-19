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
          name: '@',
          index: '@'
        },
        templateUrl: 'js/common/directives/tab-graph/tab-graph.html',

        controller: function($scope, GraphFactory) {
          $scope.interval = "daily";

          function init() {
            var params = `country=${ $scope.params.country }&routeCodeId=${ $scope.params.routeCodeId }&originMemberId=${ $scope.params.originMemberId }&termMemberId=${ $scope.params.termMemberId }&gwId=${ $scope.params.gwId }&interval=${ $scope.interval }`;

            GraphFactory.getData(params)
            .then(function(results) {
              $scope.data = results;

              $scope.graphTypes = ['ASR', 'ACD', 'Seizures', 'AnsDel', 'NoCirc', 'Normal', 'Failure'];
              $scope.intervalTypes = ['daily', 'weekly', 'monthly', 'yearly'];
              $scope.originTypes = ['Origin', 'Term'];
              $scope.currType = $scope.currType || $scope.graphTypes[0];
              $scope.originTerm = 'origin';

            });
          }

          init();

          $scope.toggleState = (type) => $scope.currType = type;
          $scope.toggleOrigin = (type) => $scope.originTerm = type.toLowerCase();

          $scope.isCurrentType = (type) => $scope.currType == type;
          $scope.isCurrentOrigin = (type) => $scope.originTerm == type.toLowerCase();
          $scope.isCurrentInterval = (interval) => $scope.interval == interval;

          $scope.changeInterval = (interval) => {
            $scope.interval = interval;
            init();
          };

          $scope.$watch( 'index', () =>  init() );

          window.setInterval( () => init(), 300000 );


        }
    };

});
