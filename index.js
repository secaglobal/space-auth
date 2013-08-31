require('coffee-script');

module.exports = {
    Ext: {
        Auth: require('./lib/ext/auth')
    },

    Model: {
        UserSession: require('./lib/model/user/session'),
        User: require('./lib/model/user')
    },

    route: function(router, point) {
        router.processControllers(__dirname + "/lib/web-api", point)
    }
};