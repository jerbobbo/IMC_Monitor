app.controller('GraphCtrl', ($scope, graphData, $stateParams, listCollection) => {
  $scope.graphList = [];
  $scope.listCollection = listCollection;

  if (graphData) {
    $scope.graphList = graphData.graphList;
    $scope.playlist = {
      id: $stateParams.playlistId || null,
      name: graphData.playlistName || ""
    };
  }

  $scope.showLists = () => {
    $('.ui.sidebar')
      .sidebar('setting', 'transition', 'overlay')
      .sidebar('toggle');
  };

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
