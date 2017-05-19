app.directive("filter", function (d3Service, $window) {

  return {
      restrict: "E",
      scope: {
        updateFunc: '&',
        datePickerId: '@'
      },
      templateUrl: "js/common/directives/filter/filter.html",
      controller: 'FilterCtrl'
  };
});

app.controller('FilterCtrl', ($scope, GraphAddFactory) => {

  var updateLists = (updatedField) => {

    var promiseArray = [];

    GraphAddFactory.getListNames(updatedField).forEach( (listName) => {
      var targetList = $scope[listName];
      promiseArray.push( GraphAddFactory.getList(listName, $scope.queryParams, targetList) );
    });

    return Promise.all(promiseArray)
      .catch(console.log);
  };

  $scope.update = (updatedList) => {
    //if country is changed, reset region to all
    if (updatedList === 'countryList') $scope.params.routeCode = GraphAddFactory.getDefaultVal('regionList');

    //if origin or term client is changed, reset ip to all
    else if (updatedList === 'originMemberList') $scope.params.originAddress = GraphAddFactory.getDefaultVal('originAddressList');
    else if (updatedList === 'termMemberList') $scope.params.termAddress = GraphAddFactory.getDefaultVal('termAddressList');

    return updateLists(updatedList)
    .then( () => $scope.updateFunc($scope.params) );
  };

  $scope.openDatePicker = () => {
   $(`#${$scope.datePickerId}`).daterangepicker(
     {
       timeZone: '00:00',
       timePicker: true,
       timePicker24Hour: true,
       timePickerIncrement: 5,
       startDate: $scope.params.fromDate.floor(5, 'minutes'),
       endDate: $scope.params.toDate.floor(5, 'minutes'),
       minDate: $scope.getMinDate(),
       ranges: $scope.getRanges(),
       format: dateDisplayFormat,
       autoUpdateInput: true,
       buttonClasses: ['ui mini button'],
       applyClass: 'primary'
     },
     function(start, end, label) {
       setCurrentDates([start, end]);
       $scope.defaultRange = false;
       $scope.updateFunc();
     }
   );
 };

 function setCurrentDates(range) {
   $scope.params.fromDate = range[0];
   $scope.params.toDate = range[1];
 }


});
