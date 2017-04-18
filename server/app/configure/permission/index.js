var permission = function(roles) {

  return function(req, res, next) {
    // if user is an admin or there's nothing to check, we're good!
    if (req.user.adminPermission || !roles ){
      return next();
    }
    var isAuthorized = true;

    // loop through required roles and determine whether user has all of them
    for (var role in roles) {
      if (!req.user[role]) {
        isAuthorized = false;
      }
    }
    // if user has all required roles, we're good, otherwise send forbidden status
    if (isAuthorized) {
      next();
    } else {
      next({status: 401});
    }
  };
};

module.exports = permission;
