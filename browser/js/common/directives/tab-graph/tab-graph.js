//will be tab-graph in html tag
app.directive('tabGraph', function (d3Service, $window, GraphFactory) {

    return {
        restrict: 'E',
        scope: {
          where: '@',
          groupBy: '@',
          name: '@'
        },
        templateUrl: 'js/common/directives/tab-graph/tab-graph.html',

        controller: function($scope, GraphFactory) {
          // console.log('where:', $scope.where);
          // console.log('groupBy:', $scope.groupBy);
          // console.log('scope:', $scope);

          var params = $scope.where + '&groupBy=' + $scope.groupBy;
          GraphFactory.getData(params)
          .then(function(results) {
            $scope.data = results;

            $scope.graphTypes = [
              {
                name: 'asr',
                legend: 'ASR/ASRm',
                areaFunc: function(d) { return 100*d.completed/d.originSeiz; },
                lineFunc: function(d) { return 100*d.completed/d.originAsrmSeiz; },
                maxGraphHeight: function(data) { return d3.max(data, function(d) { return 100*d.completed/d.originAsrmSeiz; }); }
                // maxGraphHeight: function(data) {return 100;}
              }
            ];

            $scope.currType = $scope.graphTypes[0];

            $scope.toggleState = function(typeIdx) {
              $scope.currType = $scope.graphTypes[typeIdx];
            };

          });



        }
    };

});
