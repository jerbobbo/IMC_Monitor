app.factory('PlaylistFactory', ($http) => {
  return {
    fetchPlaylists: () => {
      return $http.get('/api/playlists')
      .then( (results) => results.data);
    },
    createPlaylist: (newList) => {
      return $http.post('/api/playlists', newList)
      .then( (results) => results.data);
    }
  };
});

app.controller('PlaylistCtrl', ($scope, PlaylistFactory) => {
  PlaylistFactory.fetchPlaylists()
  .then( (_playlists) => {
    $scope.playlists = _playlists;
  });

  $scope.createPlaylist = PlaylistFactory.createPlaylist;
  
});

app.directive('addToPlaylist', (PlaylistFactory) => {
  return {
    restrict: 'E',
    templateUrl: 'js/common/directives/add-to-playlist/add-to-playlist.html',
    controller: 'PlaylistCtrl'
  };
});
