app.controller('GraphListCtrl', ($scope) => {

  $scope.removeGraph = (idx) => {

    $scope.graphList.splice(idx, 1);
    // $scope.graphList = $scope.graphList.filter( (elem, i) => {
    //   return i !== idx;
    // });
    // console.log('after delete', $scope.graphList);
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
