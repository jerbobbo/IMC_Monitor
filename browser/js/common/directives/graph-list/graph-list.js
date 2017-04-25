app.factory('GraphListFactory', ($http) => {
  var _graphList = [];

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
    deleteGraphFromList: (idx) => $http.delete(`/api/playlist-graphs/${_graphList[idx].id}`),
    deletGraphFromView: (idx) => _graphList.splice(idx, 1),
    setGraphList: (graphData) => {
      angular.copy(graphData, _graphList);
    },
    clearGraphList: () => angular.copy([], _graphList),
    getLastGraphTitle: () => {
      if (_graphList.length) return [_graphList.length-1].graphTitle;
    },
    getGraphList: () => _graphList,
    addToGraphList: (graph) => {
      _graphList.push(graph);
    },
    isEmpty: () => _graphList.length === 0,
    swapOrder: (idx, next) => {
      var currentGraph = _graphList[idx];
      currentGraph.order++;
      _graphList[idx] = _graphList[next];
      _graphList[idx].order--;
      _graphList[next] = currentGraph;
      [idx, next].forEach( (_idx) => updateOrder(_graphList[_idx]) );
    },

  };
});

app.controller('GraphListCtrl', ($scope, GraphListFactory) => {
  // $scope.graphList = GraphListFactory.getGraphList();

  $scope.getGraphList = GraphListFactory.getGraphList;

  $scope.removeGraph = (idx) => {
    if ($scope.playlist) {
      GraphListFactory.deleteGraphFromList(idx)
      .then( () => GraphListFactory.deletGraphFromView(idx) );
    }
    else GraphListFactory.deletGraphFromView(idx);
  };

  $scope.moveUp = (idx) => GraphListFactory.swapOrder(idx-1, idx);

  $scope.moveDown = (idx) => GraphListFactory.swapOrder(idx, idx+1);

  // $scope.$watch( () => $scope.graphList,
  //   () => { console.log('graphList changed', $scope.graphList) } );

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
      playlist: '=',
      twoColumns: '='
    },
    templateUrl: '/js/common/directives/graph-list/graph-list.html',
    controller: 'GraphListCtrl'
  };
});
