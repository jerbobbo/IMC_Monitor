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
    },
    updateOrder: (graph) => {
      return $http.put(`/api/playlist-graphs/${graph.id}`, graph)
      .then( (graph) => graph.data);
    },
    deleteGraph: (graphId) => $http.delete(`/api/playlist-graphs/${graphId}`)
  };
});

app.controller('GraphListCtrl', ($scope, GraphListFactory) => {

  $scope.removeGraph = (idx) => {
    if ($scope.playlist) {
      GraphListFactory.deleteGraph($scope.graphList[idx].id)
      .then( () => $scope.graphList.splice(idx, 1) );
    }
    else $scope.graphList.splice(idx, 1);
  };

  $scope.moveUp = (idx) => {
    var currentGraph = $scope.graphList[idx];
    currentGraph.order--;
    $scope.graphList[idx] = $scope.graphList[idx-1];
    $scope.graphList[idx].order++;
    $scope.graphList[idx-1] = currentGraph;
    updateOrderFromSwap(idx-1);
  };

  $scope.moveDown = (idx) => {
    var currentGraph = $scope.graphList[idx];
    currentGraph.order++;
    $scope.graphList[idx] = $scope.graphList[idx+1];
    $scope.graphList[idx].order--;
    $scope.graphList[idx+1] = currentGraph;
    updateOrderFromSwap(idx);
  };

  $scope.$watch( () => $scope.graphList,
    () => { console.log('graphList changed', $scope.graphList) } );

  function updateOrderFromSwap (idx){
    [idx, idx+1].forEach( (_idx) => GraphListFactory.updateOrder($scope.graphList[_idx]) );
  }

  $scope.twoColumns = {
    value: true
  };

  $scope.columnToggle = () => {
    $scope.twoColumns.value = !$scope.twoColumns.value;
  };

  $scope.columnText = () => $scope.twoColumns.value ? "Single Column" : "Two Columns";

});

app.directive('graphList', () => {
  return {
    restrict: 'E',
    scope: {
      graphList: '=',
      playlist: '=',
      twoColumns: '='
    },
    templateUrl: '/js/common/directives/graph-list/graph-list.html',
    controller: 'GraphListCtrl'
  };
});
