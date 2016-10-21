var permission = function(roles) {
  return function(req, res, next) {
    // if user is an admin or there's nothing to check, we're good!
    if (req.user.currentSchemaAdmin || !roles || roles.length === 0){
      return next();
    }
    // authorized role array is stored on the user object
    var userRoles = req.user.currentSchemaRoles || [];
    var isAuthorized = true;

    // loop through required roles and determine whether user has all of them
    for (var role in roles) {
      if (userRoles.indexOf(role) === -1) {
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

module.exports = {
  permission: permission
};
