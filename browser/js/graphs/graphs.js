app.controller('GraphCtrl', ($scope, graphData, $stateParams, listCollection, $state) => {
  $scope.graphList = [];
  $scope.listCollection = listCollection;
  $scope.twoColumns = {
    value: true
  };

  if (graphData) {
    $scope.graphList = graphData.graphList;
    $scope.playlist = {
      id: $stateParams.playlistId || null,
      name: graphData.playlistName || ""
    };
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

});

app.config(function ($stateProvider) {
  $stateProvider.state('graphs', {
    url: '/graphs/:playlistId',
    templateUrl: 'js/graphs/graphs.html',
    controller: 'GraphCtrl',
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
