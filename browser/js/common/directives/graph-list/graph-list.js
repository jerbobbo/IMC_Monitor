app.directive('graphList', () => {
  return {
    restrict: 'E',
    scope: {
      graphList: '='
    },
    templateUrl: '/js/common/directives/graph-list/graph-list.html'
    // controller: 'GraphListCtrl'
  };
});
