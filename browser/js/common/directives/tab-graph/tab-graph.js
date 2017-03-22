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
          // console.log('where:', $scope.where);
          // console.log('groupBy:', $scope.groupBy);
          // console.log('scope:', $scope);

            //for when period is implemented:
          // var params = $scope.where + '&period=' + $scope.period;
          var params = $scope.where;
          GraphFactory.getData(params)
          .then(function(results) {
            $scope.data = results;

            $scope.graphTypes = ['ASR', 'ACD', 'Seizures', 'AnswerDelay', 'NoCircuit', 'Normal', 'Failure'];

            // $scope.graphTypes = [
            //   {
            //     name: 'ASR',
            //     legend: 'ASR/ASRm',
            //     areaFunc: function(d) { return 100*d.completed/d.originSeiz || 0; },
            //     lineFunc: function(d) { return 100*d.completed/d.originAsrmSeiz || 0; },
            //     maxGraphHeight: function(data) { return d3.max(data, function(d) { return 100*d.completed/d.originAsrmSeiz; }); }
            //     // maxGraphHeight: function(data) {return 100;}
            //   },
            //   {
            //     name: 'ACD',
            //     legend: 'ACD',
            //     areaFunc: function(d) { return d.connMinutes/d.completed || 0; },
            //     lineFunc: function(d) { return d.connMinutes/d.completed  || 0; },
            //     maxGraphHeight: function(data) { return d3.max(data, function(d) { return d.connMinutes/d.completed; }); }
            //     // maxGraphHeight: function(data) {return 100;}
            //   }
            // ];

            $scope.currType = $scope.graphTypes[0];

            $scope.toggleState = function(type) {
              $scope.currType = type;
              // console.log($scope.currType);
              // $scope.$digest();
            };

            $scope.isCurrentType = function(type) {
              return $scope.currType == type;
            };

          });



        }
    };

});
