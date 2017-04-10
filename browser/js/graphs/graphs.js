app.controller('GraphCtrl', ($scope, graphData, $stateParams) => {
  $scope.graphList = [];
  if (graphData) {
    $scope.graphList = graphData.graphList;
    $scope.playlist = {
      id: $stateParams.playlistId || null,
      name: graphData.playlistName || ""
    };
  }
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
      }
    }
  });
});
