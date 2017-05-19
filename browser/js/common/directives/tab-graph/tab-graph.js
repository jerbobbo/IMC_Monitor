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
    originTypes: ['Origin', 'Term'],
    ranges: {
      daily: {
        ranges: {
          'Today': [moment.utc().subtract(1, 'days').subtract(6, 'hours'), moment.utc().subtract(5, 'minutes')],
          'Yesterday': [moment.utc().subtract(2, 'days').subtract(6, 'hours'), moment.utc().subtract(1, 'days')],
        },
        default: 'Today',
        minDate: moment.utc().subtract(7, 'days')
      },
      weekly: {
        ranges: {
          'This Week': [moment.utc().subtract(7, 'days').subtract(6, 'hours'), moment.utc().subtract(5, 'minutes')],
          'Last Week': [moment.utc().subtract(14, 'days').subtract(6, 'hours'), moment.utc().subtract(7, 'days')],
        },
        default: 'This Week',
        minDate: moment.utc().subtract(15, 'days')
      },
      monthly: {
        ranges: {
          'This Month': [moment.utc().subtract(31, 'days'), moment.utc().subtract(5, 'minutes')],
          'Last Month': [moment.utc().subtract(61, 'days'), moment.utc().subtract(30, 'days')],
        },
        default: 'This Month',
        minDate: moment.utc().subtract(65, 'days')
      },
      yearly: {
        ranges: {
          'This Year': [moment.utc().subtract(367, 'days'), moment.utc().subtract(5, 'minutes')],
          'Last Year': [moment.utc().subtract(732, 'days'), moment.utc().subtract(365, 'days')],
        },
        default: 'This Year',
        minDate: moment.utc().subtract(740, 'days')
      }
    }
  };
});

//will be tab-graph in html tag
app.directive('tabGraph', function () {

    return {
        restrict: 'E',
        scope: {
          params: '=',
          name: '@',
          index: '@',
          spread: '='
        },
        templateUrl: 'js/common/directives/tab-graph/tab-graph.html',

        controller: function($scope, GraphFactory, GraphAddFactory) {
          $scope.params.interval = "daily";
          $scope.datePickerId = 'date-' + $scope.index;

          angular.extend($scope, GraphFactory);

          //format for sql query
          const dateFormat = 'YYYY-MM-DD HH:mm:ss';

          const dateDisplayFormat = 'MM/DD/YY HH:mm';



          // var updateLists = (updatedField) => {
          //
          //   var promiseArray = [];
          //
          //   GraphAddFactory.getListNames(updatedField).forEach( (listName) => {
          //     var targetList = $scope[listName];
          //     promiseArray.push( GraphAddFactory.getList(listName, queryParams, targetList) );
          //   });
          //
          //   return Promise.all(promiseArray)
          //     .catch(console.log);
          // };

          $scope.updateGraph = (params) => {

            var queryParams = {
              country: params.country.country,
              routeCodeId: params.routeCode.id,
              originMemberId: params.originMember.id,
              termMemberId: params.termMember.id,
              originAddressId: params.originAddress.id,
              termAddressId: params.termAddress.id,
              gwId: params.gw.id,
              fromDate: params.fromDate.format(dateFormat),
              toDate: params.toDate.format(dateFormat),
              interval: $scope.interval
            };

            return $scope.getData(queryParams)
            .then( (results) => {
              $scope.data = results;
              $scope.currType = $scope.currType || $scope.graphTypes[0];
              $scope.originTerm = $scope.originTerm || 'origin';
              // if (updatedField) return updateLists(updatedField);
            });
          };

          setDefaultDates();
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

          $scope.getRanges = () => $scope.ranges[$scope.params.interval].ranges;
          $scope.getMinDate = () => $scope.ranges[$scope.params.interval].minDate;

          $scope.formatDate = (date) => date.format(dateDisplayFormat);

          $scope.changeInterval = (interval) => {
            $scope.params.interval = interval;
            setDefaultDates();
            $scope.updateGraph();
          };

         function setDefaultDates() {
           var currRange = $scope.ranges[$scope.params.interval];
           setCurrentDates(currRange.ranges[currRange.default]);
           $scope.defaultRange = true;
         }

          $scope.$watch( 'index', () =>  $scope.updateGraph() );

          window.setInterval( () => {
            //if using default range, update start and end time before re-rendering
            if ($scope.defaultRange) setDefaultDates();
            $scope.updateGraph();
          }, 300000 );







        }

    };

});
