app.factory('PlaylistFactory', ($http) => {
  return {
    fetchPlaylists: () => {
      return $http.get('/api/playlists')
      .then( (results) => results.data);
    },
    createPlaylist: (newList) => {
      return $http.post('/api/playlists', newList)
      .then( (results) => results.data);
    },
    saveToList: (graph, playlistId, listExists) => {
      //if playlist exists, change order to be last item in list
      if (listExists) {
        return $http.get(`/api/playlists/${playlistId}`)
        .then( (results) => {
          console.log('results.data', results.data);
          graph.order = results.data.playlist_graphs.length;
          return $http.post(`/api/playlists/${playlistId}/playlist-graph`, graph);
        })
        .then( (results) => results.data);
      }
      return $http.post(`/api/playlists/${playlistId}/playlist-graph`, graph)
      .then( (results) => results.data);
    }
  };
});

app.controller('PlaylistCtrl', ($scope, PlaylistFactory, $state, GraphListFactory) => {

  $scope.saveToPlaylist = (targetListId, listExists) => {
    GraphListFactory.getGraphList().forEach( (graph) => PlaylistFactory.saveToList(graph, targetListId, listExists) );
  };

  console.log('playlist', $scope.playlist);
  // console.log('isEmpty', $scope.isEmpty());

  $scope.createPlaylist = () => {
    var newList = {
      name: $scope.newListName
    };

    return PlaylistFactory.createPlaylist(newList)
    .then( (list) => {
      $scope.listCollection.push(list);
      $scope.playlist = {
        id: list.id,
        name: list.name,
      };

      $scope.saveToPlaylist($scope.playlist.id, false);
      $scope.newListName = null;
      $state.go('graphs', { playlistId: list.id });
    });
  };

  $scope.selectListId = (id) => {
    $scope.playlist.id = id;
  };

  $scope.printScope = () => console.log($scope);

  $('#add-to-list')
    .popup({
      on: 'click'
    });


});

app.directive('addToPlaylist', (PlaylistFactory) => {
  return {
    restrict: 'E',
    templateUrl: 'js/common/directives/add-to-playlist/add-to-playlist.html',
    controller: 'PlaylistCtrl',
    scope: {
      playlist: '=',
      listCollection: '='
    }
  };
});
