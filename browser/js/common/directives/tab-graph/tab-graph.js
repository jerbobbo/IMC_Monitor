app.factory('GraphFactory', function($http) {
  return {
    getData: function(params) {
      return $http.get('/api/graph-data', { params: params })
      .then(function(response) {
        return response.data;
      });
    },
    graphTypes: ['ASR', 'ACD', 'Seizures', 'AnsDel', 'NoCirc', 'Normal', 'Failure'],
    intervalTypes: ['daily', 'weekly', 'monthly', 'yearly'],
    originTypes: ['Origin', 'Term']
  };
});

//will be tab-graph in html tag
app.directive('tabGraph', function (GraphFactory, GraphAddFactory) {

    return {
        restrict: 'E',
        scope: {
          params: '=',
          name: '@',
          index: '@',
          spread: '='
        },
        templateUrl: 'js/common/directives/tab-graph/tab-graph.html',

        controller: function($scope, GraphFactory) {
          $scope.params.interval = "daily";
          $scope.datePickerId = 'date-' + $scope.index;

          angular.extend($scope, GraphFactory);

          var updateLists = (updatedField) => {

            var promiseArray = [];

            GraphAddFactory.getListNames(updatedField).forEach( (listName) => {
              var targetList = $scope[listName];
              promiseArray.push( GraphAddFactory.getList(listName, $scope.queryParams, targetList) );
            });

            return Promise.all(promiseArray)
              .catch(console.log);
          };

          $scope.updateGraph = (updatedField) => {

            $scope.queryParams = {
              country: $scope.params.country.country,
              routeCodeId: $scope.params.routeCode.id,
              originMemberId: $scope.params.originMember.id,
              termMemberId: $scope.params.termMember.id,
              originAddressId: $scope.params.originAddress.id,
              termAddressId: $scope.params.termAddress.id,
              gwId: $scope.params.gw.id,
              fromDate: $scope.params.fromDate,
              toDate: $scope.params.toDate,
              interval: $scope.params.interval
            };

            return $scope.getData($scope.queryParams)
            .then( (results) => {
              $scope.data = results;
              $scope.currType = $scope.currType || $scope.graphTypes[0];
              $scope.originTerm = $scope.originTerm || 'origin';
              if (updatedField) return updateLists(updatedField);
            });
          };

          //initialize lists with empty array
          GraphAddFactory.getListNames().forEach( (listName) => $scope[listName] = []);

          $scope.updateGraph()
          .then( () => updateLists() )
          .then( () => {
            $('.ui.dropdown').dropdown({ placeholder: false });
          });

          $scope.toggleState = (type) => $scope.currType = type;
          $scope.toggleOrigin = (type) => $scope.originTerm = type.toLowerCase();

          $scope.isCurrentType = (type) => $scope.currType == type;
          $scope.isCurrentOrigin = (type) => $scope.originTerm == type.toLowerCase();
          $scope.isCurrentInterval = (interval) => $scope.params.interval == interval;

          $scope.hasCurrParam = (param) => param && param.id !== '%';

          $scope.filterLabel = (abbr, listname, id, nameField) => {
            if (id !== '%') {
              var foundItem = $scope[listname].find( (item) => item.id === id );
              if (foundItem) return `${abbr} ${foundItem[nameField]}`;
            }
          };

          $scope.changeInterval = (interval) => {
            $scope.params.interval = interval;
            $scope.updateGraph();
          };

          $scope.$watch( 'index', () =>  $scope.updateGraph() );

          window.setInterval( () => $scope.updateGraph(), 300000 );

          function getOldestDate() {

            var intervalTypes = {
              daily: 7,
              weekly: 15,
              monthly: 65,
              yearly: 740
            };

            var oldestDate = moment.utc().subtract(intervalTypes[$scope.params.interval], 'days')
              .format('YYYY-MM-DD HH:MM');
            console.log(oldestDate);
            return oldestDate;
          }

           $scope.openDatePicker = () => {
            $(`#${$scope.datePickerId}`).daterangepicker(
              {
                timeZone: '00:00',
                format: 'YYYY-MM-DD HH:MM',
                timePicker: true,
                timePickerIncrement: 5,
                startDate: getOldestDate(),
                endDate: moment.utc().format('YYYY-MM-DD HH:MM')
              },
              function(start, end, label) {
                console.log('date picked');
                $scope.params.fromDate = start;
                $scope.params.toDate = end;
              }
            );
          };

        }

    };

});
