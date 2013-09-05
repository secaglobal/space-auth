ORM = require 'norman'

module.exports = (app) ->
    ORM.DataProvider.registerProxy 'default', new ORM.MysqlProxy
        host: 'localhost'
        user: 'test',
        password: '',
        database: 'test_space_auth',
        charset: 'utf8',
        #debug: ['ComQueryPacket']

    router = require('space-core').Router(app)
    router.processControllers("#{__dirname}/lib/web-api", '')
