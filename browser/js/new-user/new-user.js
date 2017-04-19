app.config( function($stateProvider) {
  $stateProvider.state('new-user', {
    url: '/new-user',
    templateUrl: 'js/new-user/new-user.html',
    controller: 'NewUserCtrl'
  });
});

app.factory('NewUserFactory', ($http) => {
  return {
    createUser: (user) => {
      return $http.post('/api/users', user)
      .then( (newUser) => newUser.data );
    }
  };
});

app.controller('NewUserCtrl', ($scope, NewUserFactory, $state) => {
  $scope.createUser = () => {
    console.log($scope.user.password === $scope.user.passConfirm);
    if ($scope.user.password === $scope.user.passConfirm) {
      NewUserFactory.createUser($scope.user);
      $state.go('login');
    }
    };

  $('#new-user')
    .form({
      on: 'blur',
      fields: {
        match: {
          identifier  : 'passConfirm',
          rules: [
            {
              type   : 'match[pass]',
              prompt : 'Passwords do not match'
            }
          ]
        }
      }
    });
});
