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

app.controller('PlaylistCtrl', ($scope, PlaylistFactory, $state) => {
  // PlaylistFactory.fetchPlaylists()
  // .then( (_playlists) => {
  //   $scope.playlists = _playlists;
  // });


  $scope.saveToPlaylist = (targetListId, listExists) => {
    $scope.graphList.forEach( (graph) => PlaylistFactory.saveToList(graph, targetListId, listExists) );
  };


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
      $state.go('graphs', { playlistId: list.id });
    });
  };

  $scope.selectListId = (id) => {
    $scope.playlist.id = id;
  };

  $scope.printList = () => console.log($scope.graphList);
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
      graphList: '=',
      playlist: '=',
      listCollection: '='
    }
  };
});
