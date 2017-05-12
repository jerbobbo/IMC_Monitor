app.factory('GraphListFactory', ($http) => {
  var _graphList = [];

  var GraphListFactory = {
    fetchGraphs: (playlistId) => {
      return $http.get(`/api/playlists/${playlistId}`)
      .then( (results) => {
        var graphArray = results.data.playlist_graphs;
        graphArray.forEach( (graph) => {
          graph.params = {
            country: { country: graph.country === "" ? "%" : graph.country },
            routeCode: { id: graph.route_code_id === 0 ? "%" : graph.route_code_id },
            originMember: { id: graph.origin_member_id === 0 ? "%" : graph.origin_member_id },
            termMember: { id: graph.term_member_id === 0 ? "%" : graph.term_member_id },
            originAddress: { id: graph.origin_address_id === 0 ? "%" : graph.origin_address_id },
            termAddress: { id: graph.term_address_id === 0 ? "%" : graph.term_address_id },
            gw: { id: graph.gw_id === 0 ? "%" : graph.gw_id }
          };
        });
        return {
          graphList: graphArray,
          playlistName: results.data.name
        };
      });
    },
    updateOrder: (idx) => {
      return $http.put(`/api/playlist-graphs/${_graphList[idx].id}`, graph)
      .then( (graph) => graph.data);
    },
    deleteGraphFromList: (idx) => $http.delete(`/api/playlist-graphs/${_graphList[idx].id}`),
    deletGraphFromView: (idx) => _graphList.splice(idx, 1),
    setGraphList: (graphData) => {
      angular.copy(graphData, _graphList);
    },
    clearGraphList: () => angular.copy([], _graphList),
    getGraphList: () => _graphList,
    getLastGraph: () => _graphList[_graphList.length-1],
    addToGraphList: (graphParams) => {
      var graphId = new Date().getTime();
      var graphOrder = _graphList.length;

      _graphList.push({
        // params: {
        //   country: graphParams.country.country,
        //   routeCodeId: graphParams.routeCode.id,
        //   originMemberId: graphParams.originMember.id,
        //   termMemberId: graphParams.termMember.id,
        //   originAddressId: graphParams.originAddress.id,
        //   termAddressId: graphParams.termAddress.id,
        //   gwId: graphParams.gw.id
        // },
        params: graphParams,
        id: graphId,
        order: graphOrder
      });
    },
    isEmpty: () => _graphList.length === 0,
    swapOrder: (idx, next) => {
      var currentGraph = _graphList[idx];
      currentGraph.order++;
      _graphList[idx] = _graphList[next];
      _graphList[idx].order--;
      _graphList[next] = currentGraph;
    },
  };

  return GraphListFactory;
});

app.controller('GraphListCtrl', ($scope, GraphListFactory) => {

  $scope.getGraphList = GraphListFactory.getGraphList;
  $scope.graphTypes = ['ASR', 'ACD', 'Seizures', 'AnsDel', 'NoCirc', 'Normal', 'Failure'];

  $scope.spread = { value: false };

  $scope.removeGraph = (idx) => {
    if ($scope.playlist) {
      GraphListFactory.deleteGraphFromList(idx)
      .then( () => GraphListFactory.deletGraphFromView(idx) );
    }
    else GraphListFactory.deletGraphFromView(idx);
  };

  $scope.moveUp = (idx) => {
    GraphListFactory.swapOrder(idx-1, idx);
    if ($scope.playlist) [idx-1, idx].forEach( (_idx) => GraphListFactory.updateOrder(_idx) );
  };

  $scope.moveDown = (idx) => {
    GraphListFactory.swapOrder(idx, idx+1);
    if ($scope.playlist) [idx, idx+1].forEach( (_idx) => GraphListFactory.updateOrder(_idx) );
};

  $scope.twoColumns = {
    value: true
  };

  $scope.columnToggle = () => {
    $scope.twoColumns.value = !$scope.twoColumns.value;
  };

  $scope.spreadToggle = () => {
    $scope.spread.value = !$scope.spread.value;
  };

  $scope.columnText = () => $scope.twoColumns.value ? "Single Column" : "Two Columns";
  $scope.spreadText = () => $scope.spread.value ? "Collapse" : "Expand";

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
