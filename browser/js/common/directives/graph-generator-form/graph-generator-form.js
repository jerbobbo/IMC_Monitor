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
  // $scope.graphList = [];
  $scope.currCountry = "";
  // var graphCount = 0;
  $scope.graphList = GraphListFactory.graphList;

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
    // console.log($scope.graphList);
    $scope.graphList.push(graphParams);
    if ($scope.playlist) {
      PlaylistFactory.saveToList(graphParams, $scope.playlist.id);
    }
  };

  $scope.addGraph = function() {
    var graphTitle = "";
    var graphOrder = $scope.graphList.length;
    var graphId = new Date().getTime();
    // var graphId = $scope.graphList.length+1;

    var titleDivider = () => {
      if (graphTitle !== "") return " | ";
      return "";
    };

    // var addToTitle = ( parameters ) => {
    //   parameters.forEach( (parameter) => {
    //     if (parameter) graphTitle += titleDivider() + parameter.title + parameter.data;
    //   });
    // };
    //
    // var parameterList = [
    //   {
    //     title: "",
    //     data: $scope.currCountry || ""
    //   },
    //   {
    //     title: "",
    //     data: $scope.currRegion.region_name || ""
    //   },
    //   {
    //     title: "Originating: ",
    //     data: $scope.currOrigin.name || ""
    //   },
    //   {
    //     title: "Terminating: ",
    //     data: $scope.currTerm.name || ""
    //   },
    //   {
    //     title: "",
    //     data: $scope.currGw.address || ""
    //   }
    // ];

    // addToTitle(parameterList);

    var country, routeCodeId, originMemberId, termMemberId, gwId;

    if (!!$scope.currCountry) {
      country = $scope.currCountry;
      graphTitle = $scope.currCountry;
    }
    if (!!$scope.currRegion) {
      routeCodeId = $scope.currRegion.id;
      graphTitle += titleDivider() + $scope.currRegion.region_name;
    }
    if (!!$scope.currOrigin) {
      originMemberId = $scope.currOrigin.id;
      graphTitle += titleDivider() + 'Originating: ' + $scope.currOrigin.name;
    }
    if (!!$scope.currTerm) {
      termMemberId = $scope.currTerm.id;
      graphTitle += titleDivider() + 'Terminating: ' + $scope.currTerm.name;
    }
    if (!!$scope.currGw) {
      gwId = $scope.currGw.id;
      graphTitle += titleDivider() + $scope.currGw.address;
    }


    var newGraph = {
      params: {
        country: country || '%',
        routeCodeId: routeCodeId || '%',
        originMemberId: originMemberId || '%',
        termMemberId: termMemberId || '%',
        gwId: gwId || '%'
      },
      graphTitle: graphTitle,
      id: graphId,
      order: graphOrder
    };

    addToList(newGraph);
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
    // $('.ui.dropdown').dropdown();
    $('.ui.dropdown').dropdown({ placeholder: false });
    // addToList(testGraph);
  });

  $scope.$watch( () => $scope.graphList,
    () => { console.log('graphList changed', $scope.graphList) } );

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
