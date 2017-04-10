app.factory('GraphListFactory', ($http) => {
  return {
    fetchGraphs: (playlistId) => {
      return $http.get(`/api/playlists/${playlistId}`)
      .then( (results) => {
        var graphArray = results.data.playlist_graphs;
        graphArray.forEach( (graph) => {
          graph.params = {
            country: graph.country === "" ? "%" : graph.country,
            routeCodeId: graph.route_code_id === 0 ? "%" : graph.route_code_id,
            originMemberId: graph.origin_member_id === 0 ? "%" : graph.origin_member_id,
            termMemberId: graph.term_member_id === 0 ? "%" : graph.term_member_id,
            gwId: graph.gw_id === 0 ? "%" : graph.gw_id
          };
          graph.graphTitle = graph.title;
        });
        return {
          graphList: graphArray,
          playlistName: results.data.name
        };
      });
    }
  };
});

app.controller('GraphListCtrl', ($scope, GraphListFactory) => {

  // if ($scope.playlistId) {
  //   $scope.playlistId = +$scope.playlistId;
  //   GraphListFactory.fetchGraphs($scope.playlistId)
  //   .then( (results) => {
  //     $scope.graphList = results.graphList;
  //     $scope.playlistName = results.playlistName;
  //     console.log('results', results);
  //   });
  // }

  $scope.removeGraph = (idx) => {
    $scope.graphList.splice(idx, 1);
  };

  $scope.moveUp = (idx) => {
    var currentGraph = $scope.graphList[idx];
    currentGraph.order--;
    $scope.graphList[idx] = $scope.graphList[idx-1];
    $scope.graphList[idx].order++;
    $scope.graphList[idx-1] = currentGraph;
  };

  $scope.moveDown = (idx) => {
    var currentGraph = $scope.graphList[idx];
    currentGraph.order++;
    $scope.graphList[idx] = $scope.graphList[idx+1];
    $scope.graphList[idx].order--;
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
      playlist: '='
    },
    templateUrl: '/js/common/directives/graph-list/graph-list.html',
    controller: 'GraphListCtrl'
  };
});
