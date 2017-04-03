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
    saveToList: (graphList) => {

    }
  };
});

app.controller('PlaylistCtrl', ($scope, PlaylistFactory) => {
  PlaylistFactory.fetchPlaylists()
  .then( (_playlists) => {
    $scope.playlists = _playlists;
  });

  $scope.createPlaylist = (name) => {
    var newList = {
      name: name
    };

    PlaylistFactory.createPlaylist(newList)
    .then( (list) => {
      $scope.playlists.push(list);
    });
  };

  $scope.printList = () => console.log($scope.graphList);

});

app.directive('addToPlaylist', (PlaylistFactory) => {
  return {
    restrict: 'E',
    templateUrl: 'js/common/directives/add-to-playlist/add-to-playlist.html',
    controller: 'PlaylistCtrl',
    scope: {
      graphList: '='
    }
  };
});
