global.LIBS_PATH = "#{__dirname}/../lib"

ORM = require 'norman'
dataProvider = ORM.DataProvider
MysqlProxy = ORM.MysqlProxy
MysqlQueryBuilder = ORM.MysqlQueryBuilder
Q = require 'q'
chai = require 'chai'
_ = require 'underscore'

chai.should()
global.expect = chai.expect
global.sinon = require 'sinon'


dataProvider.registerProxy("default", new MysqlProxy(
    host      : 'localhost',
    user      : 'test',
    password  : '',
    database  : 'test_space_auth',
    charset   : 'utf8',
#    debug     : ['ComQueryPacket']
#    debug     : ['ComQueryPacket', 'RowDataPacket']
))

global.loadFixtures = (data) ->
    deferred = Q.defer()
    promises = []
    proxy = dataProvider.getProxy 'default'

    for table, records of data
        promises.push proxy.perform("truncate #{table}")

        if records.length
            fields = _.keys(records[0]).sort()
            rows = []

            for record in records
                row = []
                rows.push row

                for field in fields
                    row.push(record[field] or null)

            query = new MysqlQueryBuilder()
                    .setTable(table)
                    .setFields(fields)
                    .insertValues(rows)
                    .compose()

            promises.push proxy.perform(query)

    Q.allSettled(promises).then (results) ->
        results.forEach (result) ->
            if result.state isnt "fulfilled"
                deferred.reject result.reason
        deferred.resolve()

    return deferred.promise
