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

app.controller('GraphAddCtrl', function($scope, GraphAddFactory) {
  $scope.currGraphList = [];
  $scope.currCountry = "";

  var testGraph = {
    whereClause: "country=Egypt",
    graphTitle: 'Egypt'
  };

  $scope.getRegionList = function(countryName) {
    GraphAddFactory.getRegionNames(countryName)
    .then(function(_result) {
      $scope.currRegionList = _result;
    });
  };

  var addToList = function(graphParams) {
    $scope.currGraphList.push(graphParams);
  };

  function clearCurrents() {
    ['currCountry', 'currRegion', 'currOrigin', 'currTerm', 'currGw']
    .forEach( (field) => {
      $scope[field] = "";
    });
    $('.dropdown').dropdown('clear');
    // console.log($scope);

  }

  $scope.addGraph = function() {
    var whereClause = "";
    var graphTitle = "";
    if (!!$scope.currCountry) {
      whereClause += "country=" + $scope.currCountry;
      graphTitle = $scope.currCountry;
    }
    if (!!$scope.currRegion) {
      whereClause += "&routeCodeId=" + $scope.currRegion.id;
      graphTitle += ' | ' + $scope.currRegion.region_name;
    }
    if (!!$scope.currOrigin) {
      whereClause += "&originMemberId=" + $scope.currOrigin.id;
      graphTitle += ' | Originating: ' + $scope.currOrigin.name;
    }
    if (!!$scope.currTerm) {
      whereClause += "&termMemberId=" + $scope.currTerm.id;
      graphTitle += ' | Terminating: ' + $scope.currTerm.name;
    }
    if (!!$scope.currGw) {
      whereClause += "&gwId=" + $scope.currGw.id;
      graphTitle += ' | ' + $scope.currGw.address;
    }

    var newGraphParams = {
      whereClause: whereClause,
      graphTitle: graphTitle
    };

    addToList(newGraphParams);
    console.trace('addtoList');
    // $('select').dropdown('clear');
    clearCurrents();
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
    $('.ui.dropdown').dropdown();
    // addToList(testGraph);
  });
});


app.config(function ($stateProvider) {
  $stateProvider.state('graph-generator', {
    url: '/graph-generator',
    templateUrl: 'js/graph-generator/graph-generator.html',
    controller: 'GraphAddCtrl'
  });
});

app.factory('GraphFactory', function($http) {
  return {
    getData: function(params) {
      return $http.get('/api/graph-data?' + params)
      .then(function(response) {
        return response.data;
      });
    }
  };
});
