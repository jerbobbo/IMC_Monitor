
app.controller('GraphsCtrl', ($scope, graphData, $stateParams, listCollection, $state, GraphListFactory) => {
  $scope.listCollection = listCollection;
  $scope.twoColumns = {
    value: true
  };

  $scope.isEmpty = GraphListFactory.isEmpty;
  $scope.existsPlaylist = () => $scope.playlist;

  console.log('playlist', $scope.playlist);

  if (graphData) {
    GraphListFactory.setGraphList(graphData.graphList);
    console.log(GraphListFactory.graphList);

    $scope.playlist = {
      id: $stateParams.playlistId || null,
      name: graphData.playlistName || ""
    };
  }
  else {
    GraphListFactory.clearGraphList();
    console.log(GraphListFactory.graphList);
  }

  $scope.clearGraphs = () => {
    $state.go('graphs', {playlistId: null});
    $scope.playlist = null;
  };

  $scope.showGraphGenerator = () => {
    $('.ui.sidebar')
      .sidebar('setting', 'transition', 'push')
      .sidebar('toggle');

    $scope.twoColumns.value = false;
  };

  $('#add-to-list')
    .popup({
      on: 'click'
  });

  $scope.$watch( () => $scope.existsPlaylist(),
    () => { console.log('playlist changed', $scope.existsPlaylist()) } );

  $scope.$watch( () => $scope.isEmpty(),
    () => { console.log('isEmpty() changed', $scope.isEmpty()) } );

});

app.config(function ($stateProvider) {
  $stateProvider.state('graphs', {
    url: '/graphs/:playlistId',
    templateUrl: 'js/graphs/graphs.html',
    controller: 'GraphsCtrl',
    resolve: {
      graphData: (GraphListFactory, $stateParams) => {
        if ($stateParams.playlistId) {
          return GraphListFactory.fetchGraphs($stateParams.playlistId)
          .then( (graphData) => graphData);
        }
      },
      listCollection: (PlaylistFactory) => {
        return PlaylistFactory.fetchPlaylists();
      }
    }
  });
});
