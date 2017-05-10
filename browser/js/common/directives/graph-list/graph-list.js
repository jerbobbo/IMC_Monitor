app.factory('GraphListFactory', ($http) => {
  var _graphList = [];
  var _lastGraphTitle = { value: '' };

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
          graph.graphTitle = graph.title;
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
    getLastGraphTitle: () => {
      if (_graphList.length) return _graphList[_graphList.length-1].graphTitle;
    },
    getGraphList: () => _graphList,
    getLastGraph: () => _graphList[_graphList.length-1],
    addToGraphList: (graphParams) => {
      var graphId = new Date().getTime();
      var graphOrder = _graphList.length;
      var graphTitle = "";

      for ( var key in graphParams) {
        if ( graphParams[key].name ) {
          if (graphTitle !== "") graphTitle += " | ";
          if (key === 'originMember') graphTitle += 'Origin: ';
          if (key === 'termMember') graphTitle += 'Term: ';
          graphTitle += graphParams[key].name;
        }
      }

      _graphList.push({
        params: {
          country: graphParams.country.country,
          routeCodeId: graphParams.routeCode.id,
          originMemberId: graphParams.originMember.id,
          termMemberId: graphParams.termMember.id,
          originAddressId: graphParams.originAddress.id,
          termAddressId: graphParams.termAddress.id,
          gwId: graphParams.gw.id
        },
        graphTitle: graphTitle,
        id: graphId,
        order: graphOrder
      });
      _lastGraphTitle.value = graphTitle;
    },
    isEmpty: () => _graphList.length === 0,
    swapOrder: (idx, next) => {
      var currentGraph = _graphList[idx];
      currentGraph.order++;
      _graphList[idx] = _graphList[next];
      _graphList[idx].order--;
      _graphList[next] = currentGraph;
    },
    lastGraphTitle: _lastGraphTitle
  };

  return GraphListFactory;
});

app.controller('GraphListCtrl', ($scope, GraphListFactory) => {

  $scope.getGraphList = GraphListFactory.getGraphList;
  $scope.graphTypes = ['ASR', 'ACD', 'Seizures', 'AnsDel', 'NoCirc', 'Normal', 'Failure'];

  $scope.spread = false;

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
    $scope.spread = !$scope.spread;
  };

  $scope.columnText = () => $scope.twoColumns.value ? "Single Column" : "Two Columns";
  $scope.spreadText = () => $scope.spread ? "Collapse" : "Expand";

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
