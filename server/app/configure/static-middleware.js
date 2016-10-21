"use strict";
var path = require('path');
var express = require('express');
var favicon = require('serve-favicon');

module.exports = function (app) {

    var root = app.getValue('projectRoot');
    var bowerPath = path.join(root, './bower_components');
    var npmPath = path.join(root, './node_modules');
    var publicPath = path.join(root, './public');
    var browserPath = path.join(root, './browser');
    var semanticPath = path.join(root, './semantic');
    var imagesPath = path.join(root, './assets/images');
    var fontsPath = path.join(root, './assets/fonts');

    app.use(favicon(app.getValue('faviconPath')));
    app.use('/bower', express.static(bowerPath));
    app.use(express.static(npmPath));
    app.use(express.static(publicPath));
    app.use(express.static(browserPath));
    app.use('/semantic', express.static(semanticPath));
    app.use('/images', express.static(imagesPath));
    app.use('/fonts', express.static(fontsPath));

};
