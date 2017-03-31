app.controller('GraphListCtrl', ($scope) => {

  $scope.removeGraph = (idx) => {
    $scope.graphList.splice(idx, 1);
  };

  $scope.moveUp = (idx) => {
    var currentGraph = $scope.graphList[idx];
    $scope.graphList[idx] = $scope.graphList[idx-1];
    $scope.graphList[idx-1] = currentGraph;
  };

  $scope.moveDown = (idx) => {
    var currentGraph = $scope.graphList[idx];
    $scope.graphList[idx] = $scope.graphList[idx+1];
    $scope.graphList[idx+1] = currentGraph;
  };

  $scope.$watch( () => $scope.graphList,
    () => { console.log($scope.graphList) } );

});

app.directive('graphList', () => {
  return {
    restrict: 'E',
    scope: {
      graphList: '=',
      playlistId: '@'
    },
    templateUrl: '/js/common/directives/graph-list/graph-list.html',
    controller: 'GraphListCtrl'
  };
});
