require('coffee-script');

module.exports = {
    Ext: {
        Auth: require('./lib/ext/auth')
    },

    Model: {
        UserSession: require('./lib/user/session'),
        User: require('./lib/user')
    },

    route: function(router, point) {
        router.processControllers(__dirname + "/lib/web-api", point)
    }
};