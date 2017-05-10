//will be spread-graph in html tag
app.directive('spreadGraph', function (GraphFactory) {

    return {
        restrict: 'E',
        scope: {
          params: '=',
          graphTitle: '@',
          name: '@',
          index: '@'
        },
        templateUrl: 'js/common/directives/spread-graph/spread-graph.html',

        controller: function($scope, GraphFactory) {
          $scope.params.interval = "daily";

          angular.extend($scope, GraphFactory);

          function init() {

            // var params = {
            //   country: $scope.params.country,
            //   routeCodeId: $scope.params.routeCodeId,
            //   originMemberId: $scope.params.originMemberId,
            //   termMemberId: $scope.params.termMemberId,
            //   originAddressId: $scope.params.originAddressId,
            //   termAddressId: $scope.params.termAddressId,
            //   gwId: $scope.params.gwId,
            //   fromDate: $scope.params.fromDate,
            //   toDate: $scope.params.toDate,
            //   interval: $scope.interval
            // };

            $scope.getData($scope.params)
            .then( (results) => {
              $scope.data = results;
              $scope.currType = $scope.currType || $scope.graphTypes[0];
              $scope.originTerm = $scope.originTerm || 'origin';
            });
          }

          init();

          $scope.toggleState = (type) => $scope.currType = type;
          $scope.toggleOrigin = (type) => $scope.originTerm = type.toLowerCase();

          $scope.isCurrentType = (type) => $scope.currType == type;
          $scope.isCurrentOrigin = (type) => $scope.originTerm == type.toLowerCase();
          $scope.isCurrentInterval = (interval) => $scope.params.interval == interval;

          $scope.changeInterval = (interval) => {
            $scope.params.interval = interval;
            init();
          };

          $scope.$watch( 'index', () =>  init() );

          window.setInterval( () => init(), 300000 );


        }
    };

});
