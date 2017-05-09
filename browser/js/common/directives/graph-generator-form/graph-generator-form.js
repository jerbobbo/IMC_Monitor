app.factory('GraphAddFactory', function($http) {

  return {

    getGateways: (queryParams) => {
      return $http.get('/api/gateways', { params: queryParams })
      .then( response => response.data );
    },
    getCountries: (queryParams) => {
      return $http.get('/api/countries', { params: queryParams })
      .then( response => response.data );
    },
    getOriginMembers: (queryParams) => {
      return $http.get('/api/members/origin', { params: queryParams })
      .then( response => response.data );
    },
    getTermMembers: (queryParams) => {
      return $http.get('/api/members/term', { params: queryParams })
      .then( response => response.data );
    },
    getOriginAddresses: (queryParams) => {
      return $http.get('/api/address/origin', { params: queryParams })
      .then( response => response.data );
    },
    getTermAddresses: (queryParams) => {
      return $http.get('/api/address/term', { params: queryParams })
      .then( response => response.data );
    },
    getRegionNames: (queryParams) => {
      return $http.get('/api/region-names/', { params: queryParams })
      .then( response => response.data );
    }
  };
});

app.controller('GraphAddCtrl', function($scope, GraphAddFactory, PlaylistFactory, GraphListFactory) {

  const currLists = [
    'gatewayList',
    'countryList',
    'originMemberList',
    'termMemberList',
    'originAddressList',
    'termAddressList',
    'regionList'
  ];

  //initialize lists with blank array
  currLists.forEach( (list) => $scope[list] = [] );

  $scope.updateLists = (updatedField) => {
    console.log('updating...');
    console.log($scope);
    var promiseArray = [];
    Object.keys(GraphAddFactory).forEach( (key) => {
      promiseArray.push(GraphAddFactory[key]( {
        country: $scope.currCountry,
        originMemberId: $scope.currOrigin.id,
        termMemberId: $scope.currTerm.id,
        originAddressId: $scope.currOriginAddress.id,
        termAddressId: $scope.currOriginAddress.id,
        routeCodeId: $scope.currRegion.id,
        gwId: $scope.currGw.id
      } ));
    } );

    return Promise.all(promiseArray)
    .then( (results) => {
      // console.log('results', results);
      // results.forEach( (result, idx) => angular.copy(result, $scope[ currLists[idx] ] ) );
      results.forEach( (result, idx) => $scope[ currLists[idx] ] = result );
      console.log('scope after update', $scope);
      $scope.$apply();
    })
    .catch(console.log);
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
    country: { country: '%' },
    region: { id: '%', region_name: 'All Regions' },
    origin: { id: '%', name: 'All' },
    term: { id: '%', name: 'All' },
    originAddress: { id: '%', name: 'All' },
    termAddress: { id: '%', name: 'All' },
    gw: { id: '%', address: 'All Gateways' }
  };

  // console.log($scope.defaults);

  $scope.currCountry = $scope.defaults.country.country;
  $scope.currRegion = $scope.defaults.region;
  $scope.currOrigin = $scope.defaults.origin;
  $scope.currTerm = $scope.defaults.term;
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
    // console.log('scopey', $scope);
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
