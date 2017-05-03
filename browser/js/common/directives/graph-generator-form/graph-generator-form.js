app.factory('GraphAddFactory', function($http) {

  return {

    getGateways: (queryParams) => {
      return $http.get('/api/gateways', { params: queryParams })
      .then(response => response.data);
    },
    getCountries: (queryParams) => {
      return $http.get('/api/countries', { params: queryParams })
      .then(response => response.data);
    },
    getOriginMembers: (queryParams) => {
      return $http.get('/api/members/origin', { params: queryParams })
      .then(response => response.data);
    },
    getTermMembers: (queryParams) => {
      return $http.get('/api/members/term', { params: queryParams })
      .then(response => response.data);
    },
    getOriginAddresses: (queryParams) => {
      return $http.get('/api/address/origin', { params: queryParams })
      .then(response => response.data);
    },
    getTermAddresses: (queryParams) => {
      return $http.get('/api/address/term', { params: queryParams })
      .then(response => response.data);
    },
    getRegionNames: (queryParams) => {
      return $http.get('/api/region-names/', { params: queryParams })
      .then(response => response.data);
    }
  };
});

app.controller('GraphAddCtrl', function($scope, GraphAddFactory, PlaylistFactory, GraphListFactory) {

  $scope.currCountry = "";
  //
  // $scope.getRegionList = function(countryName) {
  //   GraphAddFactory.getRegionNames(countryName)
  //   .then(function(_result) {
  //     $scope.currRegionList = _result;
  //   });
  // };

  $scope.updateLists = () => {
    console.log('you got here');
    Promise.map( Object.keys(GraphAddFactory), (key) => {
      return GraphAddFactory[key]( {
        country: $scope.currCountry,
        originMemberId: $scope.currOriginMemberId,
        termMemberId: $scope.currTermMemberId,
        originAddressId: $scope.currOriginAddressId,
        termAddressId: $scope.currOriginAddressId,
        routeCodeId: $scope.currRegion,
        gwId: $scope.currGw
      } );
    } )
    .then( (results) => {
      console.log('results', results);
      $scope.countryList = results[0];
      $scope.originMemberList = results[1];
      $scope.termMemberList = results[2];
      $scope.originAddressList = results[3];
      $scope.termAddressList = results[4];
      $scope.regionList = results[5];
      $scope.gatewayList = results[6];
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

  $scope.defaults = {
    region: { id: '%', region_name: 'All Regions' },
    origin: { id: '%', name: 'All' },
    term: { id: '%', name: 'All' },
    originAddress: { id: '%', name: 'All' },
    termAddress: { id: '%', name: 'All' },
    gw: { id: '%', address: 'All Gateways' }
  };

  // console.log($scope.defaults);

  $scope.currRegion = $scope.defaults.region;
  $scope.currOriginMemberId = $scope.defaults.origin;
  $scope.currTermMemberId = $scope.defaults.term;
  $scope.currOriginAddress = $scope.defaults.originAddress;
  $scope.currTermAddress = $scope.defaults.termAddress;
  $scope.currGw = $scope.defaults.gw;


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

  $scope.updateLists()
  .then( () => {
    console.log('scopey,' $scope);
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
