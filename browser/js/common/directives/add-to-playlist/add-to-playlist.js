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
    saveToList: (graph, playlistId) => {
      return $http.post(`/api/playlists/${playlistId}/playlist-graph`, graph)
      .then( (results) => results.data);
    }
  };
});

app.controller('PlaylistCtrl', ($scope, PlaylistFactory) => {
  // PlaylistFactory.fetchPlaylists()
  // .then( (_playlists) => {
  //   $scope.playlists = _playlists;
  // });

  $('#add-to-list')
    .popup({
      on: 'click'
    });

  $scope.saveToPlaylist = (targetListId) => {
    $scope.graphList.forEach( (graph) => PlaylistFactory.saveToList(graph, targetListId) );
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

      $scope.saveToPlaylist($scope.playlist.id);
    });
  };

  $scope.selectListId = (id) => {
    $scope.playlist.id = id;
  };

  $scope.printList = () => console.log($scope.graphList);
  $scope.printScope = () => console.log($scope);

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
