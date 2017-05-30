app.factory('GraphFactory', function($http) {
  return {
    getData: function(params) {
      return $http.get('/api/graph-data', { params: params })
      .then(function(response) {
        return response.data;
      });
    },
    graphTypes: ['ASR', 'ACD', 'Min/Ch', 'Seizures', 'AnsDel', 'NoCirc', 'Normal', 'Failure'],
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

          //format for sql query
          const dateFormat = 'YYYY-MM-DD HH:mm:ss';

          const dateDisplayFormat = 'MM/DD/YY HH:mm';



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
            //if country is changed, reset region to all
            if (updatedField === 'countryList') $scope.params.routeCode = GraphAddFactory.getDefaultVal('regionList');

            //if origin or term client is changed, reset ip to all
            else if (updatedField === 'originMemberList') $scope.params.originAddress = GraphAddFactory.getDefaultVal('originAddressList');
            else if (updatedField === 'termMemberList') $scope.params.termAddress = GraphAddFactory.getDefaultVal('termAddressList');

            $scope.queryParams = {
              country: $scope.params.country.country,
              routeCodeId: $scope.params.routeCode.id,
              originMemberId: $scope.params.originMember.id,
              termMemberId: $scope.params.termMember.id,
              originAddressId: $scope.params.originAddress.id,
              termAddressId: $scope.params.termAddress.id,
              gwId: $scope.params.gw.id,
              fromDate: $scope.params.fromDate.format(dateFormat),
              toDate: $scope.params.toDate.format(dateFormat),
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

          $scope.formatDate = (date) => date.format(dateDisplayFormat);

          $scope.changeInterval = (interval) => {
            $scope.params.interval = interval;
            setDefaultDates();
            $scope.updateGraph();
          };

          $scope.$watch( 'index', () =>  $scope.updateGraph() );

          window.setInterval( () => {
            //if using default range, update start and end time before re-rendering
            if ($scope.defaultRange) setDefaultDates();
            $scope.updateGraph();
          }, 300000 );

          function setCurrentDates(range) {
            $scope.params.fromDate = range[0];
            $scope.params.toDate = range[1];
          }

          function setDefaultDates() {
            var currRange = $scope.ranges[$scope.params.interval];
            setCurrentDates(currRange.ranges[currRange.default]);
            $scope.defaultRange = true;
          }

           $scope.openDatePicker = () => {
            $(`#${$scope.datePickerId}`).daterangepicker(
              {
                timeZone: '00:00',
                timePicker: true,
                timePicker24Hour: true,
                timePickerIncrement: 5,
                startDate: $scope.params.fromDate.floor(5, 'minutes'),
                endDate: $scope.params.toDate.floor(5, 'minutes'),
                minDate: $scope.ranges[$scope.params.interval].minDate,
                ranges: $scope.ranges[$scope.params.interval].ranges,
                format: dateDisplayFormat,
                autoUpdateInput: true,
                buttonClasses: ['ui mini button'],
                applyClass: 'primary'
              },
              function(start, end, label) {
                setCurrentDates([start, end]);
                $scope.defaultRange = false;
                $scope.updateGraph();
              }
            );
          };

        }

    };

});
