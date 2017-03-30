app.controller('GraphGeneratorCtrl', ($scope) => {
  $scope.graphList = [];
});

app.config(function ($stateProvider) {
  $stateProvider.state('graph-generator', {
    url: '/graph-generator',
    templateUrl: 'js/graph-generator/graph-generator.html',
    controller: 'GraphGeneratorCtrl'
  });
});
