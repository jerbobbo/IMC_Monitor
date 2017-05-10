app.factory('GraphAddFactory', function($http) {

  const _listUrls = {
    gatewayList: '/api/gateways',
    countryList: '/api/countries',
    originMemberList: '/api/members/origin',
    termMemberList: '/api/members/term',
    originAddressList: '/api/address/origin',
    termAddressList: '/api/address/term',
    regionList: '/api/region-names'
  };

  const _defaultVals = {
    countryList: { country: '%' },
    regionList: { id: '%', region_name: 'All Regions' },
    originMemberList: { id: '%', name: 'All' },
    termMemberList: { id: '%', name: 'All' },
    originAddressList: { id: '%', address: 'All' },
    termAddressList: { id: '%', address: 'All' },
    gatewayList: { id: '%', address: 'All Switches' }
  };

  return {

    getList: (listName, queryParams, targetArr) => {
      return $http.get(_listUrls[listName], {params: queryParams})
      .then( response => {
        angular.copy(response.data, targetArr);
        targetArr.unshift(_defaultVals[listName]);
      })
      .catch(console.log);
    },
    getListNames: (updatedField) => Object.keys(_listUrls).filter( (key) => key !== updatedField ),
    getDefaultVal: (listName) => _defaultVals[listName]
  };

});

app.controller('GraphAddCtrl', function($scope, GraphAddFactory, PlaylistFactory, GraphListFactory) {

  $scope.currCountry = GraphAddFactory.getDefaultVal('countryList');
  $scope.currRegion = GraphAddFactory.getDefaultVal('regionList');
  $scope.currOrigin = GraphAddFactory.getDefaultVal('originMemberList');
  $scope.currTerm = GraphAddFactory.getDefaultVal('termMemberList');
  $scope.currOriginAddress = GraphAddFactory.getDefaultVal('originAddressList');
  $scope.currTermAddress = GraphAddFactory.getDefaultVal('termAddressList');
  $scope.currGw = GraphAddFactory.getDefaultVal('gatewayList');

  $scope.updateLists = (updatedField) => {
    var queryParams = {
      country: $scope.currCountry.country,
      originMemberId: $scope.currOrigin.id,
      termMemberId: $scope.currTerm.id,
      originAddressId: $scope.currOriginAddress.id,
      termAddressId: $scope.currOriginAddress.id,
      routeCodeId: $scope.currRegion.id,
      gwId: $scope.currGw.id
    };

    var promiseArray = [];

    GraphAddFactory.getListNames(updatedField).forEach( (listName) => {
      var targetList = $scope[listName];
      promiseArray.push( GraphAddFactory.getList(listName, queryParams, targetList) );
    });

    return Promise.all(promiseArray)
      .catch(console.log);
  };

  //initialize lists with empty array
  GraphAddFactory.getListNames().forEach( (listName) => $scope[listName] = []);

  $scope.updateLists()
  .then( () => {
    console.log($scope);
    $('.ui.dropdown').dropdown({ placeholder: false });
  });

  var addToList = function(graphParams) {
    GraphListFactory.addToGraphList(graphParams);
    if ($scope.playlist) {
      PlaylistFactory.saveToList(
        GraphListFactory.getLastGraph(),
        $scope.playlist.id
      );
    }
  };

  $scope.addGraph = function() {

    var newGraphParams = {
      country: {
        country: $scope.currCountry.country
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
      originAddress: {
        id: $scope.currOriginAddress.id,
        address: $scope.currOriginAddress.address
      },
      termAddress: {
        id: $scope.currTermAddress.id,
        address: $scope.currTermAddress.name
      },
      gw: {
        id: $scope.currGw.id,
        name: $scope.currGw.address
      }
    };

    addToList(newGraphParams);
  };

  $scope.noCurrCountry = () => $scope.currCountry.country === "%";

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
