'use strict';
var session = require('express-session');
var path = require('path');
var Models = require(path.join(__dirname, '../../../db/models'));
var passport = require('passport');
var pg = require('pg');
var MySQLStore = require('express-mysql-session')(session);
var dbVariables = require(path.join(__dirname, '../../../../config/db-config'));

var ENABLED_AUTH_STRATEGIES = [
    'local'
];

var sessionStore = new MySQLStore({
  host: 'localhost',
  port: dbVariables.DATABASE_PORT,
  user: dbVariables.DATABASE_USER,
  password: dbVariables.DATABASE_PASS,
  database: dbVariables.DATABASE_URI
});

module.exports = function (app) {
    // First, our session middleware will set/read sessions from the request.
    // Our sessions will get stored in Mongo using the same connection from
    // mongoose. Check out the sessions collection in your MongoCLI.
    app.use(session({
        secret: app.getValue('env').SESSION_SECRET,
        store: sessionStore,
        resave: false,
        saveUninitialized: false,
        cookie: {maxAge: 30 * 24 * 60 * 60 * 1000 }
    }));

    // Initialize passport and also allow it to read
    // the request session information.
    app.use(passport.initialize());
    app.use(passport.session());

    // When we give a cookie to the browser, it is just the userId (encrypted with our secret).
    passport.serializeUser(function (user, done) {
        done(null, user.id);
    });

    // When we receive a cookie from the browser, we use that id to set our req.user
    // to a user found in the database.
    passport.deserializeUser(function (id, done) {
      var user;
        Models.User.find({ where: {id: id} })
        .then(function(_user) {
          user = _user;
          done(null, user);
        }, done);
    });

    // We provide a simple GET /session in order to get session information directly.
    // This is used by the browser application (Angular) to determine if a user is
    // logged in already.
    app.get('/session', function (req, res) {
        if (req.user) {
            res.send({ user: req.user.sanitize() });
        } else {
            res.status(401).send('No authenticated user.');
        }
    });

    // Simple /logout route.
    app.get('/logout', function (req, res) {
        req.logout();
        res.status(200).end();
    });

    // Each strategy enabled gets registered.
    ENABLED_AUTH_STRATEGIES.forEach(function (strategyName) {
        require(path.join(__dirname, strategyName))(app);
    });

};
