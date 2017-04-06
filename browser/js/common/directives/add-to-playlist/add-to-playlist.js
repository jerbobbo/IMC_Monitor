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
  PlaylistFactory.fetchPlaylists()
  .then( (_playlists) => {
    $scope.playlists = _playlists;
  });

  $scope.saveToPlaylist = () => {
    $scope.graphList.forEach( (graph) => PlaylistFactory.saveToList(graph, $scope.playlistId) );
  };


  $scope.createPlaylist = () => {
    var newList = {
      name: name
    };

    return PlaylistFactory.createPlaylist(newList)
    .then( (list) => {
      $scope.playlists.push(list);
      $scope.playlistId = list.id;
      $scope.saveToPlaylist();
    });
  };

  $scope.selectListId = (id) => {
    $scope.playlistId = id;
    console.log($scope);
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
      playlistId: '@'
    }
  };
});
