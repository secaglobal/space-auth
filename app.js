
/**
 * Module dependencies.
 */

require('coffee-script')

var express = require('express'),
    http = require('http'),
    path = require('path'),
    SpaceCore = require('space-core');

var app = express();

app.configure(function(){
    app.set('port', process.env.PORT || 4101);
    app.set('views', __dirname + '/views');
    app.set('view engine', 'jade');
    app.use(express.favicon());
    app.use(express.logger('dev'));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.cookieParser());

    app.use(SpaceCore.Ext.AccessControl);
    app.use(require('./lib/ext/auth'));

    app.use(app.router);
    app.use(express.static(path.join(__dirname, 'public')));
});

require('./config')(app)

http.createServer(app).listen(app.get('port'), function(){
    console.log("Express server listening on port " + app.get('port'));
});

module.exports = app