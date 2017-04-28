app.factory('GraphAddFactory', function($http) {
  return {
    getGateways: function() {
      return $http.get('/api/gateways')
      .then(response => response.data);
    },
    getCountries: function() {
      return $http.get('/api/countries')
      .then(response => response.data);
    },
    getMembers: function() {
      return $http.get('/api/members')
      .then(response => response.data);
    },
    getRegionNames: function(countryName) {
      if (!countryName) countryName = '';
      return $http.get('/api/region-names/' + countryName)
      .then(response => response.data);
    }
  };
});

app.controller('GraphAddCtrl', function($scope, GraphAddFactory, PlaylistFactory, GraphListFactory) {

  $scope.currCountry = "";

  $scope.getRegionList = function(countryName) {
    GraphAddFactory.getRegionNames(countryName)
    .then(function(_result) {
      $scope.currRegionList = _result;
    });
  };

  var addToList = function(graphParams) {
    GraphListFactory.addToGraphList(graphParams);
    if ($scope.playlist) {
      PlaylistFactory.saveToList(
        GraphListFactory.getLastGraph(),
        $scope.playlist.id
      );
    }
  };

  $scope.currRegion = { id: '%', region_name: 'All Regions' };
  $scope.currOrigin = { id: '%', name: 'All Clients' };
  $scope.currTerm = { id: '%', name: 'All Clients' };
  $scope.currGw = { id: '%', address: 'All Gateways' };

  $scope.addGraph = function() {

    var newGraphParams = {
      country: {
        name: $scope.currCountry
      },
      routeCode: {
        id: $scope.currRegion.id,
        name: $scope.currRegion.region_name
      },
      originMember: {
        id: $scope.currOrigin.id,
        name: $scope.currOrigin.name
      },
      termMember: {
        id: $scope.currTerm.id,
        name: $scope.currTerm.name
      },
      gw: {
        id: $scope.currGw.id,
        name: $scope.currGw.address
      }
    };

    addToList(newGraphParams);
  };

  $scope.noCurrCountry = function() {
    return $scope.currCountry === "";
  };

  GraphAddFactory.getGateways()
  .then(function(_result) {
    $scope.gatewayList = _result;
    return GraphAddFactory.getCountries();
  })
  .then(function(_result) {
    $scope.countryList = _result;
    return GraphAddFactory.getMembers();
  })
  .then(function(_result) {
    $scope.memberList = _result;
    $('.ui.dropdown').dropdown({ placeholder: false });
  });

});

app.directive('graphGeneratorForm', () => {
  return {
    restrict: 'E',
    scope: {
      playlist: '='
    },
    templateUrl: '/js/common/directives/graph-generator-form/graph-generator-form.html',
    controller: 'GraphAddCtrl'
  };
});
